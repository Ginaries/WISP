extends Area2D

@onready var rich_text_label: RichTextLabel = $"../CanvasEscenarios/Panel/RichTextLabel"
@onready var canvas_escenarios: CanvasLayer = $"../CanvasEscenarios"



func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		canvas_escenarios.activarPanel()
	
