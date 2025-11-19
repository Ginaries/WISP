extends Enemigo

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _physics_process(_delta: float) -> void:
	pass
	


func _on_activar_pinches_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		animated_sprite_2d.play("Atacar")



func _on_activar_pinches_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		animated_sprite_2d.play("default")


func _on_recibirproyectil_area_entered(area: Area2D) -> void:
	if area.is_in_group("Proyectiles"):
		RecibirDaño(EstadisticasDelPlayer.daño_disparo)
		AudioController.muerte_pincho()
		area.queue_free()
