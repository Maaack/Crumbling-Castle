extends Node

@warning_ignore("unused_signal")
signal level_lost
@warning_ignore("unused_signal")
signal level_won(level_path : String)
@warning_ignore("unused_signal")
signal level_changed(level_path : String)

## Optional path to the next level if using an open world level system.
@export_file("*.tscn") var next_level_path : String

var level_state : LevelState

func _ready() -> void:
	var game_state := GameState.get_or_create_state()
	level_state = GameState.get_level_state(scene_file_path)
	level_state.attempts += 1
	GlobalState.save()
