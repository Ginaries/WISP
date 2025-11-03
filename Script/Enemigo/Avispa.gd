extends Enemigo


# Tiempo de espera antes de atacar
@export var tiempo_preparacion: float = 1.0
#Estados
var puede_atacar: bool = true
var esta_atacando:bool = false
#habilidad variables
@export var velocidad_dash: float = 400.0
@export var duracion_dash: float = 0.3
var esta_dasheando: bool = false

#inicia y ubica al jugador en su referencia
func _ready() -> void:
	var jugadores = get_tree().get_nodes_in_group("Player")
	if jugadores.size() > 0:
		Player = jugadores[0] as CharacterBody2D

func usar_habilidad() -> void:
	if puede_atacar:
		puede_atacar = false
		esta_atacando=true
		print("🐝 Avispa se detiene y prepara un aguijonazo...")
		velocity = Vector2.ZERO  # se queda quieta
		
		# Espera un segundo y lanza el aguijón
		await get_tree().create_timer(tiempo_preparacion).timeout
		esta_atacando=false
		Golpe_de_aguijon()
		puede_atacar = true


func Golpe_de_aguijon() -> void:
	if Player == null:
		return
		
	var direccion = (Player.global_position - global_position).normalized()
	esta_dasheando = true
	
	var tiempo = 0.0
	while tiempo < duracion_dash:
		if not is_inside_tree():
			break 
		var delta = get_process_delta_time()
		velocity = direccion * velocidad_dash
		move_and_slide()
		await get_tree().process_frame
		tiempo += delta
	
	# Termina el dash
	esta_dasheando = false
	velocity = Vector2.ZERO


func _physics_process(delta:float) -> void:
	if Player == null:
		return
	if esta_atacando==true:
		return
	# Calcular la distancia al jugador
	var dir = Player.global_position - global_position
	var distancia = dir.length()

	if distancia < rango_detec:
		dir = dir.normalized()
		velocity = dir * velocidad_volar
	else:
		velocity = Vector2.ZERO

	move_and_slide()

func _on_timer_timeout() -> void:
	usar_habilidad()


func _on_recibirproyectil_area_entered(area: Area2D) -> void:
	if area.is_in_group("Proyectiles"):
		RecibirDaño(area.DañoaEnemigo)
		area.queue_free()
