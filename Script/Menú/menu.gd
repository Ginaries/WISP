extends Control


func _on_jugar_pressed() -> void:
	get_tree().change_scene_to_file("res://Scena/SelectorNiveles/SelectorNiveles.tscn")

func _on_tienda_pressed() -> void:
	pass # Replace with function body.


func _on_controles_pressed() -> void:
	pass # Replace with function body.


func _on_salir_pressed() -> void:
	get_tree().quit()
