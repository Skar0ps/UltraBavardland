@tool
@icon("res://addons/components/classes/icons/pathfinding.svg")
extends Node

class_name PathfindingComponent
## Component that handles navigation to a target
##
## The pathfinding component takes a [NavigationAgent2D] for navigation purposes.

signal target_reached()

## Other pathfinders, or agents that navigates in the same way.
## Used to know how much agents there is to change our behaviour based off the number of agents
static var pathfinders : Array[PathfindingComponent] = []

## Speed of the navigator, in pixel per second
@export_range(0.0,512.0,0.1,"suffix:px/s") var speed: float = 128.0 :
	set(value):
		speed = value
		if navigation_agent:
			navigation_agent.max_speed = value

## Acceleration factor of the navigator.
## 0 means no acceleration.
@export_range(0.0,1.0,0.05,"suffix:(weight)") var acceleration: float = 0.25

@export_group("Agents")
## Navigation agent for pathfinding purposes
@export var navigation_agent: NavigationAgent2D

## Agent affected by the [member navigation_agent] pathfinding calculations
@export var navigation_body : CharacterBody2D :
	set(value):
		navigation_body = value
		if Engine.is_editor_hint():
			if not is_instance_valid(navigation_agent):
				navigation_agent = NavigationAgent2D.new()
				navigation_body.add_child(navigation_agent,true)
				navigation_agent.owner = get_owner()
				navigation_body.position = Vector2.ZERO
				if "speed" in navigation_body:
					navigation_agent.max_speed = navigation_body.speed
				if navigation_body.get_child_count() != 2:
					for child in navigation_body.get_children():
						if child is CollisionShape2D:
							navigation_agent.radius = child.shape.size.length() / 4.0
							navigation_agent.neighbor_distance = child.shape.size.length()/2.0

func _ready() -> void:
	set_physics_process(false)
	if Engine.is_editor_hint(): return
	if not navigation_body:
		navigation_body = get_owner() if get_owner() is CharacterBody2D else get_parent()
	navigation_agent.max_speed = speed
	await navigation_body.ready
	start_pathfinding()

## Starts all the functions related to pathfinding
func start_pathfinding(_target_position:Vector2=Vector2.ZERO):
	navigation_agent.velocity_computed.connect(Callable(_on_velocity_computed))
	set_physics_process(true)
	if _target_position != Vector2.ZERO : set_target(_target_position)
	if not self in pathfinders:
		pathfinders.append(self)

## Stops all the functions related to pathfinding
func stop_pathfinding(reset_velocity:bool=true):
	set_physics_process(false)
	navigation_agent.velocity_computed.disconnect(Callable(_on_velocity_computed))
	if reset_velocity : navigation_body.velocity = Vector2.ZERO
	if self in pathfinders:
		pathfinders.erase(self)

## Shorthand for [method NavigationAgent2D.set_target_position]
func set_target(target_position: Vector2):
	navigation_agent.set_target_position(target_position)
	if pathfinders.size() <= 1:
		navigation_agent.path_postprocessing =NavigationPathQueryParameters2D.PATH_POSTPROCESSING_CORRIDORFUNNEL
	else:
		navigation_agent.path_postprocessing =NavigationPathQueryParameters2D.PATH_POSTPROCESSING_EDGECENTERED
	

func _physics_process(delta):
	if navigation_agent.is_navigation_finished():
		if is_target_reached():
			stop_pathfinding()
		return
	
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()
	var navigation_body_position: Vector2 = navigation_body.global_position
	var dir : Vector2 =  navigation_body_position.direction_to(next_path_position)
	
	var new_velocity: Vector2 = lerp(navigation_body.velocity,dir * speed,1.0+(1.0/acceleration))
	if navigation_agent.avoidance_enabled:
		navigation_agent.set_velocity(new_velocity)
	else:
		_on_velocity_computed(new_velocity)

## Called when the [member navigation_agent] finished computing the [code]safe_velocity[/code] for the [member navigation_agent].
func _on_velocity_computed(safe_velocity: Vector2):
	navigation_body.velocity = safe_velocity
	navigation_body.move_and_slide()

## Shorthand for [member NavigationAgent2D.target_position] and [member NavigationAgent2D.target_reached]
func is_target_reached():
	return navigation_agent.target_position != Vector2.ZERO and navigation_agent.target_reached
