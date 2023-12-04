extends Node

var condition_list : Dictionary = {}

func is_condition_fulfilled(condition_name:String) -> bool:
	if condition_name.is_empty(): return false
	if condition_list.has(condition_name):
		if condition_list[condition_name]:
			return true
	return false

func are_condition_fulfilled(condition_name_list:PackedStringArray) -> bool:
	if condition_name_list.is_empty() : return false
	for condition in condition_name_list:
		if not is_condition_fulfilled(condition):
			return false
	return true
