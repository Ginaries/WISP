extends Node2D

@onready var panel: Panel = $Panel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_flecha_pressed() -> void:
	get_tree().change_scene_to_file("res://Scena/Menú/Menu.tscn")


func _on_ver_anuncio_pressed() -> void:
	panel.visible=true
	get_tree().paused=true
	await get_tree().create_timer(3.0).timeout
	panel.visible=false
	get_tree().paused=false
	EstadisticasDelPlayer.Puntos+=5
	
