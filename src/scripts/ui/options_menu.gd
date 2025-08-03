extends Control
class_name OptionsMenu

func _ready() -> void:
	Events.toggle_options.connect(_toggle_options)
	
func _on_back_button_pressed() -> void:
	hide()
	Events.return_from_options.emit()
	Events.resume_game.emit()

func _toggle_options() -> void:
	visible = !visible
