extends Resource

class_name Conversation

signal started()
signal line_changed()
signal finished()

## All the conditions that need to be fulfilled in order to get this conversation
## {String:bool}
@export var conditions : Dictionary = {}

## Kills the conversation after it has been said once
@export var one_shot : bool = true

## All the lines that this conversation has
@export var lines : Array[DialogLine]

var current_line_index : int = 0 :
	set(value):
		current_line_index = value
		line_changed.emit(get_current_line())

## Returns true if every conditions are fulfilled
func conditions_fulfilled():
	return conditions.values().all(func(condition): if condition == true : return true) if not conditions.is_empty() else true

## Triggers the first possible conversation
func start():
	lines = get_possible_lines()
	if lines.is_empty(): return null
	

func next_line() -> DialogLine:
	if not has_next_line():
		return null
	current_line_index += 1
	return get_current_line()

func has_next_line() -> bool:
	return current_line_index < lines.size()-1

func get_current_line() -> DialogLine:
	return lines[current_line_index]

## Returns all the lines that are possible with
## every conditions the player has fulfilled so far
func get_possible_lines():
	return lines.filter(func(l):if l.conditions_fulfilled() : return l)
