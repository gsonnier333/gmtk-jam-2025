extends Control
class_name PauseMenu

func _on_exit_button_pressed() -> void:
	get_tree().quit()

func _on_resume_pressed() -> void:
	UiClick.play()
	Events.resume_game.emit()

func _on_options_button_pressed() -> void:
	UiClick.play()
	Events.toggle_options.emit()
	hide()
	
func _on_back_button_pressed() -> void:
	UiClick.play()
	show()

func _on_restart_pressed() -> void:
	UiClick.play()
	Events.restart_level.emit()
	Events.resume_game.emit()
