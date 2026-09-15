@tool
extends Node

@export_file_path() var read_path : String
@export_file_path() var target_path : String
@export var ignore_first_bytes : int = 128
@export_tool_button("Read & Write") var read_file_action = read_file

func read_file() -> void:
	var _read_file := FileAccess.open(read_path, FileAccess.READ)
	var amplitude_data := AmplitudeResource.new()
	var _read_count := 0
	var _buffer := _read_file.get_buffer(ignore_first_bytes)
	while _read_file.get_position() < _read_file.get_length():
		var next_amplitude := _read_file.get_float()
		amplitude_data.append(next_amplitude)
		_read_count += 1
		if _read_count < 100:
			print(next_amplitude)
	_read_file.close()
	print("Read %d entries" % _read_count)
	ResourceSaver.save(amplitude_data, target_path)
