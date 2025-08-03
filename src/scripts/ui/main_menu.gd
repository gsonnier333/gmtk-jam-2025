extends Control

var game_started: bool = false

func _ready() -> void:
	Events.return_from_options.connect(_back_button_pressed)

func _on_start_game_pressed() -> void:
	UiClick.play()
	game_started = true
	Events.start_game.emit()
	hide()
	


func _on_exit_game_pressed() -> void:
	UiClick.play()
	get_tree().quit.call_deferred()


func _on_options_button_pressed() -> void:
	hide()
	Events.toggle_options.emit()
	
func _back_button_pressed() -> void:
	if !game_started:
		show()
