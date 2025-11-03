extends Node2D
const MERCADER = preload("res://Dialogos/Mercader.dialogue")
var Puedo:bool=false
var Ocupada:bool=false

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Interactuar") and Puedo and not Ocupada:
		Ocupada=true
		get_tree().paused=true
		DialogueManager.show_dialogue_balloon(MERCADER)
		await DialogueManager.dialogue_ended
		Ocupada=false
		get_tree().paused=false

func _on_interaccion_interna_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.PuedeInteractuar=true
		Puedo=true

func _on_interaccion_interna_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.PuedeInteractuar=false
		Puedo=false
