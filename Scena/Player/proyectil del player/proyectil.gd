extends Area2D
@onready var sprite_2d: Sprite2D = $Sprite2D

var velocidad: Vector2 = Vector2.ZERO
var DañoaEnemigo:float
func disparar(v: Vector2, daño):
	velocidad = v
	DañoaEnemigo = daño

	# Voltear sprite según dirección
	if velocidad.x < 0:
		sprite_2d.flip_h = true
	else:
		sprite_2d.flip_h = false


func _ready() -> void:
	add_to_group("Proyectiles")
	
func _physics_process(delta):
	position += velocidad * delta


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
