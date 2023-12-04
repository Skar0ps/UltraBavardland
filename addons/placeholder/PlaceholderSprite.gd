extends Sprite2D

class_name PlaceholderSprite

const sprite_folder : String = "res://addons/placeholder/programmer_art/"

func set_collidable(collidable:bool) -> PlaceholderSprite:
	if collidable:
		var new_body = StaticBody2D.new()
		if centered : new_body.position += texture.get_size()/2
		add_child(new_body)
		var new_col = CollisionShape2D.new()
		new_col.shape = RectangleShape2D.new()
		new_col.shape.size = texture.get_size()/2
		new_body.add_child(new_col)
	else:
		if get_child(0) is StaticBody2D:
			get_child(0).queue_free()
	return self

func set_type(type:String) -> PlaceholderSprite:
	var tex = load(sprite_folder+type+".PNG")
	if tex == null:
		push_warning("No texture found at path : "+sprite_folder+type+".PNG")
		tex = load(sprite_folder+"NAN"+".PNG")
	set_texture(tex)
	return self

## Sets the size of the sprite in pixels
func set_size(size) -> PlaceholderSprite:
	if texture:
		match typeof(size):
			TYPE_INT,TYPE_FLOAT:
				scale = Vector2(size/texture.get_size().x,size/texture.get_size().y) 
			TYPE_VECTOR2:
				scale = size/texture.get_size()
			_:
				push_error("Size can only be set with 'Vector2' or a number !")
	else:
		push_error("The placeholder does not have a texture !")
	return self


## Sets the center of the sprite (in pixels)
# It's a workaround the existing method "set_offset" that i cannot override
func set_center(center) -> PlaceholderSprite:
	match typeof(center):
		TYPE_INT,TYPE_FLOAT:
			offset = Vector2(center,center) 
		TYPE_VECTOR2:
			offset = center
	return self

## Sets the color of the sprite (self_modulate)
func set_color(color:Color) -> PlaceholderSprite:
	self_modulate = color
	return self
