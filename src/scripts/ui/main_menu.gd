extends Control


func _on_start_game_pressed() -> void:
	UiClick.play()
	Events.start_game.emit()
	hide()
	


func _on_exit_game_pressed() -> void:
	UiClick.play()
	get_tree().quit.call_deferred()
