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
	var tween = create_tween()
	
	# Comprime la carta en 0.15 segundos
	tween.tween_property(self, "scale:x", 0.0, 0.15)
	
	# Cambia la imagen justo cuando no se ve
	tween.tween_callback(func(): texture_normal = front_texture)
	
	# Restaura el ancho original
	tween.tween_property(self, "scale:x", 1.0, 0.15)

func unflip():
	is_face_up = false
	var tween = create_tween()
	
	tween.tween_property(self, "scale:x", 0.0, 0.15)
	tween.tween_callback(func(): texture_normal = back_texture)
	tween.tween_property(self, "scale:x", 1.0, 0.15)
