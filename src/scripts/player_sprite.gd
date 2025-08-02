extends AnimatedSprite2D

@onready var level_sound: AudioStreamPlayer = %LevelSound

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play("level_start")
	level_sound.play()


func _on_animation_finished() -> void:
	play("default")
