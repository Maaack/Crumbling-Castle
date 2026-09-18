extends "level_dialogue.gd"

signal trip_started

func _ready() -> void:
	ProjectMusicController.music_stream_player.stop()
	super._ready()

func start_music() -> void:
	ProjectMusicController.music_stream_player.play()

func start_tripping() -> void:
	trip_started.emit()
