extends CanvasLayer

@onready var panel_2: Panel = $Panel2
@onready var timer_anuncio: RichTextLabel = $Panel2/TimerAnuncio
@onready var panel: Panel = $Panel


func activarPanel():
	panel.visible=true

func _on_button_pressed() -> void:
	panel_2.visible=true
	get_tree().paused=true
	timer_anuncio.text=str("5")
	await get_tree().create_timer(1.0).timeout
	timer_anuncio.text=str("4")
	await get_tree().create_timer(1.0).timeout
	timer_anuncio.text=str("3")
	await get_tree().create_timer(1.0).timeout
	timer_anuncio.text=str("2")
	await get_tree().create_timer(1.0).timeout
	timer_anuncio.text=str("1")
	await get_tree().create_timer(1.0).timeout
	panel_2.visible=false
	get_tree().paused=false
	EstadisticasDelPlayer.Puntos+=100*2
	panel.visible=false
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://Scena/SelectorNiveles/SelectorNiveles.tscn")




func _on_button_2_pressed() -> void:
	panel.visible=false
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://Scena/SelectorNiveles/SelectorNiveles.tscn")
