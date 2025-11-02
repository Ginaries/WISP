extends Camera2D

@onready var camera_2d: Camera2D = $"." # cámara principal
@onready var camera_2d_2: Camera2D = $"../Camera2D2" # cámara de la cueva

@export var seguir_en_y: bool = true
@export var seguir_en_x: bool = false
@export var player: CharacterBody2D

var Cueva: bool = false

func _process(delta: float) -> void:
	if player == null:
		return

	var target_position = global_position

	if seguir_en_y:
		target_position.y = player.global_position.y
	if seguir_en_x:
		target_position.x = player.global_position.x

	global_position = target_position


# --- Al entrar en el área (cueva)
func _on_cambio_de_camara_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		Cueva = true
		camera_2d_2.make_current()
		camera_2d_2.align()
		camera_2d_2.force_update_scroll()



# --- Al salir del área (volver afuera)
func _on_cambio_de_camara_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		Cueva = false
		camera_2d.make_current()
		camera_2d.align()
		camera_2d.force_update_scroll()
