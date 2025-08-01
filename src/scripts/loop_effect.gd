extends AnimatedSprite2D

func _ready() -> void:
	visible = true
	play("cat_looped")

func _on_animation_finished() -> void:
	queue_free()
