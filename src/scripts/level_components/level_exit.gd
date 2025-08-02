extends Area2D
class_name LevelExit

@export var next_level: PackedScene

func _ready() -> void:
	if !next_level:
		push_error("Level exit does not have an assigned Level scene to send the player to")

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		if next_level:
			Events.change_level.emit(next_level)
		else:
			push_error("Level exit does not have an assigned Level scene to send the player to")
