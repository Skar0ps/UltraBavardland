extends CharacterBody2D

class_name PlatformerCharacter2D
## A platformer character base class 
##
## [PlatformerCharacter2D] is based on a [member TileSet.tile_size] and uses that [member tile_size] to calculate the player movements.
## We assume that the entire game has the same tile size for every [TileSet] that is accessible via a Singleton
## This class also has a few functions to limit the unfairness feel of the game for the player

signal just_hit_the_floor

# The tile size has been set in the player character for simplicity's sake, 
# but it would preferably be inside a Singleton node so that other game objects can access it easily

## The tile size based on [member TileSet.tile_size]
@export var tile_size : = Vector2(64,64)

@export_category("Movement")

## Speed of the player in tile per second
@export_range(0.0,20.0,1.0,"suffix:tile/s") var speed : float = 3

@export_range(0.0,1.0,0.05,"suffix:weight") var friction : float = 1.0
@export_range(0.0,1.0,0.05,"suffix:weight") var acceleration : float = 1.0

@export_group("Jump")

## Maximum jump height relative to [member tile_size].y
@export_range(1.0,5.0,0.05,"suffix:tile height") var min_jump_height : float = 1.25

## Maximum jump height relative to [member tile_size].y
@export_range(1.0,5.0,0.05,"suffix:tile height") var max_jump_height : float = 3.0

## Time for the jump to reach the maximum height
@export_range(0.0,1.5,0.05,"suffix:s") var jump_duration : float = 0.3

@export_subgroup("Time windows")

## Time window starting when the player jumps after leaving the ground
@export_range(0.0,0.5,0.05,"suffix:s") var coyote_time_duration : float = 0.1

## Time window starting when the player has jumped but is not directly on the floor
@export_range(0.0,0.5,0.05,"suffix:s") var mid_air_jump_duration : float = 0.1

## Velocity required to attain [member max_jump_height]
var max_jump_velocity : float

## Velocity required to attain [member min_jump_height]
var min_jump_velocity : float

## Downwards velocity based on the [member max_jump_height] and the [member jump_duration]
var gravity : float

## Boolean tied to the [member mid_air_jump_duration] time window
var has_jumped_mid_air : bool = false : set = set_has_jumped_mid_air

## Boolean tied to the [member coyote_time_duration] time window
var can_coyote_jump : bool = false : set = set_can_coyote_jump

## Keeps track of whether we were on the floor in the previous frame
var was_on_floor : bool = false

## Keeps track of whether we are currently jumping
var jumping : bool = false

## Keeps track of whether we just collided with the ground or not
var hit_the_ground : bool = false

func _ready() -> void:
	# Main calculations relative to tile size
	speed             = tile_size.x * speed
	min_jump_height   = tile_size.y * min_jump_height
	max_jump_height   = tile_size.y * max_jump_height
	
#	gravity           = 2 * max_jump_height / pow(jump_duration,2)
	gravity           = 2 * max_jump_height / (jump_duration/4)
	max_jump_velocity = -sqrt(2 * gravity * max_jump_height)
	min_jump_velocity = -sqrt(2 * gravity * min_jump_height)

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	controls()
	was_on_floor = is_on_floor()
	move_and_slide()


## Main function for managing how the player moves
func controls():
	# The weight is based on whether or not we are currently moving
	# If we're not moving, we apply friction
	# If we are, we apply acceleration
	var _weight = friction if get_input_vector().x == 0.0 else acceleration
	velocity.x = lerp(velocity.x,get_input_vector().x * speed, _weight)
	handle_jump()

## Everything that relates to the jump goes in that function
func handle_jump():
	if Input.is_action_pressed("ui_up"):
		if is_on_floor() or can_coyote_jump:
			jump()
		# If we are not on the floor but did jump :
		if not is_on_floor():
			set_has_jumped_mid_air(true)
			# A timer is created with the mid air jump duration
			# The timer timeout is then connected to the has jumped variable so that when it ends,
			# the mid air jump is dismissed because it was pressed too early
			get_tree().create_timer(mid_air_jump_duration).timeout.connect(set_has_jumped_mid_air.bind(false))
	
	if is_on_floor():
		if not hit_the_ground:
			hit_the_ground = true
			emit_signal("just_hit_the_floor")
		jumping = false
		if has_jumped_mid_air:
			jump()
	else:
		hit_the_ground = false
		# If we were on the floor, did not jump, and are currently falling :
		if was_on_floor and !jumping and velocity.y >= 0.0:
			set_can_coyote_jump(true)
			# The coyote timer is initiated, when it ends it will prevent us from jumping.
			get_tree().create_timer(coyote_time_duration).timeout.connect(set_can_coyote_jump.bind(false))
		
		# This is for adjusting the jump velocity mid air if the player releases the up key
		if Input.is_action_just_released("ui_up") and velocity.y < min_jump_velocity:
			velocity.y = min_jump_velocity


##  function to h what happens when you jump
func jump(jump_velocity:float=max_jump_velocity):
	velocity.y = jump_velocity
	jumping = true

## Gets an input vector by specifying one positive and one negative action for the Y axis and the X axis respectively[br]
## This is not a shorthand for writing [code]Input.get_vector("left","right","up","down")[/code];
## but a shorthand to get the X axis and the Y axis separated from each other.[br]
## If we used the function: [code]Input.get_vector()[/code]; the Y axis would lower the X axis values, and impact the [member speed] of the player.[br]
## [code]Input.get_vector()[/code] is perfect for top down movements, but not platformer movements
func get_input_vector(negative_x:String="ui_left",positive_x:String="ui_right",negative_y:String="ui_up",positive_y:String="ui_down") -> Vector2:
	var x_axis = Input.get_axis(negative_x,positive_x)
	var y_axis = Input.get_axis(negative_y,positive_y)
	return Vector2(x_axis,y_axis)
	# Uncomment the below code to see why it's not a good fit for a platformer
#	return Input.get_vector("left","right","up","down")


# TIME WINDOWS
func set_has_jumped_mid_air(value:bool):
	has_jumped_mid_air = value

func set_can_coyote_jump(value:bool):
	can_coyote_jump = value


