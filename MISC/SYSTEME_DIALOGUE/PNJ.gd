extends CharacterBody2D

func _physics_process(delta):
	velocity.y += 2048 * delta
	move_and_slide()
