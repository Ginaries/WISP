extends Node2D

@onready var panel: Panel = $Panel
@onready var cantidad_puntos: RichTextLabel = $Puntos/CantidadPuntos
@onready var coste_ata: RichTextLabel = $SolapaMejoras2/ScrollContainer/HBoxContainer/Ladoizquierdo/Cartel/CosteATA
@onready var coste_vel: RichTextLabel = $SolapaMejoras2/ScrollContainer/HBoxContainer/Ladoizquierdo/Cartel2/CosteVel
@onready var coste_salto: RichTextLabel = $SolapaMejoras2/ScrollContainer/HBoxContainer/Ladoderecho/Cartel3/CosteSalto
@onready var coste_combus: RichTextLabel = $SolapaMejoras2/ScrollContainer/HBoxContainer/Ladoderecho/Cartel4/CosteCombus

@onready var solapa_orbes: Panel = $SolapaOrbes
@onready var solapa_bundles: Panel = $SolapaBundles
@onready var solapa_mejoras_2: Panel = $SolapaMejoras2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	cantidad_puntos.text=str(EstadisticasDelPlayer.Puntos)
	coste_ata.text= str(EstadisticasDelPlayer.coste_ataque)
	coste_combus.text=str(EstadisticasDelPlayer.coste_combustible)
	coste_salto.text=str(EstadisticasDelPlayer.coste_salto)
	coste_vel.text=str(EstadisticasDelPlayer.coste_velocidad)


func _on_flecha_pressed() -> void:
	AudioController.click_boton()
	get_tree().change_scene_to_file("res://Scena/SelectorNiveles/SelectorNiveles.tscn")

@onready var timer_anuncio: RichTextLabel = $Panel/TimerAnuncio

func _on_ver_anuncio_pressed() -> void:
	panel.visible=true
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
	panel.visible=false
	get_tree().paused=false
	EstadisticasDelPlayer.Puntos+=5
	


# --- Botones de mejora ---
func _on_ataque_m_pressed() -> void:
	AudioController.click_boton()
	mejorar_estadistica("daño_disparo", 2, "coste_ataque")

func _on_velocidad_m_pressed() -> void:
	AudioController.click_boton()
	mejorar_estadistica("velocidad", 10, "coste_velocidad")

func _on_f_salto_m_pressed() -> void:
	AudioController.click_boton()
	mejorar_estadistica("fuerza_salto", -20, "coste_salto")

func _on_combustible_m_pressed() -> void:
	AudioController.click_boton()
	mejorar_estadistica("CombustibleMax", 10, "coste_combustible")

func _on_salud_m_pressed() -> void:
	AudioController.click_boton()
	mejorar_estadistica("SaludMax", 1, "coste_salud")


# --- Función general para mejorar ---
func mejorar_estadistica(nombre_propiedad: String, incremento, nombre_coste: String) -> void:
	var coste_actual = EstadisticasDelPlayer.get(nombre_coste)
	var puntos_actuales = EstadisticasDelPlayer.Puntos

	if puntos_actuales >= coste_actual:
		# restar puntos
		EstadisticasDelPlayer.Puntos -= coste_actual
		
		# subir estadística
		EstadisticasDelPlayer.set(nombre_propiedad, EstadisticasDelPlayer.get(nombre_propiedad) + incremento)
		print("✨ Mejoraste", nombre_propiedad, "a:", EstadisticasDelPlayer.get(nombre_propiedad))
		
		# aumentar costo para la próxima
		EstadisticasDelPlayer.set(nombre_coste, coste_actual + int(coste_actual * 0.5)) # sube un 50% cada vez
		
		
		# guardar progreso
		#EstadisticasDelPlayer.guardar_datos()
	else:
		var faltan = coste_actual - puntos_actuales
		print("❌ Te faltan", faltan, "puntos para mejorar", nombre_propiedad)


func _on_boton_orbes_pressed() -> void:
	AudioController.click_boton()
	solapa_orbes.visible=true
	solapa_bundles.visible=false
	solapa_mejoras_2.visible=false


func _on_boton_bundles_pressed() -> void:
	AudioController.click_boton()
	solapa_orbes.visible=false
	solapa_bundles.visible=true
	solapa_mejoras_2.visible=false


func _on_boton_mejoras_pressed() -> void:
	AudioController.click_boton()
	solapa_orbes.visible=false
	solapa_bundles.visible=false
	solapa_mejoras_2.visible=true
