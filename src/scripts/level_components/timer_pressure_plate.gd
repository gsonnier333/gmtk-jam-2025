extends Node2D
class_name TimerPressurePlate

@export var timer_time: float = 3.5
@export var activate_objects: Array[Node2D]

@onready var activate_collision: CollisionShape2D = %ActivateCollision
@onready var activate_sprite: Sprite2D = %ActivateSprite

@onready var plate_base_sprite: Sprite2D = %PlateBaseSprite
@onready var sound_effect: AudioStreamPlayer2D = %SoundEffect
@onready var timer: Timer = %Timer


func _ready() -> void:
	timer.wait_time = timer_time
	if not activate_objects or activate_objects.is_empty():
		push_error("Pressure plate not connected to an activateable object")

func _on_pressure_plate_area_body_entered(body: Node2D) -> void:
	if body is Player:
		if timer.is_stopped():
			var activate_sound_played := false
			for obj in activate_objects:
				if obj.has_method("toggle"):
					obj.toggle()
					if obj.has_method("play_sound") and !activate_sound_played:
						activate_sound_played = true
						obj.play_sound()
			timer.start()
			sound_effect.play()
			activate_sprite.hide()
			plate_base_sprite.show()


func _on_timer_timeout() -> void:
	timer.stop()
	var activate_sound_played := false
	sound_effect.stop()
	for obj in activate_objects:
		if obj.has_method("toggle"):
			obj.toggle()
			if obj.has_method("play_sound") and !activate_sound_played:
				activate_sound_played = true
				obj.play_sound()
	activate_sprite.show()
	plate_base_sprite.hide()
