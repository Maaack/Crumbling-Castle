extends Node3D

@export var base_mouse_sensitivity : float = 0.001
@export var base_joypad_sensitivity : float = 0.001
@export var joypad_yaw_sensitivity : float = 1250
@export var joypad_pitch_sensitivity : float = 25

@export_node_path("CharacterBody3D") var character_body_node_path : NodePath = ^".."
@export_node_path("Camera3D") var camera_3d_node_path : NodePath = ^".."

@onready var character_body : CharacterBody3D = get_node_or_null(character_body_node_path)
@onready var camera_3d : CharacterBody3D = get_node_or_null(camera_3d_node_path)

var _yaw_rate : float = 0.0
var _pitch_rate : float = 0.0

func _input(event):
	if event is InputEventMouseMotion:
		var mouse_sensitivity = PlayerConfig.get_config(AppSettings.INPUT_SECTION, &"MouseSensitivity", 1.0)
		mouse_sensitivity *= base_mouse_sensitivity
		character_body.rotation.y -= event.relative.x * mouse_sensitivity
		var _new_camera_rotation = camera_3d.rotation.x - (event.relative.y * mouse_sensitivity)
		camera_3d.rotation.x = clamp(_new_camera_rotation, -0.9, 0.9)

	if event is InputEventJoypadMotion:
		var joypad_sensitivity = PlayerConfig.get_config(AppSettings.INPUT_SECTION, &"JoypadSensitivity", 1.0)
		joypad_sensitivity *= base_joypad_sensitivity
		if event.axis == JoyAxis.JOY_AXIS_RIGHT_X:
			_yaw_rate = event.axis_value * joypad_sensitivity * joypad_yaw_sensitivity
		elif event.axis == JoyAxis.JOY_AXIS_RIGHT_Y:
			_pitch_rate = event.axis_value * joypad_sensitivity * joypad_pitch_sensitivity

func _process(delta):
	character_body.rotation.y -= _yaw_rate * delta
	var _new_camera_rotation = camera_3d.rotation.x - _pitch_rate
	camera_3d.rotation.x = clamp(_new_camera_rotation, -0.9, 0.9)
