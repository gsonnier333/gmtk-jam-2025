extends Control
class_name DisplayOptions

var display_resolutions: Array = [
	Vector2i(640, 360),
	Vector2i(1280, 720),
	Vector2i(1920, 1080),
	Vector2i(2560, 1440)
]
@onready var display_options: OptionButton = %DisplayOptions

func _ready() -> void:
	var item_id: int = display_options.get_selected_id()
	var item_index: int = display_options.get_item_index(item_id)
	print("emiting signal %s" % [display_resolutions[item_index]])
	Events.change_resolution.emit.call_deferred(display_resolutions[item_index])

func _on_check_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_display_options_item_selected(index: int) -> void:
	Events.change_resolution.emit(display_resolutions[index])
