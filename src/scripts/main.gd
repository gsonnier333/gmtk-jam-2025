extends Node2D
class_name Main

@onready var game_sv_container: SubViewportContainer = %GameSVContainer
@onready var ui_sv_container: SubViewportContainer = %UISVContainer
@onready var world_manager: Node2D = %WorldManager

@export var cur_level: PackedScene

func _ready() -> void:
	get_tree().root.content_scale_size = Vector2(0, 0)
	Events.change_resolution.connect(change_res)
	Events.change_level.connect(_set_level_deffered)
	Events.restart_level.connect(_restart_level_deffered)
	_set_level(cur_level)

func change_res(res_size: Vector2i):
	print("Changing Resolution to %s" % res_size)
	get_tree().root.set_size(res_size)
	get_tree().root.move_to_center()
		
func _set_level(level_scene: PackedScene):
	cur_level = level_scene
	for child in world_manager.get_children():
		child.free()
	
	var level = level_scene.instantiate()
	
	world_manager.add_child(level)
		
func _set_level_deffered(level_scene: PackedScene):
	_set_level.call_deferred(level_scene)
	
func _restart_level():
	if cur_level:
		for child in world_manager.get_children():
			world_manager.remove_child(child)
		world_manager.add_child(cur_level.instantiate())
	else:
		push_error("Tried to reset level while current level was set to null")
	
func _restart_level_deffered():
	_restart_level.call_deferred()
