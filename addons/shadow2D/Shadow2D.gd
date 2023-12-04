@tool
extends Node2D


@export_node_path("PhysicsBody2D") var root_node

## Shadow texture
@export var texture : Texture2D :
	set(value):
		texture = value
		size = texture.get_size()
		if sprite:
			sprite.texture = texture

## Shadow size in pixels
@export var size : Vector2 :
	set(value):
		size = value
		if sprite:
			sprite.scale = size / texture.get_size()
			base_sprite_scale = sprite.scale

## Shadow offset in pixels
@export var offset : Vector2 :
	set(value):
		offset = value
		if sprite:
			sprite.offset = offset

## Maximum vertical distance before the shadow is not visible
@export var max_floor_distance : float :
	set(value):
		max_floor_distance = value
		if ray:
			ray.target_position.y = max_floor_distance

@export_flags_2d_physics var floor_collision_layer : int :
	set(value):
		floor_collision_layer = value
		if ray:
			ray.collision_mask = floor_collision_layer

var ray : RayCast2D = null
var sprite : Sprite2D = null
var base_sprite_scale := Vector2.ZERO
var root : PhysicsBody2D = null


func _ready() -> void:
	if not Engine.is_editor_hint():
		ray = RayCast2D.new()
		ray.target_position.y = max_floor_distance
		ray.collision_mask = floor_collision_layer
		add_child(ray)
		sprite = Sprite2D.new()
		sprite.texture = texture
		add_child(sprite)
		
		if root_node:
			root = get_node(root_node)

func _enter_tree() -> void:
	show_behind_parent = true
	if Engine.is_editor_hint():
		ray = RayCast2D.new()
		ray.target_position.y = max_floor_distance
		add_child(ray)
		ray.set_owner(self)
		
		sprite = Sprite2D.new()
		add_child(sprite)
		sprite.set_owner(self)

func _physics_process(delta: float) -> void:
	if not Engine.is_editor_hint():
		if ray.is_colliding():
			# Set the sprite position to groundlevel (first ray collision point)
			sprite.global_position = ray.get_collision_point()
		# Remapping the distance value to a float between one and zero
		var mapped_distance = remap(sprite.position.y,0,ray.target_position.y,1.0,0.0)
		sprite.scale = Vector2(mapped_distance,mapped_distance)
		sprite.modulate.a = mapped_distance

