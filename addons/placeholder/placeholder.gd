@tool
extends EditorPlugin

func _enter_tree():
	add_custom_type("PlaceholderMusic", "AudioStreamPlayer", preload("PlaceholderMusic.gd"), preload("icons/music.png"))
	add_custom_type("PlaceholderSound", "AudioStreamPlayer2D", preload("PlaceholderSound.gd"), preload("icons/sfx.png"))
	add_custom_type("PlaceholderSprite", "Sprite2D", preload("PlaceholderSprite.gd"), preload("icons/sprite.png"))

func _exit_tree():
	remove_custom_type("PlaceholderMusic")
	remove_custom_type("PlaceholderSound")
	remove_custom_type("PlaceholderSprite")
