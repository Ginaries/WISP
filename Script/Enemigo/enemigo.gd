extends CharacterBody2D
class_name Enemigo

#Instanciador
const MONEDA_PREMIUM = preload("res://Scena/Moneda/moneda_premium.tscn")

# --- Stats ---
@export var vida: int = 10
@export var daño: int = 1
@export var drop: Dictionary = {} # luego le metemos {"monedas": 5}, {"gemas": 1}, etc.
@export var Player: CharacterBody2D

# --- Velocidades ---
@export var velocidad_caminar: float = 100.0
@export var velocidad_volar: float = 150.0

# --- Configuración IA ---
@export var rango_detec: float = 1500.0  # rango para detectar al player
@export var es_volador: bool = false    # si vuela o camina

# Direccion actual (-1 = izquierda, 1 = derecha)
var dir: int = 1

#inicia y ubica al jugador en su referencia
func _ready() -> void:
	var jugadores = get_tree().get_nodes_in_group("Player")
	if jugadores.size() > 0:
		Player = jugadores[0] as CharacterBody2D


func _physics_process(delta: float) -> void:
	if Player == null:
		return
	
	var distancia = global_position.distance_to(Player.global_position)
	
	if distancia <= rango_detec:
		# --- En rango: seguir al player ---
		if es_volador:
			volar(delta, Player.global_position)
		else:
			# caminar hacia el jugador en el suelo
			dir = sign(Player.global_position.x - global_position.x)
			caminar(delta)
	else:
		# --- Fuera de rango: patrullar ---
		# ejemplo: rebotar en paredes invisibles
		caminar(delta)
		# acá podés poner lógica de patrulla (cambiar dirección cada X segundos, etc.)

	# aplicar gravedad si no es volador
	if not es_volador and not is_on_floor():
		velocity.y += 1200 * delta  # podés usar tu variable gravedad
		move_and_slide()

func Morir():
	var chance: int = randi_range(0, 5)
	if chance == 2 or chance == 4:
		var cantidad_monedas = randi_range(2, 6) # elige entre 2 y 6 monedas
		for i in cantidad_monedas:
			var moneda = MONEDA_PREMIUM.instantiate()
			moneda.position = position
			
			# Agregar al mismo padre
			get_parent().add_child(moneda)
			
			# Darle una dirección aleatoria de disparo
			if moneda.has_method("disparar"):
				var direccion = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, -0.5)).normalized()
				var fuerza = randf_range(150.0, 300.0)
				moneda.disparar(direccion * fuerza)
	queue_free()
		
# --- Movimiento ---
func caminar(_delta: float) -> void:
	velocity.x = dir * velocidad_caminar
	move_and_slide()

func volar(_delta: float, objetivo: Vector2) -> void:
	var dir_volar = (objetivo - global_position).normalized()
	velocity = dir_volar * velocidad_volar
	move_and_slide()

func RecibirDaño(Dmg):
	print("🩸", name, "recibió daño:", Dmg)
	vida -= Dmg
	if vida <= 0:
		print("☠️", name, "murió")
		Morir()

# --- Método de habilidad (Overdrive, para sobrescribir) ---
func usar_habilidad() -> void:
	print("El enemigo base no tiene habilidad.")
