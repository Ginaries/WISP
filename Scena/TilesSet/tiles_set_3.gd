
extends Node2D

const JEFE_1 = preload("res://Scena/Enemigos/Jefes/Jefe1.tscn")

@onready var marker_2d: Marker2D = $Area2D/Marker2D
var jefe_spawned := false   # ← evita que el jefe se cree múltiples veces


func _ready() -> void:
	EstadisticasDelPlayer.cargar_datos()

func _exit_tree() -> void:
	EstadisticasDelPlayer.guardar_datos()
	
func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player") and not jefe_spawned:
		jefe_spawned = true
		spawnear_jefe()


func spawnear_jefe():
	var jefe = JEFE_1.instantiate()
	jefe.global_position = marker_2d.global_position
	get_tree().current_scene.add_child(jefe)
