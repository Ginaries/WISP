extends Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var encendido:bool=false
func _ready() -> void:
	# La hoguera empieza apagada
	animated_sprite_2d.play("apagado")


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.CrearCheckpoint = true


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.CrearCheckpoint = false


func EncenderFuego() -> void:
	# Cambiamos a la animación encendida
	if encendido!=true:
		animated_sprite_2d.play("Encendido")
		
		# Aumentamos la escala como feedback visual
		var nueva_escala = animated_sprite_2d.scale * 1.2
		animated_sprite_2d.scale = nueva_escala
		encendido=true
