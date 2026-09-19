@tool
extends Node

@export var level_loader : LevelLoader
@export var canvas : CanvasItem

var parameter_defaults : Dictionary[StringName, Variant]
var shader_material : ShaderMaterial

func _ready() -> void:
	shader_material = canvas.material
	level_loader.level_loaded.connect(_on_level_loaded)

func _update_shader_parameter(value : Variant, key : StringName) -> void:
	shader_material.set_shader_parameter(key, value)

func _on_level_loaded() -> void:
	var level_filename = ResourceUID.ensure_path(level_loader.current_level_path)
	level_filename = level_filename.get_file().get_basename()
	match level_filename:
		"level_0", "level_2", "level_4", "level_6":
			shader_material.set_shader_parameter(&"original_opacity_mod", 0.95)
			match level_filename:
				"level_0":
					shader_material.set_shader_parameter(&"opacity", 0.0)
					level_loader.current_level.connect(&"trip_started", _on_trip_started)
				"level_2":
					shader_material.set_shader_parameter(&"opacity", 0.65)
					shader_material.set_shader_parameter(&"layers", 12)
					level_loader.current_level.connect(&"trip_escalated", _on_trip_escalated.bind(1))
				"level_4":
					shader_material.set_shader_parameter(&"opacity", 0.65)
					shader_material.set_shader_parameter(&"layers", 16)
					level_loader.current_level.connect(&"trip_escalated", _on_trip_escalated.bind(2))
				"level_6":
					shader_material.set_shader_parameter(&"opacity", 0.7)
					shader_material.set_shader_parameter(&"layers", 20)
					level_loader.current_level.connect(&"trip_escalated", _on_trip_escalated.bind(3))
		_:
			shader_material.set_shader_parameter(&"layers", 6)
			shader_material.set_shader_parameter(&"opacity", 0.75)
			match level_filename:
				"level_1_3d":
					shader_material.set_shader_parameter(&"original_opacity_mod", 0.875)
				_:
					shader_material.set_shader_parameter(&"original_opacity_mod", 0.666)

func _on_trip_started() -> void:
	var tween = create_tween()
	tween.tween_method(_update_shader_parameter.bind(&"opacity"), 0.0, 0.75, 12.0)

func _on_trip_escalated(level : int = 0) -> void:
	var tween = create_tween()
	match level:
		1:
			tween.tween_method(_update_shader_parameter.bind(&"opacity"), 0.65, 0.8, 4.0)
		2:
			tween.tween_method(_update_shader_parameter.bind(&"opacity"), 0.65, 0.8, 4.0)
		3:
			tween.tween_method(_update_shader_parameter.bind(&"opacity"), 0.7, 0.875, 4.0)
