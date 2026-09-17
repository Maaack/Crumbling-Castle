@tool
class_name Wall
extends CollisionShape2D

@export var character_row: String = "||"
@export var height: int:
	set(v):
		if _resetting:
			height = v
			_resetting = false
			return
		height = v
		if is_node_ready():
			_update_height()

@export_tool_button("Clear wall") var reset_wall = _on_reset_wall_pressed

var _top: float
var _grinder_pool: Array
var _grinder_index: int = 0
var _resetting: bool = false

@onready var label: Label = $Label


func _ready() -> void:
	label.visible_ratio = .999
	_top = position.y - shape.size.y / 2.0
	_grinder_pool = find_children("GrinderFx*", "GPUParticles2D")
	_update_height.call_deferred()


func _process(_delta: float) -> void:
	pass
	shape.size.y = label.get_minimum_size().y
	# label doesn't reposition on its own
	label.position.y = -shape.size.y / 2.0


func destroy_bottom_row() -> void:
	# Looks better to wait a bit, but I was too lazy to adjust the collider
	# but it causes the collider to sometimes not resize fast enough
	#await get_tree().create_timer(0.5).timeout
	var label_height = label.get_minimum_size().y

	# emit first to help hide the label shrinking
	var grinder: GPUParticles2D = _grinder_pool[_grinder_index]
	_grinder_index = wrapi(_grinder_index + 1, 0, _grinder_pool.size())
	# position effect y center
	grinder.position.y = (label_height - 20) / 2.0
	grinder.emitting = true

	# remove chars
	while label.get_minimum_size().y == label_height:
		label.visible_characters -= 1
		# print(label.visible_characters)
		_resize_reposition.call_deferred()
		await get_tree().process_frame  ## allow time for resize calc
		# prints("old height", label_height, "new height", label.get_minimum_size().y)


func _resize_reposition() -> void:
	shape.size.y = label.get_minimum_size().y

	# reposition so new top matches original _top
	position.y = _top + shape.size.y / 2.0
	# label doesn't reposition on its own
	label.position.y = -shape.size.y / 2.0


func _update_height() -> void:
	# get_node to work at tool time
	var _label = get_node("Label")
	while shape.size.y > height:
		_label.text = _label.text.trim_suffix("\n" + character_row)
		await get_tree().process_frame  ## allow time for resize calc
		#await get_tree().process_frame  ## no, really really allow time
	while shape.size.y < height:
		if _label.text == "":
			_label.text += character_row
		else:
			_label.text += "\n" + character_row
		await get_tree().process_frame  ## allow time for resize calc
		#await get_tree().process_frame  ## no, really really allow time


func _on_reset_wall_pressed() -> void:
	_resetting = true
	get_node("Label").text = ""
	character_row = "||"
	height = 0
