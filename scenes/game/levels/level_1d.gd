extends "level.gd"

@export var doom_speed = 20.0
@export var player_speed = 20.0

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
@onready var step_15 = %Step15
@onready var step_16 = %Step16
@onready var step_17 = %Step17
@onready var step_18 = %Step18
@onready var step_19 = %Step19
@onready var gate_situation_label = %GateSituationLabel
@onready var raise_button = %RaiseButton
@onready var gate_opening_button = %GateOpeningButton
@onready var step_20 = %Step20
@onready var step_21 = %Step21
@onready var final_button = %FinalButton
@onready var final_crumble_button = %FinalCrumbleButton
@onready var portal_margin_container = %PortalMarginContainer
@onready var portal_button = %PortalButton
@onready var portal_situation_label = %PortalSituationLabel
@onready var death_texture_rect = %DeathTextureRect
@onready var player_texture_rect = %PlayerTextureRect
@onready var progress_label = %ProgressLabel

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
	step_15,
	step_16,
	step_17,
	step_18,
	step_19,
	step_20,
	step_21,
]
@onready var step_order : Array[Node] = [
	step,
	step_2,
	step_3,
	step_4,
	step_5,
	step_5,
	step_6,
	step_2,
	step_3,
	step_4,
	step_5,
	step_5,
	step_7,
	step_2,
	step_3,
	step_4,
	step_5,
	step_5,
	step_6,
	step_2,
	step_3,
	step_4,
	step_5,
	step_5,
	step_8,
	step_2,
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
	step_6,
	step_13,
	step_14,
	step_13,
	step_14,
	step_10,
	step_11,
	step_4,
	step_5,
	step_5,
	step_6,
	step_2,
	step_3,
	step_3,
	step_3,
	step_3,
	step_3,
	step_4,
	step_5,
	step_5,
	step_6,
	step_2,
	step_15,
	step_16,
	step_17,
	step_18,
	step_19,
	step_20,
	step_3,
	step_4,
	step_5,
	step_5,
	step_5,
	step_5,
	step_21,
]

var current_step = 0
var current_container : Node
var level_over : bool = false
var window_path : bool = false
var gate_height : int = -1
var portal_attempts : int = 0
var reached_portal : bool = false

func _recursive_calls(node: Node) -> void:
	_connect_button_signals(node)
	for child in node.get_children():
		_recursive_calls(child)

func _connect_button_signals(node: Node) -> void:
	if node is Button:
		if node.name.contains("Crumble"):
			node.pressed.connect(_on_crumble_button_pressed)
			return
		if node.name.contains("Raise"):
			node.pressed.connect(_on_raise_button_pressed)
			return
		if node.name.contains("Portal"):
			node.pressed.connect(_on_portal_button_pressed)
			return
		if node.name.contains("WindowPath"):
			node.pressed.connect(_on_window_path_button_pressed)
		if node.name.contains("Ascend"):
			node.pressed.connect(_on_ascend_button_pressed)
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
		GameState.get_or_create_state().has_crumbled = true
		GlobalState.save()
		level_won.emit()
		return
	current_container = step_order[current_step]
	current_container.show()
	_check_path_for_container()

func _on_progress_button_pressed() -> void:
	if level_over: return
	current_step += 1
	_refresh_current_step_container()
	_check_for_checkpoints()

func _on_ascend_button_pressed() -> void:
	if level_over: return
	player_texture_rect.position.x += player_speed

func lose() -> void:
	if level_over: return
	level_over = true
	level_state.deaths += 1
	GlobalState.save()
	level_lost.emit()

func _on_crumble_button_pressed() -> void:
	lose()

func _on_raise_button_pressed() -> void:
	if level_over: return
	gate_height += 1
	if gate_height < 1:
		raise_button.text = "Lift"
		return
	gate_opening_button.custom_minimum_size.y += 5
	if gate_height >= 90:
		gate_situation_label.text = ""
	elif gate_height >= 80:
		gate_situation_label.text = "You can pass under the gate."
		gate_opening_button.text = "Go under"
		gate_opening_button.disabled = false
	elif gate_height >= 64:
		gate_situation_label.text = "You can almost pass under the gate."
		gate_opening_button.text = "Almost there"
	elif gate_height >= 16:
		gate_situation_label.text = "If you get on your knees now,\nyou might not get back up."
		gate_opening_button.text = "Still can't fit"

func _on_window_path_button_pressed() -> void:
	window_path = true

func _check_for_checkpoints() -> void:
	if current_step >= 57:
		level_state.checkpoints = 3
	elif current_step >= 38:
		level_state.checkpoints = 2
	elif current_step >= 24:
		level_state.checkpoints = 1
	GlobalState.save()

func _ready():
	super._ready()
	for container in all_containers:
		container.hide()
		_recursive_calls(container)
	if level_state.checkpoints == 1:
		current_step = 24
		player_texture_rect.position.x += player_speed * 12
	elif level_state.checkpoints == 2:
		current_step = 38
		player_texture_rect.position.x += player_speed * 18
	elif level_state.checkpoints == 3:
		current_step = 57
		player_texture_rect.position.x += player_speed * 24
	_refresh_current_step_container()

func _on_portal_button_pressed():
	if level_over: return
	portal_attempts += 1
	if portal_attempts >= 64:
		portal_button.text = "There is only down."
		portal_button.disabled = true
		final_crumble_button.hide()
		final_button.show()
		return
	elif portal_attempts >= 56:
		portal_button.text = "Ascend!!!!!!!"
	elif portal_attempts >= 44:
		portal_button.text = "Ascend!!!"
	elif portal_attempts >= 32:
		portal_button.text = "Ascend!!"
	elif portal_attempts >= 8:
		portal_button.text = "Ascend?!"
	elif portal_attempts >= 3:
		reached_portal = true
		portal_button.flat = false
		portal_situation_label.hide()
		progress_label.hide()
		final_crumble_button.show()
	elif portal_attempts >= 2:
		portal_button.text = "Ascend?"
	if portal_attempts >= 5:
		portal_margin_container.add_theme_constant_override("margin_top", portal_attempts * 5)
		portal_margin_container.add_theme_constant_override("margin_bottom", portal_attempts * 5)
		portal_margin_container.add_theme_constant_override("margin_left", portal_attempts * 7)
		portal_margin_container.add_theme_constant_override("margin_right", portal_attempts * 7)

func _process(delta):
	if level_over or reached_portal:
		return
	death_texture_rect.position.x += doom_speed * delta
	if death_texture_rect.position.x + 10 > player_texture_rect.position.x:
		lose()
	
