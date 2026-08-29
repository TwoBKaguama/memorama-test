extends TextureButton

var id = ""
var is_face_up = false
var front_texture : Texture2D
var back_texture : Texture2D

var current_tween: Tween

signal card_flipped(card_instance)

func _ready():
	texture_normal = back_texture
	pressed.connect(_on_pressed)
	#custom_minimum_size = Vector2(240, 160)  

func _on_pressed():
	if not is_face_up:
		flip()
		card_flipped.emit(self)

func flip():
	if current_tween:
		current_tween.kill()

	is_face_up = true
	current_tween = create_tween()

	current_tween.tween_property(self, "scale:x", 0.0, 0.15)

	current_tween.tween_callback(func(): texture_normal = front_texture)

	current_tween.tween_property(self, "scale:x", 1.0, 0.15)

func unflip():
	if current_tween:
		current_tween.kill()

	is_face_up = false
	current_tween = create_tween()

	current_tween.tween_property(self, "scale:x", 0.0, 0.15)
	current_tween.tween_callback(func(): texture_normal = back_texture)
	current_tween.tween_property(self, "scale:x", 1.0, 0.15)

func match_found():
	if current_tween:
		current_tween.kill()
		
	texture_normal = front_texture
	scale = Vector2(1.0, 1.0)

	disabled = true

	current_tween = create_tween()
	current_tween.set_parallel(true)

	current_tween.tween_property(self, "modulate", Color(0.5, 0.5, 0.5, 0.6), 0.3)
	current_tween.tween_property(self, "scale", Vector2(0.9, 0.9), 0.3)
