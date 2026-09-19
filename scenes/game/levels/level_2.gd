extends "level_dialogue.gd"

signal trip_escalated

func trip_harder() -> void:
	trip_escalated.emit()
