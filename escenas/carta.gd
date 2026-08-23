extends TextureButton

var id = ""
var is_face_up = false
var front_texture : Texture2D
var back_texture : Texture2D

# Señal para avisar al juego principal que esta carta se volteó
signal card_flipped(card_instance)

func _ready():
	texture_normal = back_texture
	pressed.connect(_on_pressed)

func _on_pressed():
	# Evita voltear la carta si ya está descubierta
	if not is_face_up:
		flip()
		card_flipped.emit(self)

func flip():
	is_face_up = true
	texture_normal = front_texture

func unflip():
	is_face_up = false
	texture_normal = back_texture
