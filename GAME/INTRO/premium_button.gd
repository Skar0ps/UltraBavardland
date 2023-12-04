extends Button

static var press_count = 0

@onready var premium = %Premium
@onready var popup_sound = %popup_sound

func _ready():
	pressed.connect(_on_pressed)

func _on_pressed():
	press_count += 1
	premium.popup()
