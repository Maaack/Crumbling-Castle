@tool
extends Node

@export var level_loader : LevelLoader
@export var canvas : CanvasItem
@export var mod_parameters : Array[StringName]
@export var mod_amount : float = 0.0

var parameter_defaults : Dictionary[StringName, Variant]
var shader_material : ShaderMaterial

func _ready() -> void:
	shader_material = canvas.material
	for mod_parameter in mod_parameters:
		parameter_defaults[mod_parameter] = shader_material.get_shader_parameter(mod_parameter)
	level_loader.level_loaded.connect(_on_level_loaded)

func _update_shader_parameter(value : Variant, key : StringName) -> void:
	shader_material.set_shader_parameter(key, value)

func _on_level_loaded() -> void:
	if level_loader.current_level_path.contains("level_0"):
		shader_material.set_shader_parameter(&"original_opacity_mod", 0.95)
	else:
		shader_material.set_shader_parameter(&"original_opacity_mod", 0.666)
