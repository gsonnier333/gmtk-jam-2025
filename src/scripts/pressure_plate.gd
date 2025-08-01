extends Node2D
class_name PressurePlate

@export var activate_objects: Array[Node2D]

@onready var activate_collision: CollisionShape2D = %ActivateCollision
@onready var activate_sprite: Sprite2D = %ActivateSprite

@onready var plate_base_sprite: Sprite2D = %PlateBaseSprite


func _ready() -> void:
	if not activate_objects or activate_objects.is_empty():
		push_error("Pressure plate not connected to an activateable object")

func _on_pressure_plate_area_body_entered(body: Node2D) -> void:
	if body is Player:
		for obj in activate_objects:
			if obj.has_method("toggle"):
				obj.toggle()
		activate_sprite.hide()
		plate_base_sprite.show()

func _on_pressure_plate_area_body_exited(body: Node2D) -> void:
	if body is Player:
		activate_sprite.show()
		plate_base_sprite.hide()
