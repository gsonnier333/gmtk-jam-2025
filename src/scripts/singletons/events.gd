extends Node

signal freeze_frame(timescale: float, duration: float)
signal camera_shake(intensity: float, duration: float)
signal player_warped(from: float, flipped: bool)
signal change_level(level_scene: PackedScene)
signal change_resolution(window_size: Vector2i)
signal toggle_settings()
