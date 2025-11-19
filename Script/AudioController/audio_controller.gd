extends Node

@onready var musica_principal: AudioStreamPlayer = $MusicaPrincipal
@onready var musica_niveles: AudioStreamPlayer = $MusicaNiveles
@onready var tienda_nivel: AudioStreamPlayer = $TiendaNivel
@onready var agarrar_orbe: AudioStreamPlayer = $AgarrarOrbe
@onready var dropeo_orbe: AudioStreamPlayer = $DropeoOrbe
@onready var prender_brasero: AudioStreamPlayer = $PrenderBrasero
@onready var boton_click: AudioStreamPlayer = $BotonClick
@onready var nivel_ganado: AudioStreamPlayer = $NivelGanado
@onready var nivel_fallido: AudioStreamPlayer = $NivelFallido
@onready var proyectil: AudioStreamPlayer = $Proyectil
@onready var saludo_mercader: AudioStreamPlayer = $SaludoMercader
@onready var voz_mercader: AudioStreamPlayer = $VozMercader
@onready var sonido_avispa: AudioStreamPlayer = $SonidoAvispa
@onready var sonido_mama: AudioStreamPlayer = $SonidoMama
@onready var sonido_papa: AudioStreamPlayer = $SonidoPapa
@onready var sonido_pincho: AudioStreamPlayer = $SonidoPincho
@onready var sonido_tanque: AudioStreamPlayer = $SonidoTanque
@onready var sonido_wisp: AudioStreamPlayer = $SonidoWisp



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func musica_interfaz():
	musica_principal.play()

func parar_musica():
	musica_principal.stop()

func musica_nivel():
	musica_niveles.play()

func parar_musica_nivel():
	musica_niveles.stop()

func musica_tiendanivel():
	tienda_nivel.play()

func obtener_orbe():
	agarrar_orbe.play()

func drop_orbe():
	dropeo_orbe.play()

func brasero_prender():
	prender_brasero.play()

func click_boton():
	boton_click.play()

func ganar_nivel():
	nivel_ganado.play()

func perder_nivel():
	nivel_fallido.play()

func lanzar_proyectil():
	proyectil.play()

func MercaderSaludo():
	saludo_mercader.play()

func MercaderVoz():
	voz_mercader.play()

func muerte_avispa():
	print("sonido reproducido")
	sonido_avispa.play()

func muerte_pincho():
	print("sonido reproducido")
	sonido_pincho.play()

func muerte_tanque():
	print("sonido reproducido")
	sonido_tanque.play()

func muerte_mama():
	sonido_mama.play()

func muerte_papa():
	sonido_papa.play()

func wisp_golpeado():
	sonido_wisp.play()
