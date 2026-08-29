extends Node2D

@onready var grid = $CenterContainer/GridContainer
@onready var timer = $Timer
@onready var pantalla_victoria = $PantallaVictoria
var pares_encontrados = 0

var card_scene = preload("res://escenas/carta.tscn")

var card_textures = [
	preload("res://assets/Adreus, Keeper of Armageddon_Fiend_XYZ Monster_lvl5_DARK.jpg"),
	preload("res://assets/Alien Ammonite_Reptile_Tuner Monster_lvl1_LIGHT.jpg"),
	preload("res://assets/Alien Mother_Reptile_Effect Monster_lvl6_DARK.jpg"),
	preload("res://assets/Dark Magician Girl the Dragon Knight_Dragon_Fusion Monster_lvl7_DARK.jpg"),
	preload("res://assets/Magician of Black Chaos MAX_Spellcaster_Ritual Effect Monster_lvl8_DARK.jpg"),
	preload("res://assets/Magician's Robe_Spellcaster_Effect Monster_lvl2_DARK.jpg"),
]

var back_texture = preload("res://assets/Sin_carta.webp")

var deck = []
var first_card = null
var second_card = null
var input_locked = false

func _ready():
	setup_game()
	pantalla_victoria.hide()

func setup_game():
	for tex in card_textures:
		deck.append(tex)
		deck.append(tex)
	
	# Mezclar las cartas
	deck.shuffle()
	
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
		first_card.match_found()
		second_card.match_found()
		
		# Aumentar el contador
		pares_encontrados += 1
		
		# Revisar si ya encontramos todos (la mitad del total de cartas)
		if pares_encontrados == deck.size() / 2:
			pantalla_victoria.show() # Mostrar la pantalla de victoria
			
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


func _on_button_pressed():
	# Recarga la escena actual, reseteando todo el juego
	get_tree().reload_current_scene()
