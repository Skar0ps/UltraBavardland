extends Resource

class_name DialogLine

@export var conditions : Dictionary = {}
@export var speaker : SpeakerInfo 
@export_multiline var text : String

## Returns true if every conditions are fulfilled
func conditions_fulfilled():
	return conditions.values().all(func(condition): if condition == true : return true) if not conditions.is_empty() else true

