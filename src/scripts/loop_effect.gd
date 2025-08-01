extends AnimatedSprite2D

var position_x: float = 0.0
var position_y: float = 0.0
var reversed: bool = false

func setup(pos_x: float, pos_y: float, rev: bool) -> void:
	position_x = pos_x
	position_y = pos_y
	reversed = rev

func _ready() -> void:
	visible = true
	#global_position.x = position_x
	#global_position.y = position_y
	if reversed:
		play("reverse")
	else:
		play("default")

func _on_animation_finished() -> void:
	queue_free()
