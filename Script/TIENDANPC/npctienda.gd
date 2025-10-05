extends Area2D



func _on_detectar_jugador_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.PuedeComprar=true#desplazar menu en canvas


func _on_detectar_jugador_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.PuedeComprar=false
		queue_free()
