extends Node2D

@export var particle_nodes : Array[GPUParticles2D]
@export var animated_sprite_nodes : Array[AnimatedSprite2D]
@export var animation_player : AnimationPlayer
@export var audio_nodes : Array[AudioStreamPlayer2D]
@export_range(0.0,10.0,0.05,"suffix:s") var lifetime : float = 0.0

var calculated_lifetime : float = 0.0

func _ready():
	if is_instance_valid(animation_player):
		var animation_name : String = animation_player.get_animation_list()[0]
		animation_player.play(animation_name)
		calculated_lifetime += animation_player.get_animation(animation_name).length
	else:
		if not particle_nodes.is_empty():
			var maximum_particle_lifetime = 0.0
			for particle in particle_nodes:
				particle.emitting = true
				if particle.lifetime > maximum_particle_lifetime:
					maximum_particle_lifetime = particle.lifetime / (particle.explosiveness if particle.explosiveness != 0.0 else 1.0)
			calculated_lifetime += maximum_particle_lifetime + particle_nodes.size() * 0.1
		if not animated_sprite_nodes.is_empty():
			for animated_sprite in animated_sprite_nodes:
				animated_sprite.play()
	
	for audio in audio_nodes:
		audio.play()
	
	if calculated_lifetime > lifetime:
		await get_tree().create_timer(calculated_lifetime,false).timeout
	else:
		await get_tree().create_timer(lifetime,false).timeout
	queue_free()
