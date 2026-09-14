extends "level.gd"
@export var doom_speed = 20.0
@onready var lose_area_2d = %LoseArea2D

func _on_lose_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group(&"player"):
		level_lost.emit()

func _on_win_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group(&"player"):
		level_won.emit(next_level_path)

func _process(delta):
	lose_area_2d.position.y -= delta * doom_speed
