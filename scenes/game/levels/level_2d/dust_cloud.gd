extends Node2D

# Why is there a random light occluder 2d you might ask?
# https://github.com/godotengine/godot/issues/112926


@onready var poof_right: GPUParticles2D = $PoofRight
@onready var poof_left: GPUParticles2D = $PoofLeft


func _ready() -> void:
	poof_right.one_shot = true
	poof_left.one_shot = true


func emit() -> void:
	poof_right.emitting = true
	poof_left.emitting = true
