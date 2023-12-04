@icon("res://addons/components/classes/icons/hitbox.svg")
extends Area2D

class_name HitboxComponent

signal hit(value:float,source:AttackComponent)

@export var health_component : HealthComponent

func damage(value:float,source:AttackComponent):
	if health_component:
		health_component.damage(value,source)
	hit.emit(value,source)
