extends Area2D
@onready var fuego: Sprite2D = $Fuego



func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.CrearCheckpoint=true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.CrearCheckpoint=false
		
func EncenderFuego():
	fuego.visible=true
