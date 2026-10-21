extends Control

## If Maaack's Scene Loader is installed, then it will be used to change scenes.
@onready var scene_loader_node = get_tree().root.get_node_or_null(^"SceneLoader")

func get_game_scene_path() -> String:
	return MaaacksGameTemplate.get_game_path()

func load_game_scene() -> void:
	if scene_loader_node:
		scene_loader_node.load_scene(get_game_scene_path())
	else:
		get_tree().change_scene_to_file(get_game_scene_path())

func _on_done_button_pressed():
	load_game_scene()
