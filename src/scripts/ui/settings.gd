extends Control
class_name Settings

@onready var pause_menu: Control = %PauseMenu
@onready var options: Control = %Options


func _ready() -> void:
	Events.start_game.connect(reset_settings)
	Events.toggle_settings.connect(toggle_settings_helper)
	Events.resume_game.connect(reset_settings)
	#Events.return_from_options.connect(_on_back_button_pressed)
	
func toggle_settings_helper():
	if visible:
		reset_settings()
		Events.resume_game.emit()
	else:
		show()
		Events.pause_game.emit()
	
func reset_settings() -> void:
	visible = false
	pause_menu.visible = true
	options.visible = false
