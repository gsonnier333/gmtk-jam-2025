extends Node2D
class_name Main

@onready var game_sv_container: SubViewportContainer = %GameSVContainer
@onready var ui_sv_container: SubViewportContainer = %UISVContainer
@onready var world_manager: Node2D = %WorldManager

func _ready() -> void:
	get_tree().root.content_scale_size = Vector2(0, 0)
	Events.change_resolution.connect(change_res)
	Events.change_level.connect(_set_level_deffered)

func change_res(res_size: Vector2i):
	print("Changing Resolution to %s" % res_size)
	get_tree().root.set_size(res_size)
		
func _set_level(level_scene: PackedScene):
	for child in world_manager.get_children():
		child.free()
	
	var level = level_scene.instantiate()
	
	world_manager.add_child(level)
		
func _set_level_deffered(level_scene: PackedScene):
	_set_level.call_deferred(level_scene)
