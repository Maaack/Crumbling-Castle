@tool
class_name Floor
extends CollisionShape2D

@export var character: String = "="
@export var width: int:
	set(v):
		if _resetting:
			width = v
			_resetting = false
			return
		width = v
		if is_node_ready():
			_update_width()

@export_tool_button("Clear floor") var reset_floor = _on_reset_floor_pressed

var _resetting: bool = false

@onready var label: Label = $Label
@onready var grinder_fx: GPUParticles2D = $GrinderFx


func _ready() -> void:
	label.visible_ratio = .999
	_update_width.call_deferred()


func destroy() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(label, "modulate", Color.TRANSPARENT, 0.5)

	grinder_fx.amount_ratio = remap(width, 0, 2560, 0, 1)
	grinder_fx.emitting = true
	# disable collision
	set_deferred("disabled", true)


func _update_width() -> void:
	# get_node to work at tool time
	var _label = get_node("Label")
	while _label.get_minimum_size().x > width:
		_label.text = _label.text.trim_suffix(character)
		await get_tree().process_frame  ## allow time for resize calc
		#await get_tree().process_frame  ## no, really really allow time
	while _label.get_minimum_size().x < width:
		_label.text += character
		await get_tree().process_frame  ## allow time for resize calc
		#await get_tree().process_frame  ## no, really really allow time
	shape.a.x = -width / 2.0
	shape.b.x = width / 2.0
	# label doesn't resize and reposition on its own
	label.size.x = label.get_minimum_size().x
	label.position.x = -label.size.x / 2.0
	grinder_fx.process_material.emission_box_extents.x = width / 2.0


func _on_reset_floor_pressed() -> void:
	_resetting = true
	get_node("Label").text = ""
	character = "="
	width = 0
