extends AudioStreamPlayer2D

class_name PlaceholderSound


const sfx_list = {
	"UI":[
		
	],
}
#const sfx_folder : String = "res://addons/placeholder/sfx/"

@export var random_stream: bool

var random_pitch = true

func _init(_random_pitch:bool=true) -> void:
	random_pitch = _random_pitch

func _ready() -> void:
	connect("finished", Callable(self, "queue_free"))
	var audio_stream 
	if random_pitch:
		audio_stream = AudioStreamRandomizer.new()
		audio_stream.audio_stream = sfx_list[randi()%sfx_list.size()-1]
	else:
		audio_stream = sfx_list[randi()%sfx_list.size()-1]
	set_stream(audio_stream)
	set_bus("SFX")
	play()

#func get_all_sfx() -> Array:
#	var sound_effects : Array = []
#	var dir = Directory.new()
#	if dir.open(sfx_folder) == OK:
#		dir.list_dir_begin(true)
#		var file_name = dir.get_next()
#		while file_name.strip_edges() != '':
#			if not dir.current_is_dir() and file_name.get_extension().to_lower() == "wav" :
#				sound_effects.append(load(sfx_folder+file_name))
#				file_name = dir.get_next()
#	return sound_effects
