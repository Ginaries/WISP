extends CharacterBody2D

# --- Proyectil del player ---
const PROYECTIL = preload("res://Scena/Player/proyectil del player/proyectil.tscn")

# --- Variables principales ---
@export var velocidad: float = 300.0
@export var fuerza_salto: float = -600.0
@export var gravedad: float = 1200.0
@export var fuerza_disparo: float = 600.0
@export var daño_disparo: int = 10
@export var salud: int = 100
@export var tamaño_jugador: float = 1.0  # escala base del sprite

# --- Coyote Time ---
@export var tiempo_coyote: float = 0.30
var tiempo_desde_suelo: float = 0.0

# --- Control de daño ---
var damage_cooldown: bool = false

# --- Referencias ---
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

# --- Estados ---
var CrearCheckpoint = false
var PuedeComprar = false
var dir: int = 0
var ultima_posicion_segura: Vector2
@export var distancia_max_caida: float = 100
var respawn_position: Vector2 = Vector2(0, 0)

# --- Guardar Hoguera ---
var HogueraActual: Area2D


func _ready() -> void:
	# Cargar estadísticas del jugador desde la global
	fuerza_salto = EstadisticasDelPlayer.fuerza_salto
	daño_disparo = EstadisticasDelPlayer.daño_disparo
	salud = EstadisticasDelPlayer.salud
	velocidad = EstadisticasDelPlayer.velocidad
	tamaño_jugador = EstadisticasDelPlayer.tamaño_jugador

	# Iniciar animación en idle
	if not animated_sprite_2d.is_playing():
		animated_sprite_2d.play("idle")


func _physics_process(delta: float) -> void:
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
	dir = 0
	if Input.is_action_pressed("ui_right"):
		dir = 1
	elif Input.is_action_pressed("ui_left"):
		dir = -1
	
	velocity.x = dir * velocidad

	# --- Salto con Coyote Time ---
	if Input.is_action_just_pressed("ui_up") and (is_on_floor() or tiempo_desde_suelo < tiempo_coyote):
		velocity.y = fuerza_salto
		tiempo_desde_suelo = tiempo_coyote

	move_and_slide()
	# --- Mirar hacia donde se mueve ---
	if dir != 0:
		animated_sprite_2d.flip_h = dir < 0
		scale.x = tamaño_jugador  # mantiene el tamaño sin invertir el nodo entero


	# --- Actualizar animaciones ---
	_actualizar_animacion()

	# --- Reinicio si cae demasiado ---
	if global_position.y - ultima_posicion_segura.y > distancia_max_caida:
		_reset_player()


# --- Reinicio de jugador ---
func _reset_player() -> void:
	position = respawn_position
	velocity = Vector2.ZERO
	animated_sprite_2d.play("idle")


# --- Control de animaciones ---
func _actualizar_animacion() -> void:
	var anim_actual = animated_sprite_2d.animation

	if is_on_floor():
		if dir == 0:
			if anim_actual != "idle":
				animated_sprite_2d.play("idle")
		else:
			if anim_actual != "walk":
				animated_sprite_2d.play("walk")
	else:
		# Si está en el aire, decidir entre salto o caída
		if velocity.y < 0:
			if anim_actual != "jump":
				animated_sprite_2d.play("jump")
		else:
			if anim_actual != "fall":
				animated_sprite_2d.play("fall")


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
	if Input.is_action_just_pressed("atacar"):
		var bala = PROYECTIL.instantiate()
		bala.global_position = global_position
		get_parent().add_child(bala)

		var direccion = Vector2(sign(scale.x), 0)
		if bala.has_method("disparar"):
			bala.disparar(direccion * fuerza_disparo, daño_disparo)


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
