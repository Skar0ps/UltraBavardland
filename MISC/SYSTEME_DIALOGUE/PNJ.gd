extends CharacterBody2D

@export var conversation_list : Array[Conversation]
var current_conversation : Conversation = null

func start_conversation():
	for conversation in conversation_list:
		if conversation.conditions_fulfilled():
			current_conversation = conversation
			conversation.start()
			

func _physics_process(delta):
	velocity.y += 2048 * delta
	move_and_slide()

func _input(event):
	if event.is_action_pressed("ui_accept"):
		if not is_instance_valid(current_conversation):
			start_conversation()
		else:
			if current_conversation.has_next_line():
				current_conversation.next_line()
			else:
				print("NO LINES ARE LEFT")

func display_bubble(dialogline:DialogLine):
	pass
