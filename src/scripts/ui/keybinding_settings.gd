extends Control

@export var input_button: PackedScene
@onready var action_list: VBoxContainer = %ActionList

var is_remapping = false
var action_to_remap = null
var remapping_button = null

var input_actions_dict = {
	"left": "Move Left",
	"right": "Move Right",
	"jump": "Jump",
	"loop": "Loop Effect"
}

func _ready() -> void:
	InputMap.load_from_project_settings()
	_create_action_list()

func _create_action_list():
	for item in action_list.get_children():
		item.queue_free()
	
	for action in input_actions_dict:
		var button = input_button.instantiate()
		var action_label = button.find_child("LabelAction")
		var input_label = button.find_child("LabelInput")
		
		action_label.text = input_actions_dict[action]
		var events = InputMap.action_get_events(action)
		if events.size() > 0:
			input_label.text = events[0].as_text().trim_suffix(" (Physical)")
		else:
			input_label.text = ""
			
		action_list.add_child(button)
		button.pressed.connect(_on_input_button_pressed.bind(button, action))

func _on_input_button_pressed(button: Button, action: String):
	if !is_remapping:
		is_remapping = true
		action_to_remap = action
		remapping_button = button
		button.find_child("LabelInput").text = "Press key to bind..."

func _input(event: InputEvent) -> void:
	if is_remapping:
		if (
			event is InputEventKey ||
			(event is InputEventMouseButton and event.is_pressed())
		):
			# Turn double click to single click
			if event is InputEventMouseButton and event.double_click:
				event.double_click = false
			
			# Remove all actions that are already bound to the event and rebind to the new action
			InputMap.action_add_event(action_to_remap, event)
			_update_action_list(remapping_button, event)
			is_remapping = false
			action_to_remap = null
			remapping_button = null
			
			accept_event()
	
func _update_action_list(button: Button, event: InputEvent):
	button.find_child("LabelInput").text = event.as_text().trim_suffix(" (Physical)")


func _on_reset_button_pressed() -> void:
	_create_action_list()
