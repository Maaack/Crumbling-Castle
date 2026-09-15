@tool
extends Node

@export_file_path() var read_path : String
@export_tool_button("Read") var read_file_action = read_file

func read_file() -> void:
	var amplitude_resource := ResourceLoader.load(read_path)
	var _read_count := 0
	if amplitude_resource is AmplitudeResource:
		for i in range(100):
			print(amplitude_resource.amplitudes[i])
