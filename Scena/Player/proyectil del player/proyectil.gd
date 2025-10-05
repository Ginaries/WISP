extends Area2D

var velocidad: Vector2 = Vector2.ZERO
var DañoaEnemigo:float
func disparar(v: Vector2,daño):
	velocidad = v
	DañoaEnemigo=daño

func _ready() -> void:
	add_to_group("Proyectiles")
	
func _physics_process(delta):
	position += velocidad * delta

	# Opcional: eliminar si sale muy lejos de cámara
	if position.length() > 2000:
		queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
