@tool
extends EditorPlugin

func _enter_tree() -> void:
	add_custom_type("StateMachine","Node",preload("res://addons/state_machine/scripts/StateMachine.gd"),preload("res://addons/state_machine/icons/statemachine.svg"))
	add_custom_type("State","Node",preload("res://addons/state_machine/scripts/State.gd"),preload("res://addons/state_machine/icons/state.svg"))

func _exit_tree() -> void:
	remove_custom_type("StateMachine")
	remove_custom_type("State")
