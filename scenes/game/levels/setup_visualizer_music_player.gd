extends AudioStreamPlayer

@export var repeat_from_position : float = 1.0
@export var repeat_delay : float = 3.0
@onready var music_visualizer = %MusicVisualizer

func _process(_delta):
	if get_playback_position() > repeat_from_position:
		stop()
		music_visualizer.reset()
		await(get_tree().create_timer(repeat_delay, false).timeout)
		play(0.0)
