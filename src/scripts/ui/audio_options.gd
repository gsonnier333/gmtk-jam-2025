extends Control
class_name AudioOptions

@onready var master_audio_label: Label = %MasterAudioLabel
@onready var master_audio_slider: HSlider = %MasterAudioSlider
@onready var music_audio_label: Label = %MusicAudioLabel
@onready var music_audio_slider: HSlider = %MusicAudioSlider
@onready var sfx_audio_label: Label = %SfxAudioLabel
@onready var sfx_audio_slider: HSlider = %SfxAudioSlider

func _ready() -> void:
	master_audio_label.text = str(int(master_audio_slider.value))
	AudioServer.set_bus_volume_linear(0, master_audio_slider.value / 100.0)
	music_audio_label.text = str(int(music_audio_slider.value))
	AudioServer.set_bus_volume_linear(1, music_audio_slider.value / 100.0)
	sfx_audio_label.text = str(int(sfx_audio_slider.value))
	AudioServer.set_bus_volume_linear(2, sfx_audio_slider.value / 100.0)

func _on_master_audio_slider_value_changed(value: float) -> void:
	master_audio_label.text = str(int(value))
	AudioServer.set_bus_volume_linear(0, value / 100.0)

func _on_music_audio_slider_value_changed(value: float) -> void:
	music_audio_label.text = str(int(value))
	AudioServer.set_bus_volume_linear(1, value / 100.0)

func _on_sfx_audio_slider_value_changed(value: float) -> void:
	sfx_audio_label.text = str(int(value))
	AudioServer.set_bus_volume_linear(2, value / 100.0)


func _on_master_audio_slider_drag_ended(value_changed: bool) -> void:
	UiClick.play()


func _on_music_audio_slider_drag_ended(value_changed: bool) -> void:
	UiClick.play()


func _on_sfx_audio_slider_drag_ended(value_changed: bool) -> void:
	UiClick.play()
