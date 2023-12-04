@icon("res://addons/components/classes/icons/health.svg")
extends Node

class_name HealthComponent
## Component that gives health to an entity

signal health_changed(health,source)
signal died(source)

@export var invincible : bool = false
@export_range(0.0,1.0,0.1,"suffix:s") var invincibility_duration : float = 0.0

@export_range(0.0,100.0) var max_hp = 0.0

@onready var hp = max_hp :
	set(value):
		hp = clamp(value,0,max_hp)

func damage(value:float,source:AttackComponent):
	if value == 0 : return
	if !invincible:
		hp -= value
		if invincibility_duration > 0.0:
			invincibility_window()
		emit_signal("health_changed",hp,source)
		if hp == 0:
			emit_signal("died",source)
			die(source)

func heal(value:float,source:Node):
	if value == 0 : return
	hp += value
	emit_signal("health_changed",hp,source)

func invincibility_window():
	get_tree().create_timer(invincibility_duration,false).timeout.connect(func():invincible=false)

func die(source):
	print("killed by ",source.name)
	owner.queue_free()
