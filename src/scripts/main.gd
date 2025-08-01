extends Node2D
class_name Main

@onready var game_sv_container: SubViewportContainer = %GameSVContainer
@onready var ui_sv_container: SubViewportContainer = %UISVContainer


func _ready() -> void:
	get_tree().root.content_scale_size = Vector2(0, 0)
	Events.change_resolution.connect(change_res)

func change_res(res_size: Vector2i):
	print("Changing Resolution to %s" % res_size)
	get_tree().root.set_size(res_size)
		
