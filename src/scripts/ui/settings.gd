extends Control
class_name Settings

@onready var pause_menu: MarginContainer = %PauseMenu
@onready var back_button: Button = %BackButton
@onready var options: VBoxContainer = %Options


func _ready() -> void:
	Events.toggle_settings.connect(toggle_settings_helper)

func _on_exit_button_pressed() -> void:
	get_tree().quit()

func toggle_settings_helper():
	if visible:
		reset_settings()
		Events.resume_game.emit()
	else:
		show()
		Events.pause_game.emit()

func _on_resume_pressed() -> void:
	reset_settings()
	Events.resume_game.emit()

func _on_options_button_pressed() -> void:
	options.show()
	pause_menu.hide()

func _on_back_button_pressed() -> void:
	options.hide()
	pause_menu.show()

func _on_restart_pressed() -> void:
	reset_settings()
	Events.restart_level.emit()
	Events.resume_game.emit()
	
func reset_settings() -> void:
	visible = false
	pause_menu.visible = true
	options.visible = false
