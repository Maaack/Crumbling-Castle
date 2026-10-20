extends "level_dialogue.gd"

signal trip_started

@onready var ambience_stream_player = %AmbienceStreamPlayer

func _ready() -> void:
	MusicController.music_stream_player.stop()
	super._ready()

func start_music() -> void:
	MusicController.music_stream_player.play()

func stop_ambience() -> void:
	var tween := create_tween()
	tween.tween_property(ambience_stream_player, "volume_db", -80, 2)

func start_tripping() -> void:
	trip_started.emit()
	var tween := create_tween()
	tween.tween_property(ambience_stream_player, "volume_db", -20, 12)
