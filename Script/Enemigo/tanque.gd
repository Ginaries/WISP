extends Enemigo

# --- CONFIGURACIÓN DEL TANQUE ---
@export var tiempo_preparacion_golpe: float = 1.5
@export var empuje_golpe: float = 600.0
@export var duracion_golpe: float = 0.4
@export var reduccion_danio_escudo: float = 0.5
@export var duracion_escudo: float = 2.0
@export var gravedad: float = 900.0  # <- fuerza de gravedad

# --- ESTADOS ---
var puede_atacar: bool = true
var esta_atacando: bool = false
var esta_golpeando: bool = false
var escudo_activo: bool = false

# --- REFERENCIA AL JUGADOR ---
func _ready() -> void:
	var jugadores = get_tree().get_nodes_in_group("Player")
	if jugadores.size() > 0:
		Player = jugadores[0] as CharacterBody2D


# --- HABILIDAD PRINCIPAL: GOLPE PESADO ---
func usar_habilidad() -> void:
	if puede_atacar and not esta_atacando and is_on_floor():
		puede_atacar = false
		esta_atacando = true
		print("🪖 El tanque prepara un golpe demoledor...")

		velocity.x = 0
		await get_tree().create_timer(tiempo_preparacion_golpe).timeout

		Golpe_pesado()
		await get_tree().create_timer(1.5).timeout  # cooldown entre ataques

		esta_atacando = false
		puede_atacar = true


# --- GOLPE PESADO (AVANCE CORTO Y DAÑO FUERTE) ---
func Golpe_pesado() -> void:
	if Player == null:
		return

	print("💥 ¡El tanque embiste con fuerza!")

	var direccion = sign(Player.global_position.x - global_position.x)  # Solo eje X
	esta_golpeando = true
	var tiempo = 0.0

	while tiempo < duracion_golpe:
		var delta = get_process_delta_time()
		velocity.x = direccion * empuje_golpe
		velocity.y += gravedad * delta  # mantiene gravedad
		move_and_slide()
		await get_tree().create_timer(0.016, false).timeout
		tiempo += delta

	esta_golpeando = false
	velocity.x = 0


# --- HABILIDAD DEFENSIVA: ESCUDO ---
func activar_escudo() -> void:
	if not escudo_activo:
		escudo_activo = true
		print("🛡️ El tanque levanta su escudo y reduce el daño recibido.")
		await get_tree().create_timer(duracion_escudo).timeout
		escudo_activo = false
		print("🛡️ El escudo del tanque se ha desactivado.")


# --- MOVIMIENTO GENERAL ---
func _physics_process(delta: float) -> void:
	if Player == null:
		return

	# Si está atacando o embistiendo, no se mueve de forma normal
	if esta_atacando or esta_golpeando:
		move_and_slide()
		return

	# --- Gravedad ---
	if not is_on_floor():
		velocity.y += gravedad * delta
	else:
		# Solo reseteamos velocidad vertical cuando ya está en el piso
		velocity.y = 0

	# --- Movimiento hacia el jugador ---
	var direccion_hacia_jugador = Player.global_position - global_position
	var distancia = direccion_hacia_jugador.length()

	if distancia < rango_detec:
		var direccion_x = sign(direccion_hacia_jugador.x)
		velocity.x = direccion_x * velocidad_caminar
	else:
		velocity.x = 0

	# --- Aplicar movimiento ---
	move_and_slide()

	# --- Debug opcional ---
	#if is_on_floor():
	#	print("Tanque tocando el piso ✅")
	#else:
	#	print("Tanque en el aire ❌")


# --- TIMER DE ATAQUE ---
func _on_timer_timeout() -> void:
	# Aleatoriamente elige entre atacar o activar el escudo
	if randi_range(0, 1) == 0:
		usar_habilidad()
	else:
		activar_escudo()


# --- RECIBIR DAÑO ---
func _on_recibirproyectil_area_entered(area: Area2D) -> void:
	if area.is_in_group("Proyectiles"):
		var dano = area.DañoaEnemigo
		if escudo_activo:
			dano *= reduccion_danio_escudo
			print("🛡️ El escudo reduce el daño recibido a: ", dano)
		RecibirDaño(dano)
		AudioController.muerte_tanque()
		area.queue_free()
