extends StaticBody2D
class_name Door

@onready var collision_shape: CollisionShape2D = %CollisionShape
@onready var door_animated_sprite: AnimatedSprite2D = %DoorAnimatedSprite
@onready var sound_effect: AudioStreamPlayer2D = %SoundEffect

@export var activated: bool = false:
	set(new_activated):
		activated = new_activated
		if activated:
			deactivate()
		else:
			activate()

func _ready():
	print(activated)
	activated = activated

func activate():
	print("activate called")
	if collision_shape:
		collision_shape.set_disabled.call_deferred(true)
	if door_animated_sprite:
		door_animated_sprite.play("door_open")

func deactivate():
	print("deactivate called")
	if collision_shape:
		collision_shape.set_disabled.call_deferred(false)
	if door_animated_sprite:
		door_animated_sprite.play_backwards("door_open")
		
func toggle():
	sound_effect.play()
	if activated:
		activated = false
	else:
		activated = true
