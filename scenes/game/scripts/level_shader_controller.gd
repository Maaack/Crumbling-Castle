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
	if level_loader.current_level_path.contains("level_0.tscn") or level_loader.current_level_path.contains("level_2.tscn"):
		shader_material.set_shader_parameter(&"opacity", 0.0)
		shader_material.set_shader_parameter(&"original_opacity_mod", 0.95)
		if level_loader.current_level.has_signal(&"trip_started"):
			level_loader.current_level.connect(&"trip_started", _on_trip_started)
	else:
		shader_material.set_shader_parameter(&"opacity", 0.75)
		shader_material.set_shader_parameter(&"original_opacity_mod", 0.666)

func _on_trip_started() -> void:
	var tween = create_tween()
	tween.tween_method(_update_shader_parameter.bind(&"opacity"), 0.0, 0.75, 12.0)
