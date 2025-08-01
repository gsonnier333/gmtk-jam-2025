extends Node

var loop_effect: PackedScene = preload("res://src/scenes/loop_effect.tscn")

func _ready() -> void:
	Events.freeze_frame.connect(_freeze_frame)
	Events.player_warped.connect(_warp_effect)
	
func _freeze_frame(timescale: float, duration: float) -> void:
	Engine.time_scale = timescale
	await get_tree().create_timer(duration, true, false, true).timeout
	Engine.time_scale = 1.0

func _warp_effect(to: Vector2, from: Vector2) -> void:
	var loop1 = loop_effect.instantiate()
	loop1.global_position.x = from.x
	loop1.global_position.y = from.y
	loop1.reversed = true
	var loop2 = loop_effect.instantiate()
	loop2.global_position.x = to.x
	loop2.global_position.y = to.y
	loop2.reversed = false
	add_child(loop1)
	add_child(loop2)
	
