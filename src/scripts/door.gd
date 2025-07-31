extends StaticBody2D
class_name Door

@onready var collision_shape: CollisionShape2D = %CollisionShape
@onready var door_animated_sprite: AnimatedSprite2D = %DoorAnimatedSprite

func activate():
	activate_door(true)

func deactivate():
	activate_door(false)

func activate_door(open: bool):
	if open:
		collision_shape.set_disabled.call_deferred(true)
		door_animated_sprite.play("door_open")
	else:
		collision_shape.set_disabled.call_deferred(false)
		door_animated_sprite.play_backwards("door_open")
