extends "level.gd"
@export var doom_speed = 20.0

@onready var step = %Step
@onready var step_2 = %Step2
@onready var step_3 = %Step3
@onready var step_4 = %Step4
@onready var step_5 = %Step5
@onready var step_6 = %Step6
@onready var step_7 = %Step7
@onready var step_8 = %Step8
@onready var step_9 = %Step9
@onready var step_10 = %Step10
@onready var step_11 = %Step11
@onready var step_12 = %Step12
@onready var step_13 = %Step13
@onready var step_14 = %Step14

@onready var all_containers : Array[Node] = [
	step,
	step_2,
	step_3,
	step_4,
	step_5,
	step_6,
	step_7,
	step_8,
	step_9,
	step_10,
	step_11,
	step_12,
	step_13,
	step_14,
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
	step_8,
	step_2,
	step_3,
	step_3,
	step_9,
	step_5,
	step_5,
	step_6,
	step_2,
	step_3,
	step_10,
	step_11,
	step_4,
	step_5,
	step_5,
	step_6,
	step_2,
	step_12,
	step_11,
	step_12,
	step_11,
	step_4,
	step_5,
	step_5,
]

var current_step = 0
var current_container : Node
var level_over : bool = false
var window_path : bool = false
var current_height : int = 0
var current_doom_height : int = -20

func _recursive_calls(node: Node) -> void:
	_connect_button_signals(node)
	for child in node.get_children():
		_recursive_calls(child)

func _connect_button_signals(node: Node) -> void:
	if node is Button:
		if node.name.contains("Crumble"):
			node.pressed.connect(_on_crumble_button_pressed)
			return
		if node.name.contains("WindowPath"):
			node.pressed.connect(_on_window_path_button_pressed)
		node.pressed.connect(_on_progress_button_pressed)

func _check_path_for_container() -> void:
	var first_child := current_container.get_child(0)
	if first_child.name.contains("DefaultPath"):
		if window_path:
			first_child.hide()
			current_container.get_child(1).show()
		
func _refresh_current_step_container() -> void:
	if current_container:
		current_container.hide()
	if current_step >= step_order.size():
		level_over = true
		level_won.emit()
		return
	current_container = step_order[current_step]
	current_container.show()
	_check_path_for_container()

func _on_progress_button_pressed() -> void:
	if level_over: return
	current_step += 1
	_refresh_current_step_container()

func _on_crumble_button_pressed() -> void:
	if level_over: return
	level_over = true
	current_container.show()
	level_lost.emit()

func _on_window_path_button_pressed() -> void:
	window_path = true

func _ready():
	for container in all_containers:
		container.hide()
		_recursive_calls(container)
	_refresh_current_step_container()
