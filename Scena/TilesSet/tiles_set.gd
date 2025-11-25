extends Node2D

func _ready() -> void:
	AudioController.parar_musica()
	AudioController.musica_nivel()
	EstadisticasDelPlayer.cargar_datos()

func _exit_tree() -> void:
	EstadisticasDelPlayer.guardar_datos()
