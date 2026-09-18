extends Node

signal level_won(level_path : String)
signal trip_started

@export_file_path("*.dialogue") var dialogue_path : String
@export var dialogue_cue : String = "start"

func _ready() -> void:
	ProjectMusicController.music_stream_player.stop()
	var dialogue_scene := DialogueManager.show_dialogue_balloon(load(dialogue_path), dialogue_cue, [self])
	await dialogue_scene.ready
	dialogue_scene.reparent(self)
	await DialogueManager.dialogue_ended
	level_won.emit()

func start_music() -> void:
	ProjectMusicController.music_stream_player.play()

func start_tripping() -> void:
	trip_started.emit()
