extends Control

func _ready() -> void:
	AudioController.musica_interfaz()
	EstadisticasDelPlayer.cargar_datos()


func _on_jugar_pressed() -> void:
	AudioController.click_boton()
	get_tree().change_scene_to_file("res://Scena/SelectorNiveles/SelectorNiveles.tscn")

func _on_tienda_pressed() -> void:
	AudioController.click_boton()
	get_tree().change_scene_to_file("res://Scena/TiendaPremium/TiendaPremium.tscn")


func _on_controles_pressed() -> void:
	AudioController.click_boton()
	pass # Replace with function body.


func _on_salir_pressed() -> void:
	AudioController.click_boton()
	get_tree().quit()
