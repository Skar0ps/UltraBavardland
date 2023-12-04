extends Resource

class_name SpeakerInfo

@export var name : String
@export var color : Color

func get_bubble():
	var speaker_instance = get_local_scene().get_tree().get_first_node_in_group(name)
	
	if is_instance_valid(speaker_instance):
		return speaker_instance.get_bubble()
