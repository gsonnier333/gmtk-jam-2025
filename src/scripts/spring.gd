extends Area2D
class_name Spring

@export var spring_power: float = -600

@onready var extended_hitbox: CollisionShape2D = %ExtendedHitbox
@onready var coiled_hitbox: CollisionShape2D = %CoiledHitbox
@onready var extended_spring_sprite: Sprite2D = %ExtendedSpringSprite
@onready var coiled_spring_sprite: Sprite2D = %CoiledSpringSprite
@onready var sound_effect: AudioStreamPlayer2D = %SoundEffect
@onready var pitch_shift: float = -1 * (spring_power + 600) / 1000  



func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.set_player_velocity(spring_power * calculate_velocity_dir())
		extend_spring.call_deferred()
		

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		sound_effect.pitch_scale = 1.0 + pitch_shift
		sound_effect.play()
		body.set_player_velocity(spring_power * calculate_velocity_dir())
		coil_spring.call_deferred()
		
func calculate_velocity_dir() -> Vector2:
	return Vector2(sin(-global_rotation), cos(global_rotation))

func extend_spring():
	extended_hitbox.set_disabled(true)
	extended_spring_sprite.hide()
	coiled_hitbox.set_disabled(false)
	coiled_spring_sprite.show()
		
func coil_spring():
	extended_hitbox.set_disabled(false)
	extended_spring_sprite.show()
	coiled_hitbox.set_disabled(true)
	coiled_spring_sprite.hide()
