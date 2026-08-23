extends Node2D

@onready var grid = $GridContainer
@onready var timer = $Timer

# Cargar la escena de la carta
var card_scene = preload("res://escenas/carta.tscn")

# Texturas (Rutas de ejemplo, ajústalas a tus archivos)
var card_textures = [
	preload("res://assets/cecilia_immergreen.webp"),
	preload("res://assets/honshou_marin.webp"),
	preload("res://assets/kikirara_vivi.webp"),
	preload("res://assets/mizumiya_su.webp"),
	preload("res://assets/nakiri_ayame.webp"),
	preload("res://assets/raora_panthera.webp"),
]

var back_texture = preload("res://assets/reverse_test.webp")

var deck = []
var first_card = null
var second_card = null
var input_locked = false

func _ready():
	setup_game()

func setup_game():
	# Duplicar las texturas para crear los pares
	for tex in card_textures:
		deck.append(tex)
		deck.append(tex)
	
	# Mezclar las cartas
	deck.shuffle()
	
	# Instanciar cada carta en la cuadrícula
	for i in range(deck.size()):
		var card = card_scene.instantiate()
		card.id = deck[i].resource_path # Usar la ruta como ID para comparar
		card.front_texture = deck[i]
		card.back_texture = back_texture
		card.card_flipped.connect(_on_card_flipped)
		grid.add_child(card)

func _on_card_flipped(card):
	# Evitar interacción si estamos procesando un error
	if input_locked:
		card.unflip()
		return
		
	if first_card == null:
		first_card = card
	elif second_card == null and card != first_card:
		second_card = card
		check_match()

func check_match():
	input_locked = true
	
	if first_card.id == second_card.id:
		# ¡Es un par!
		first_card.disabled = true
		second_card.disabled = true
		reset_selection()
	else:
		# No coinciden, esperar y regresar
		timer.start()
		await timer.timeout
		first_card.unflip()
		second_card.unflip()
		reset_selection()

func reset_selection():
	first_card = null
	second_card = null
	input_locked = false
