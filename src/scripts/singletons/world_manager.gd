extends Node

@export var loop_effect: PackedScene
var game_started: bool = false

func _ready() -> void:
	Events.freeze_frame.connect(_freeze_frame)
	Events.player_warped.connect(_warp_effect)
	Events.pause_game.connect(_pause_game)
	Events.resume_game.connect(_resume_game)
	Events.start_game.connect(_start_game)
	
func _freeze_frame(timescale: float, duration: float) -> void:
	Engine.time_scale = timescale
	await get_tree().create_timer(duration, true, false, true).timeout
	Engine.time_scale = 1.0

func _warp_effect(from: Vector2, flipped: bool) -> void:
	var loop = loop_effect.instantiate()
	loop.global_position.x = from.x
	loop.global_position.y = from.y
	loop.flip_h = flipped
	
	add_child(loop)
	
func _start_game():
	game_started = true
	
func _pause_game() -> void:
	if game_started:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		Engine.time_scale = 0.0

func _resume_game() -> void:
	if game_started:
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
		Engine.time_scale = 1.0
	
	
