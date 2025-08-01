extends Area2D
class_name LevelExit


func _on_body_entered(body: Node2D) -> void:
	Events.change_to_next_level.emit()
