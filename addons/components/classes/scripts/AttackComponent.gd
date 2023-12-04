@icon("res://addons/components/classes/icons/attack.svg")
extends Area2D

class_name AttackComponent
## Attack region that detects other [member HitboxComponent]s

@export_range(0.0,100.0) var power : float

func _ready() -> void:
	body_entered.connect(_on_entity_detected)

func _on_entity_detected(entity):
	if entity is HitboxComponent:
		damage_entity(entity)

func damage_entity(entity:HitboxComponent):
	entity.damage(power,self)
