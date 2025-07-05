extends Control

@export var fps_display: Label

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	var fps: float = Engine.get_frames_per_second()
	var fps_string = str(fps) + " fps"
	fps_display.text = fps_string
	
