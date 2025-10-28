extends Camera2D

@export var seguir_en_y: bool = true
@export var seguir_en_x: bool = false

@export var player: CharacterBody2D 

func _process(delta: float) -> void:
	if player == null:
		return

	var target_position = global_position

	if seguir_en_y:
		target_position.y = player.global_position.y

	# si no querés que se mueva hacia arriba, solo hacia abajo:
	# if player.global_position.y > global_position.y:
	#     target_position.y = player.global_position.y

	global_position = target_position
