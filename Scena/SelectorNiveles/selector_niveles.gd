extends Control

func _on_nivel_1_pressed() -> void:
	AudioController.click_boton()
	AudioController.parar_musica()
	AudioController.musica_nivel()
	get_tree().change_scene_to_file("res://Scena/TilesSet/TilesSet.tscn")


func _on_nivel_2_pressed() -> void:
	AudioController.click_boton()
	AudioController.parar_musica()
	AudioController.musica_nivel()
	get_tree().change_scene_to_file("res://Scena/TilesSet/TilesSet2.tscn")


func _on_nivel_3_pressed() -> void:
	AudioController.click_boton()
	AudioController.parar_musica()
	AudioController.musica_nivel()
	get_tree().change_scene_to_file("res://Scena/TilesSet/TilesSet3.tscn")


func _on_nivel_4_pressed() -> void:
	AudioController.click_boton()
	AudioController.parar_musica()
	AudioController.musica_nivel()
	get_tree().change_scene_to_file("res://Scena/TilesSet/TilesSet4.tscn")
	pass # Replace with function body.


func _on_nivel_5_pressed() -> void:
	AudioController.click_boton()
	AudioController.parar_musica()
	AudioController.musica_nivel()
	get_tree().change_scene_to_file("res://Scena/TilesSet/TilesSet5.tscn")
	pass # Replace with function body.


func _on_tienda_premium_pressed() -> void:
	AudioController.click_boton()
	get_tree().change_scene_to_file("res://Scena/TiendaPremium/TiendaPremium.tscn")
	

func _on_flecha_pressed() -> void:
	AudioController.click_boton()
	get_tree().change_scene_to_file("res://Scena/Menú/Menu.tscn")
