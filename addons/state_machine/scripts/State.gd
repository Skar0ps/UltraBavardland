@icon("res://addons/state_machine/icons/state.svg")

extends Node

class_name State
## Virtual base class for all states.

## Reference to the [StateMachine], to call its [method StateMachine.transition_to] method directly.
## That's one unorthodox detail of our state implementation, as it adds a dependency between the
## state and the state machine objects, but we found it to be most efficient for our needs.
## The state machine node will set it.
@onready var state_machine : StateMachine = get_parent()


## Virtual function. Receives events from the [method Node._unhandled_input] callback.
func handle_input(_event: InputEvent) -> void:
	pass


## Virtual function. Corresponds to the [method Node._process] callback.
func update(_delta: float) -> void:
	pass


## Virtual function. Corresponds to the [method Node._physics_process] callback.
func physics_update(_delta: float) -> void:
	pass


## Virtual function. 
## Called by the [member state_machine] upon changing the active state.
func enter() -> void:
	pass


## Virtual function.
## Called by the state machine before changing the active state.
## Use this function to clean up the state.
func exit() -> void:
	pass
