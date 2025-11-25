extends CharacterBody2D

@onready var progress_bar: ProgressBar = $CanvasLayer/ProgressBar
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var recibir_daño: Area2D = $"Recibir Daño"
@onready var marker_2d: Marker2D = $Marker2D
@onready var timer: Timer = $Timer
@onready var jefe_1: CharacterBody2D = $"."
@onready var recibir_daño_2: Area2D = $RecibirDaño2
@onready var canvas_escenarios: CanvasLayer = $"../../CanvasEscenarios"
#----- Estadísticas -----
var Salud: int = 1500
var SaludMax: int = 1500
var Fase: int = 1
var puedeserdañada: bool = true

var en_transicion: bool = false

#----- Sistema de spawn -----
var spawn_timer: Timer
var intervalo_spawn_fase1: float = 3.5
var intervalo_spawn_fase2: float = 1.5
var cantidad_max_avispas: int = 8
var avispas_activas: Array = []

const AVISPA_DE_MAMA = preload("res://Scena/Enemigos/Jefes/Avispa de MAMA.tscn")

func _ready():
	progress_bar.max_value = SaludMax
	progress_bar.value = Salud


func _physics_process(_delta):
	progress_bar.value = Salud

# --- Daño recibido ---
func _on_recibir_daño_area_entered(area: Area2D) -> void:
	if en_transicion: return
	if area.is_in_group("Proyectiles") and puedeserdañada:
		Recibir_daño(EstadisticasDelPlayer.daño_disparo)
		area.queue_free()

func Recibir_daño(dmg):
	Salud -= dmg
	if Salud <= 0:
		Morir()

# --- Transición entre fases ---
func Morir():
	if en_transicion: return
	en_transicion = true
	puedeserdañada = false

	# Pausar spawn mientras se transforma o muere
	if spawn_timer:
		spawn_timer.stop()

	await animar_muerte_falsa()

	if Fase == 1:
		await iniciar_segunda_fase()
	else:
		await animar_muerte_real()

func animar_muerte_falsa() -> void:
	animated_sprite_2d.play("transformacion")
	
	var tween = get_tree().create_tween()
	tween.tween_property(animated_sprite_2d, "scale", animated_sprite_2d.scale * 0.5, 0.8).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	await tween.finished

	await get_tree().create_timer(1.5).timeout
	progress_bar.hide()
	await get_tree().create_timer(0.5).timeout

func iniciar_segunda_fase() -> void:
	Fase = 2
	
	SaludMax = 2500
	Salud = SaludMax
	progress_bar.max_value = SaludMax
	progress_bar.value = Salud
	progress_bar.show()

	# --- Transformación épica ---
	var tween = get_tree().create_tween()
	tween.tween_property(jefe_1, "scale", Vector2(3, 3), 2.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	await tween.finished

	animated_sprite_2d.play("transformacion")
	await get_tree().create_timer(2).timeout

	# Activar nueva frecuencia de spawn
	timer.start(2.0)

	puedeserdañada = true
	en_transicion = false
	animated_sprite_2d.play("idle")
	recibir_daño.monitoring=false
	recibir_daño_2.monitoring=true
	

func animar_muerte_real() -> void:
	animated_sprite_2d.play("transformacion")
	var tween = get_tree().create_tween()
	tween.tween_property(jefe_1, "scale", Vector2(0, 0), 2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	await tween.finished

	progress_bar.hide()
	await get_tree().create_timer(1).timeout
	AudioController.muerte_mama()
	queue_free()
	canvas_escenarios.activarPanel()
	

# --- Spawn de avispas ---
func _on_spawn_timer_timeout() -> void:
	if en_transicion: return
	if avispas_activas.size() >= cantidad_max_avispas:
		return
	
	spawn_avispa()

func spawn_avispa():
	var nueva_avispa = AVISPA_DE_MAMA.instantiate()
	
	if Fase == 1:
		# --- FASE 1: spawnea desde el marcador ---
		nueva_avispa.global_position = marker_2d.global_position
	else:
		# --- FASE 2: spawnea desde un borde aleatorio de la pantalla ---
		var viewport_rect = get_viewport_rect()
		var lado = randi() % 4  # 0=izq, 1=der, 2=arriba, 3=abajo
		var spawn_pos = Vector2.ZERO
		
		match lado:
			0:
				spawn_pos = Vector2(0, randf() * viewport_rect.size.y)
			1:
				spawn_pos = Vector2(viewport_rect.size.x, randf() * viewport_rect.size.y)
			2:
				spawn_pos = Vector2(randf() * viewport_rect.size.x, 0)
			3:
				spawn_pos = Vector2(randf() * viewport_rect.size.x, viewport_rect.size.y)
		
		# Convertir a coordenadas globales según la cámara
		spawn_pos += get_viewport().get_camera_2d().global_position - (viewport_rect.size / 2)
		nueva_avispa.global_position = spawn_pos
	
	get_tree().current_scene.add_child(nueva_avispa)
	avispas_activas.append(nueva_avispa)

	# Quitar de la lista cuando muera o salga del árbol
	if nueva_avispa.has_signal("tree_exited"):
		nueva_avispa.tree_exited.connect(func(): avispas_activas.erase(nueva_avispa))


func _on_recibir_daño_2_area_entered(area: Area2D) -> void:
	if en_transicion: return
	if area.is_in_group("Proyectiles") and puedeserdañada:
		Recibir_daño(EstadisticasDelPlayer.daño_disparo)
		area.queue_free()
