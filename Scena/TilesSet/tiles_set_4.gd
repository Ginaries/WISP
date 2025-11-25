extends Node2D

func _ready() -> void:
	EstadisticasDelPlayer.cargar_datos()

func _exit_tree() -> void:
	EstadisticasDelPlayer.guardar_datos()
