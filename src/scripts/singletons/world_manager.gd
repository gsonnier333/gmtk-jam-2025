extends Node

func _ready() -> void:
	Events.freeze_frame.connect(_freeze_frame)
	
func _freeze_frame(timescale: float, duration: float) -> void:
	Engine.time_scale = timescale
	await get_tree().create_timer(duration, true, false, true).timeout
	Engine.time_scale = 1.0
