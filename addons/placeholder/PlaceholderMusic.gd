@tool
extends AudioStreamPlayer

class_name PlaceholderMusic

@export var music_list : Array[AudioStreamOggVorbis] = [
	preload("res://addons/placeholder/music/SL_BPM100_A_Crystal_Water.ogg"),
	preload("res://addons/placeholder/music/SL_BPM100_A_Footsteps.ogg"),
	preload("res://addons/placeholder/music/SL_BPM100_A_High_Desert.ogg"),
	preload("res://addons/placeholder/music/SL_BPM100_A_Lucid_Dream.ogg"),
	preload("res://addons/placeholder/music/SL_BPM100_A_Menagerie.ogg"),
	preload("res://addons/placeholder/music/SL_BPM100_A_Pressure.ogg"),
	preload("res://addons/placeholder/music/SL_BPM100_B_Frozen.ogg"),
	preload("res://addons/placeholder/music/SL_BPM100_B_Heavy_Heart.ogg"),
	preload("res://addons/placeholder/music/SL_BPM100_C_Bad_Omen.ogg"),
	preload("res://addons/placeholder/music/SL_BPM100_C_Creeping.ogg"),
	preload("res://addons/placeholder/music/SL_BPM100_C_Daybreak.ogg"),
	preload("res://addons/placeholder/music/SL_BPM100_C_Ice_Age.ogg"),
	preload("res://addons/placeholder/music/SL_BPM100_C_Malice.ogg"),
	preload("res://addons/placeholder/music/SL_BPM100_C_Red_Dawn.ogg"),
	preload("res://addons/placeholder/music/SL_BPM100_C_Sacrificial_Bonfire.ogg"),
	preload("res://addons/placeholder/music/SL_BPM100_C_Shark_Attack.ogg"),
	preload("res://addons/placeholder/music/SL_BPM100_C_Sleepwalker.ogg"),
	preload("res://addons/placeholder/music/SL_BPM100_C_Stillness.ogg"),
	preload("res://addons/placeholder/music/SL_BPM100_D_Night_Watch.ogg"),
	preload("res://addons/placeholder/music/SL_BPM100_D_Rock_the_Cradle.ogg"),
	preload("res://addons/placeholder/music/SL_BPM100_D_Shattered.ogg"),
	preload("res://addons/placeholder/music/SL_BPM100_E_Alone.ogg"),
	preload("res://addons/placeholder/music/SL_BPM100_E_Clocks.ogg"),
	preload("res://addons/placeholder/music/SL_BPM100_F_Dark_Streets.ogg"),
	preload("res://addons/placeholder/music/SL_BPM100_F_Night_Drive.ogg"),
	preload("res://addons/placeholder/music/SL_BPM100_G_Alien_Ocean.ogg")
]

#const sfx_folder : String = "res://addons/placeholder/sfx/"

@export var random_stream: bool: set = set_random_stream

var random_pitch = true

func _ready() -> void:
	finished.connect(queue_free)
	randomize()
	var audio_stream = music_list.pick_random()
	set_stream(audio_stream)
	set_bus("SFX")
	play()

func set_random_stream(value:bool):
	stream = music_list[randi()%music_list.size()-1]
	notify_property_list_changed()
