extends "res://addons/maaacks_game_template/base/nodes/opening/opening.gd"

@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var hiding_things: ColorRect = $HidingThings
@onready var flooring: Floor = $CanvasLayer/Floor
@onready var debris: GPUParticles2D = $CanvasLayer/Debris
@onready var dust_cloud: Node2D = $CanvasLayer/DustCloud



func _ready() -> void:
	hiding_things.color = ProjectSettings.get("rendering/environment/defaults/default_clear_color")
	canvas_layer.layer = RenderingServer.CANVAS_LAYER_MIN
	super()
	_cache_particles.call_deferred()

func _cache_particles() -> void:
	flooring.visible = true
	flooring.destroy()
	debris.visible = true
	debris.emitting = true
	dust_cloud.visible = true
	dust_cloud.emit()
