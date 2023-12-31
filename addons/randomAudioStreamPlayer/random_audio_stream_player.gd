@tool
extends AudioStreamPlayer

@export var samples : Array[AudioStream] = [] 
@export_dir var select_samples_from_folder : String : set = load_samples_from_folder
@export_enum("Pure:0", "No consecutive repetition:1", "Use all samples before repeat:2") var random_strategy : int = 0
@export_range(0.0, 80.0,0.1,"suffix:dB") var random_volume_range : float = 0 
@export_range(0.0,4.0,0.05) var random_pitch_range : float = 0 

@onready var base_pitch = pitch_scale
@onready var base_volume = volume_db

var playing_sample_nb : int = -1
var last_played_sample_nb : int = -1 # only used if random_strategy = 1
var to_play = [] # only used if random_strategy = 2

# You can use playing_sample_nb to choose what sample to use
func play(from_position=0.0, playing_sample_nb=-1):
	var number_of_samples = len(samples)
	if number_of_samples > 0:
		if playing_sample_nb < 0:
			if number_of_samples == 1:
				playing_sample_nb = 0
			else:
				match random_strategy:
					1:
						playing_sample_nb = randi() % (number_of_samples - 1)
						if last_played_sample_nb == playing_sample_nb:
							playing_sample_nb += 1
						last_played_sample_nb = playing_sample_nb
					2:
						if len(to_play) == 0:
							for i in range(number_of_samples):
								if i != last_played_sample_nb:
									to_play.append(i)
							to_play.shuffle()
						playing_sample_nb = to_play.pop_back()
						last_played_sample_nb = playing_sample_nb
					_:
						playing_sample_nb = randi() % number_of_samples
			if random_volume_range != 0:
				super.set_volume_db(base_volume + (randf() - .5) * random_volume_range)
			if random_pitch_range != 0:
				super.set_pitch_scale(max(0.0001, base_pitch + (randf() - .5) * random_pitch_range))
		set_stream(samples[playing_sample_nb])
		super.play(from_position)

func set_volume_db(new_volume_db):
	super.set_volume_db(new_volume_db)
	base_volume = new_volume_db

func set_pitch_scale(new_pitch):
	super.set_pitch_scale(max(0.0001, new_pitch))
	base_pitch = new_pitch

func load_samples_from_folder(path):
	if path != "":
		samples.clear()
		var dir = DirAccess.open(path)
		if dir != null:
			dir.list_dir_begin() # TODOConverter3To4 fill missing arguments https://github.com/godotengine/godot/pull/40547
			var file_name = dir.get_next()
			while file_name != "":
				if not dir.current_is_dir() and file_name.ends_with(".import"):
					var resource_path = dir.get_current_dir() + "/" + file_name.replace('.import', '')
					if resource_path.get_extension().to_lower() in ["wav", "ogg"]:
						var resource = load(resource_path)
						if resource != null:
							samples.append(resource)
				file_name = dir.get_next()



