extends Control
class_name Settings

func _ready() -> void:
	Events.toggle_settings.connect(toggle_settings_helper)

func _on_exit_button_pressed() -> void:
	get_tree().quit()

func toggle_settings_helper():
	if visible:
		hide()
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
		Engine.time_scale = 1.0
	else:
		show()
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		Engine.time_scale = 0.00001
