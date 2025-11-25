extends Panel


func _on_reintentar_pressed() -> void:
	get_tree().reload_current_scene()



func _on_s_alir_pressed() -> void:
	get_tree().change_scene_to_file("res://Scena/Menú/Menu.tscn")
