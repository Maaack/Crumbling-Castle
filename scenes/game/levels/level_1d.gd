extends "level.gd"
@export var doom_speed = 20.0

@onready var step = %Step
@onready var step_2 = %Step2
@onready var step_3 = %Step3
@onready var step_4 = %Step4
@onready var step_5 = %Step5
@onready var step_6 = %Step6
@onready var step_7 = %Step7

@onready var all_containers : Array[Node] = [
	step,
	step_2,
	step_3,
	step_4,
	step_5,
	step_6,
	step_7,
]
@onready var step_order : Array[Node] = [
	step,
	step_2,
	step_3,
	step_3,
	step_4,
	step_5,
	step_5,
	step_6,
	step_2,
	step_3,
	step_3,
	step_4,
	step_5,
	step_5,
	step_7,
	step_2,
	step_3,
	step_3,
	step_4,
	step_5,
	step_5,
	step_6,
	step_2,
	step_3,
	step_3,
	step_4,
	step_5,
	step_5,
	step_7,
]

var current_step = 0
var current_container : Node
var level_over : bool = false

func _recursive_calls(node: Node) -> void:
	_connect_button_signals(node)
	for child in node.get_children():
		_recursive_calls(child)

func _connect_button_signals(node: Node) -> void:
	if node is Button:
		if node.name.contains("Crumble"):
			return
		node.pressed.connect(_on_progress_button_pressed)

func _refresh_current_step_container() -> void:
	if current_container:
		current_container.hide()
	if current_step >= step_order.size():
		level_over = true
		level_won.emit()
		return
	current_container = step_order[current_step]
	current_container.show()

func _on_progress_button_pressed() -> void:
	if level_over: return
	current_step += 1
	_refresh_current_step_container()

func _ready():
	for container in all_containers:
		container.hide()
		_recursive_calls(container)
	_refresh_current_step_container()
