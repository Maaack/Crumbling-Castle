extends Node

signal level_won(level_path : String)

@export_file_path("*.dialogue") var dialogue_path : String

func _ready() -> void:
	var dialogue_scene := DialogueManager.show_dialogue_balloon(load(dialogue_path), "start")
	await dialogue_scene.ready
	dialogue_scene.reparent(self)
	await DialogueManager.dialogue_ended
	level_won.emit()
