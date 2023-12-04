@icon("res://addons/state_machine/icons/statemachine.svg")

extends Node

class_name StateMachine
## Generic state machine.
##
## Initializes [State]s and delegates engine callbacks ([method Node._physics_process], [method Node._unhandled_input]) to the active [member state].

## Emitted when a [State] is entered
signal state_entered(state_name:String)

## Emitted when a [State] is exited
signal state_exited(state_name:String)

## Initial active [State] when the [Node.owner] is ready.
@export var initial_state : State

## [AnimationTree] that will change animation based on the current state
@export var animation_tree : AnimationTree

## The current active [State]. At the start of the game, we get the [member initial_state].
@onready var state: State = initial_state

## The current [member animation_tree]'s [AnimationNodeStateMachinePlayback] used to start its animations
@onready var animation_tree_playback : AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")

func _ready() -> void:
	await owner.ready
	# The state machine assigns itself to the State objects' state_machine property.
	for child in get_children():
		child.state_machine = self
	state.enter()


# The state machine subscribes to node callbacks and delegates them to the state objects.
func _unhandled_input(event: InputEvent) -> void:
	state.handle_input(event)

func _process(delta: float) -> void:
	state.update(delta)

func _physics_process(delta: float) -> void:
	state.physics_update(delta)

## Calls the current [method State.exit] function, changes the active state,
## then calls its [method State.enter] function.
func transition_to(target_state_name: String) -> void:
	# Safety check, you could use an assert() here to report an error if the state name is incorrect.
	# We don't use an assert here to help with code reuse.
	# If you reuse a state in different state machines
	# but you don't want them all, they won't be able to transition to states that aren't in the scene tree.
	if not has_node(target_state_name):
		return

	state.exit()
	emit_signal("state_exited", state.name)
	state = get_node(target_state_name) as State
	state.enter()
	emit_signal("state_entered", state.name)
	
	if animation_tree:
		for state_name in get_state_names():
			# Set the animation condition to true if it's the current state
			var is_current_state = state_name == state.name
			# Example : if state == "run"; then we set the advance condition to the run animation to true
			animation_tree.set("parameters/conditions/"+state_name,is_current_state)

## Returns all of the states linked to this state machine
func get_states(only_names:bool=false) -> Array:
	if only_names: get_children().filter(func(x):return x.name) as PackedStringArray
	return get_children() as Array[State]

## Returns all of the state names linked to this state machine
func get_state_names() -> PackedStringArray:
	return get_children().filter(func(_state): return _state.name)
