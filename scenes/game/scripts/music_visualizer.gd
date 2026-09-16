@tool
extends Node

const BYTES_PER_FLOAT := 4

@export_file_path() var data_file_path : String
@export var data_sample_rate : int = 32000
@export var ignore_first_bytes : int = 128
@export_tool_button("Verify File") var verify_file_size_action = _verify_file_size
## Music Visualizer depends on the MusicController autoload.
@onready var music_controller_node = get_tree().root.get_node_or_null(^"ProjectMusicController")

var data_file : FileAccess
var last_position : float = 0.0
var last_byte_offset : int = 0

func _verify_file_size() -> void:
	var file_size := FileAccess.get_size(data_file_path)
	@warning_ignore("integer_division")
	var expecting_entries := (file_size - ignore_first_bytes) / BYTES_PER_FLOAT
	print("Expecting %d entries." % expecting_entries)

func open_data_file() -> void:
	data_file = FileAccess.open(data_file_path, FileAccess.READ)
	var _read_count := 0
	var _buffer := data_file.get_buffer(ignore_first_bytes)

func _ready() -> void:
	open_data_file()

func _process(_delta):
	if Engine.is_editor_hint():
		return
	if not music_controller_node:
		return
	var current_position : float = music_controller_node.get_playback_position() + AudioServer.get_time_since_last_mix()
	var byte_offset := int(data_sample_rate * current_position)
	var byte_range := byte_offset - last_byte_offset
	if byte_range == 0:
		return
	var next_floats : Array[float] = []
	for iter in range(byte_range):
		next_floats.append(data_file.get_float())
	print(next_floats.max())
	last_byte_offset = byte_offset
