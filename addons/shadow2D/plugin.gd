@tool
extends EditorPlugin


func _enter_tree():
	# Initialization of the plugin goes here.
	# Add the new type with a name, a parent type, a script and an icon.
	add_custom_type("Shadow2D", "Node2D", preload("res://addons/shadow2D/Shadow2D.gd"), preload("res://addons/shadow2D/Shadow2D.svg"))


func _exit_tree():
	# Clean-up of the plugin goes here.
	# Always remember to remove it from the engine when deactivated.
	remove_custom_type("Shadow2D")
