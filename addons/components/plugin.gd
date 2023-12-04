@tool
extends EditorPlugin


func _enter_tree() -> void:
	add_custom_type("HealthComponent","Node",preload("res://addons/components/classes/scripts/HealthComponent.gd"),preload("res://addons/components/classes/icons/health.svg"))
	add_custom_type("HitboxComponent","Node",preload("res://addons/components/classes/scripts/HitboxComponent.gd"),preload("res://addons/components/classes/icons/hitbox.svg"))
	add_custom_type("AttackComponent","Node",preload("res://addons/components/classes/scripts/AttackComponent.gd"),preload("res://addons/components/classes/icons/attack.svg"))



func _exit_tree() -> void:
	remove_custom_type("HealthComponent")
	remove_custom_type("HitboxComponent")
	remove_custom_type("AttackComponent")

