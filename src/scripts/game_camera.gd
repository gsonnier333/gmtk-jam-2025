extends Camera2D
class_name GameCamera

var rng: RandomNumberGenerator
var shake_strength: float = 0.0
var shake_duration: float = 0.0
var elapsed_time: float = 0.0

func _ready() -> void:
	rng = RandomNumberGenerator.new()
	Events.camera_shake.connect(apply_shake)

func apply_shake(s_strength: float = 30.0, duration: float = 5.0):
	print("shaking the screen with %s power for %s seconds" % [s_strength, duration])
	shake_strength = s_strength
	shake_duration = duration
	elapsed_time = 0.0
	
func _process(delta: float) -> void:
	if shake_strength > 0:
		var new_strength = lerpf(0, shake_strength, (shake_duration - elapsed_time) / shake_duration)
		shake_strength = clampf(new_strength, 0.0, shake_strength)
		offset = random_offset()
		elapsed_time += delta
		
func random_offset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength, shake_strength), rng.randf_range(-shake_strength, shake_strength))
