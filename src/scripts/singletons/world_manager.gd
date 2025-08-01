extends Node

@export var loop_effect: PackedScene

func _ready() -> void:
	Events.freeze_frame.connect(_freeze_frame)
	Events.player_warped.connect(_warp_effect)
	
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
	
