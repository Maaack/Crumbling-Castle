class_name StairStep
extends StaticBody2D

@onready var label: Label = $Label
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var grinder_fx: GPUParticles2D = $GrinderFx


func destroy_bottom_row() -> void:
	grinder_fx.emitting = true
	collision_shape_2d.set_deferred("disabled", true)

	var tween: Tween = create_tween()
	tween.tween_property(label, "modulate", Color.TRANSPARENT, 1.0)
	tween.tween_interval(grinder_fx.lifetime - 1.0)
	tween.tween_callback(queue_free)
