extends Node

@export var camera : Camera2D
@export var base_distance : float = 600
@export var zoom_ratio : float = 0.0
@export var min_zoom_ratio : float = -1.0
@export var max_zoom_ratio : float = 1.0

var initial_zoom : Vector2
var doom_node : Node2D

func _ready() -> void:
	if camera:
		initial_zoom = camera.zoom
	else:
		set_process(false)
	doom_node = get_tree().get_first_node_in_group(&"doom")
	if not doom_node:
		set_process(false)

func _process(_delta):
	var vertical_distance : float = abs(doom_node.global_position.y - camera.global_position.y)
	var relative_distance : float = base_distance - vertical_distance
	var relative_zoom : float = clamp(zoom_ratio * relative_distance, min_zoom_ratio, max_zoom_ratio)
	camera.zoom = initial_zoom * (1 + relative_zoom)
