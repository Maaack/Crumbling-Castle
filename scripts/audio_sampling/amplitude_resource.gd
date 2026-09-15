class_name AmplitudeResource
extends Resource

@export var amplitudes : PackedFloat32Array

func append(value: float) -> void:
	amplitudes.append(value)
