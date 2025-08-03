extends Control
class_name DisplayOptions

var display_resolutions: Array = [
	Vector2i(640, 360),
	Vector2i(1280, 720),
	Vector2i(1920, 1080),
	Vector2i(2560, 1440),
	Vector2i(3840, 2160)
]
@onready var display_options: OptionButton = %DisplayOptions
var cur_item_index: int

func _ready() -> void:
	var item_id = display_options.get_selected_id()
	cur_item_index = display_options.get_item_index(item_id)
	var cur_res = display_resolutions[cur_item_index]
	print("emiting signal %s" % [cur_res])
	Events.change_resolution.emit.call_deferred(cur_res)

func _on_check_button_toggled(toggled_on: bool) -> void:
	UiClick.play()
	if toggled_on:
		display_options.disabled = true
		display_options.selected = -1
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else:
		display_options.disabled = false
		display_options.selected = cur_item_index
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_display_options_item_selected(index: int) -> void:
	UiClick.play()
	cur_item_index = index
	Events.change_resolution.emit(display_resolutions[cur_item_index])
