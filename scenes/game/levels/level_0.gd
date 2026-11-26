extends "level_dialogue.gd"

signal trip_started

@onready var ambience_stream_player = %AmbienceStreamPlayer

var start_ambience_tween : Tween

func _ready() -> void:
	MusicController.music_stream_player.stop()
	super._ready()

func start_music() -> void:
	MusicController.music_stream_player.play()

func stop_ambience() -> void:
	if start_ambience_tween and start_ambience_tween.is_running():
		start_ambience_tween.stop()
	var tween := create_tween()
	tween.tween_property(ambience_stream_player, "volume_db", -80, 2)

func start_tripping() -> void:
	trip_started.emit()
	start_ambience_tween = create_tween()
	start_ambience_tween.tween_property(ambience_stream_player, "volume_db", -20, 12)
