extends CharacterBody2D

# --- Proyectil del player ---
const PROYECTIL = preload("res://Scena/Player/proyectil del player/proyectil.tscn")
@onready var joystick: Node2D = $"../CanvasLayer/Joystick"

# --- Variables principales ---
@export var velocidad: float = 100.0
@export var fuerza_salto: float = -200
@export var gravedad: float = 1200.0
@export var fuerza_disparo: float = 600.0
@export var daño_disparo: int = 10
@export var CombustibleMax:int
@export var CombustibleActual:int
@export var salud: int = 3
@export var SaludMax:int = 3
@export var tamaño_jugador: float = 1.0  # escala base del sprite
var PuedeInteractuar:bool=false
# --- Coyote Time ---
@export var tiempo_coyote: float = 0.30
var tiempo_desde_suelo: float = 0.0

# --- Control de daño ---
var damage_cooldown: bool = false
# --- Barras ---
const VIDAS = preload("res://Scena/Player/vidas.tscn")
@onready var h_box_container: HBoxContainer = $CanvasLayer/VBoxContainer/HBoxContainer
@onready var combustible: TextureProgressBar = $CanvasLayer/VBoxContainer/Combustible

# --- Referencias ---
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

# --- Estados ---
var CrearCheckpoint = false
var PuedeComprar = false
var dir: float = 0
var ultima_posicion_segura: Vector2
@export var distancia_max_caida: float = 100
var respawn_position: Vector2 = Vector2(0, 0)

# --- Guardar Hoguera ---
var HogueraActual: Area2D


func _ready() -> void:
	# Cargar estadísticas del jugador desde la global
	fuerza_salto = EstadisticasDelPlayer.fuerza_salto
	daño_disparo = EstadisticasDelPlayer.daño_disparo
	CombustibleMax=EstadisticasDelPlayer.CombustibleMax
	CombustibleActual=CombustibleMax
	SaludMax=EstadisticasDelPlayer.SaludMax
	salud=SaludMax
	velocidad = EstadisticasDelPlayer.velocidad
	tamaño_jugador = EstadisticasDelPlayer.tamaño_jugador
	# Iniciar animación en idle
	if not animated_sprite_2d.is_playing():
		animated_sprite_2d.play("idle")


func _physics_process(delta: float) -> void:
	actualizar_corazones()
	ActualizarCombustible()
	AtaqueDisparo()
	EncenderFuego()
	DepuracionEstadisticas()

	# --- Gravedad ---
	if not is_on_floor():
		velocity.y += gravedad * delta
		tiempo_desde_suelo += delta
	else:
		tiempo_desde_suelo = 0.0
		ultima_posicion_segura = global_position
		if velocity.y > 0:
			velocity.y = 0

	# --- Movimiento Horizontal ---
	var input_dir := 0.0

	if joystick and joystick.posVector.length() > 0.1:
		input_dir = clamp(joystick.posVector.x * 2.5, -1, 1)
	else:
		if Input.is_action_pressed("ui_right"):
			input_dir = 1.0
		elif Input.is_action_pressed("ui_left"):
			input_dir = -1.0

	dir = input_dir  # guardamos dirección para animación y flip
	velocity.x = input_dir * velocidad

	# --- Salto con Coyote Time ---
	var salto_joystick: bool = joystick and joystick.posVector.y < -0.5
	if (Input.is_action_just_pressed("ui_up") or salto_joystick) and (is_on_floor() or tiempo_desde_suelo < tiempo_coyote):
		velocity.y = fuerza_salto
		tiempo_desde_suelo = tiempo_coyote

	move_and_slide()

	# --- Mirar hacia donde se mueve ---
	if abs(dir) > 0.1:
		animated_sprite_2d.flip_h = dir < 0

	# --- Actualizar animaciones ---
	_actualizar_animacion()

func actualizar_corazones():
	var corazones_actuales = h_box_container.get_child_count()
	
	# Si tiene menos corazones de los que debería, instanciamos
	if salud > corazones_actuales:
		for i in range(salud - corazones_actuales):
			var nuevo_corazon = VIDAS.instantiate()
			h_box_container.add_child(nuevo_corazon)
	
	# Si tiene más corazones de los que debería, borramos
	elif salud < corazones_actuales:
		for i in range(corazones_actuales - salud):
			var ultimo = h_box_container.get_child(h_box_container.get_child_count() - 1)
			if ultimo:
				ultimo.queue_free()

func ActualizarCombustible():
	combustible.max_value=CombustibleMax
	combustible.value=CombustibleActual
# --- Reinicio de jugador ---
func _reset_player() -> void:
	position = respawn_position
	velocity = Vector2.ZERO
	animated_sprite_2d.play("idle")


# --- Control de animaciones ---
func _actualizar_animacion() -> void:
	if not animated_sprite_2d:
		return

	if not is_on_floor():
		if velocity.y < 0:
			animated_sprite_2d.play("jump")
		else:
			animated_sprite_2d.play("fall")
	else:
		if abs(velocity.x) > 10:
			animated_sprite_2d.play("walk")
		else:
			animated_sprite_2d.play("idle")



# --- Colisión con enemigo ---
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		_reset_player()


# --- Colisión con coleccionable ---
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("collectibles"):
		area.queue_free()


# --- Daño recibido ---
func _on_recibir_dano_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemigo") and not damage_cooldown:
		damage_cooldown = true


# --- Crear Checkpoint ---
func EncenderFuego():
	if Input.is_action_just_pressed("Interactuar") and CrearCheckpoint:
		respawn_position = global_position
		print("🔥 Checkpoint guardado en: ", respawn_position)
		if HogueraActual != null:
			HogueraActual.EncenderFuego()


# --- Ataque ---
func AtaqueDisparo():
	if Input.is_action_just_pressed("atacar") and CombustibleActual>0:
		if CombustibleActual>=10:
			CombustibleActual-=10
			var bala = PROYECTIL.instantiate()
			bala.global_position = global_position
			get_parent().add_child(bala)

			# Si el jugador no se está moviendo, dispara hacia donde está mirando
			var direccion_disparo = Vector2.RIGHT
			if dir != 0:
				direccion_disparo = Vector2(dir, 0)
			elif animated_sprite_2d.flip_h:
				direccion_disparo = Vector2.LEFT

			if bala.has_method("disparar"):
				bala.disparar(direccion_disparo * fuerza_disparo, daño_disparo)



# --- DEPURACIÓN DE ESTADÍSTICAS ---
func DepuracionEstadisticas():
	if PuedeComprar:
		if Input.is_action_just_pressed("ui_f1"):
			fuerza_salto -= 50
			print("Altura de salto aumentada -> ", -fuerza_salto)
		if Input.is_action_just_pressed("ui_f2"):
			daño_disparo += 5
			print("Daño del disparo -> ", daño_disparo)
		if Input.is_action_just_pressed("ui_f3"):
			salud += 10
			print("Salud del jugador -> ", salud)
		if Input.is_action_just_pressed("ui_f4"):
			velocidad += 50
			print("Velocidad del jugador -> ", velocidad)
		if Input.is_action_just_pressed("ui_f5"):
			tamaño_jugador += 0.1
			scale = Vector2(tamaño_jugador * sign(scale.x), tamaño_jugador)
			print("Tamaño del jugador -> ", tamaño_jugador)


# --- GUARDADO MANUAL ---
func GuardarPartida():
	EstadisticasDelPlayer.fuerza_salto = fuerza_salto
	EstadisticasDelPlayer.daño_disparo = daño_disparo
	EstadisticasDelPlayer.salud = salud
	EstadisticasDelPlayer.velocidad = velocidad
	EstadisticasDelPlayer.tamaño_jugador = tamaño_jugador	
	EstadisticasDelPlayer.guardar_datos()


func _input(event):
	if event.is_action_pressed("1"):
		GuardarPartida()
	if event.is_action_pressed("2"):
		EstadisticasDelPlayer.cargar_datos()
		_ready() # refrescar stats del jugador


func _on_agarrar_monedas_body_entered(body: Node2D) -> void:
	if body.is_in_group("Moneda"):
		EstadisticasDelPlayer.monedasPremium += 1
		body.queue_free()


func _on_detectar_hoguera_area_entered(area: Area2D) -> void:
	if area.is_in_group("Hoguera"):
		HogueraActual = area


func _on_recibir_daño_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemigo"):
		print(body.name)
		_reset_player()
		salud-=1
		if salud<=0:
			get_tree().change_scene_to_file("res://Scena/Menú/Menu.tscn")


func _on_recibir_daño_area_entered(area: Area2D) -> void:
	if area.is_in_group("Enemigo"):
		print(area.name)
		_reset_player()
		salud-=1
		
		if salud<=0:
			get_tree().change_scene_to_file("res://Scena/Menú/Menu.tscn")

		

@onready var timer: Timer = $Timer

func _on_timer_timeout() -> void:
	if CombustibleActual<CombustibleMax:
		CombustibleActual+=1
