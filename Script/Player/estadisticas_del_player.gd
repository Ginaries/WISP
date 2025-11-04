extends Node

# --- Estadísticas base del jugador ---
var fuerza_salto: float = -200
var daño_disparo: int = 10
var SaludMax:int = 3
var CombustibleMax:int=50

var velocidad: float = 100.0
var tamaño_jugador: float = 1.0
var Puntos: int = 0
var monedasPremium: int = 0

# --- Costes de mejora (se guardan también) ---
var coste_ataque: int = 5
var coste_velocidad: int = 5
var coste_salto: int = 5
var coste_salud: int = 5
var coste_combustible: int = 5

# --- Archivo de guardado ---
const SAVE_PATH := "user://savegame.json"


# --- Guardar datos ---
func guardar_datos() -> void:
	var data = {
		"fuerza_salto": fuerza_salto,
		"daño_disparo": daño_disparo,
		"CombustibleMax": CombustibleMax,
		"SaludMax":SaludMax,
		"velocidad": velocidad,
		"tamaño_jugador": tamaño_jugador,
		"Puntos": Puntos,
		"monedasPremium": monedasPremium,
			# costes de mejora
		"coste_ataque": coste_ataque,
		"coste_velocidad": coste_velocidad,
		"coste_salto": coste_salto,
		"coste_salud": coste_salud,
		"coste_combustible": coste_combustible
	}
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(data))
		file.close()
		print("💾 Partida guardada correctamente.")


# --- Cargar datos ---
func cargar_datos() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		print("⚠️ No se encontró una partida guardada.")
		return

	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file:
		var data = JSON.parse_string(file.get_as_text())
		file.close()
		
		if typeof(data) == TYPE_DICTIONARY:
			fuerza_salto = data.get("fuerza_salto", fuerza_salto)
			daño_disparo = data.get("daño_disparo", daño_disparo)
			CombustibleMax= data.get("CombustibleMax", CombustibleMax)
			SaludMax= data.get("SaludMax", SaludMax)
			velocidad = data.get("velocidad", velocidad)
			tamaño_jugador = data.get("tamaño_jugador", tamaño_jugador)
			Puntos = data.get("Puntos", Puntos)
			monedasPremium = data.get("monedasPremium", monedasPremium)
				# costes
			coste_ataque = data.get("coste_ataque", coste_ataque)
			coste_velocidad = data.get("coste_velocidad", coste_velocidad)
			coste_salto = data.get("coste_salto", coste_salto)
			coste_salud = data.get("coste_salud", coste_salud)
			coste_combustible = data.get("coste_combustible", coste_combustible)
			print("✅ Partida cargada correctamente.")
