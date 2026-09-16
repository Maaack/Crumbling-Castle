extends GPUParticles2D

# How it works: find the collider and copy its shape to the particle emission shape
# On collision, one-shot emit and hide the label / visual

@export var lose_area: Area2D

var ppm: ParticleProcessMaterial

func _ready() -> void:
	if lose_area:
		lose_area.body_shape_entered.connect(_on_lose_area_body_shape_entered, CONNECT_DEFERRED)
	else:
		push_warning("LoseBody Area2D not set in " + name)
	ppm = process_material
	one_shot = true


func _on_lose_area_body_shape_entered(_body_rid: RID, body: Node2D, body_shape_index: int, _local_shape_index: int) -> void:
	var body_shape_owner = body.shape_find_owner(body_shape_index)
	var body_shape_node: CollisionShape2D = body.shape_owner_get_owner(body_shape_owner)

	# only works for floors atm, need a convention or interface for the colliders & their visuals
	var labels: Array[Node] = body_shape_node.find_children("*", "Label")

	var rect: Rect2
	if body_shape_node.shape is RectangleShape2D \
		and "Wall" in body_shape_node.name \
		and body_shape_node.has_method("destroy_bottom_row"):
			print("call wall destroy_bottom_row")
			body_shape_node.destroy_bottom_row()


	if body_shape_node.shape is SegmentShape2D:
		if "Floor" not in body_shape_node.name:
			return

		var shape: SegmentShape2D = body_shape_node.shape
		var _position: Vector2 = shape.a + body_shape_node.global_position
		var _size: Vector2 = Vector2(max(8, shape.b.x - shape.a.x), max(8, shape.b.y - shape.a.y))
		rect = Rect2(_position, _size)
		#prints("collider rect: ", rect)

		# If we want to limit particles to visible rect, this basically works--but need to grow rect
		# by player velocity or the edge shows when they move
		#var inv_xform: Transform2D = get_viewport().get_canvas_transform().affine_inverse()
		#var global_vp_rect: Rect2 = inv_xform * get_viewport().get_visible_rect()
		#rect = rect.intersection(global_vp_rect)

		global_position = rect.get_center()
		ppm.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_BOX
		ppm.emission_box_extents = Vector3(rect.size.x / 2.0, rect.size.y / 2.0, 0)
		# Maybe we can set the visibility rect every collision, but I found it works most reliably
		# when it just covers the whole map
		#visibility_rect = rect

		emitting = true
		body_shape_node.disabled = true

		var tween: Tween = create_tween()
		for label: Label in labels:
			tween.tween_property(label, "modulate", Color.TRANSPARENT, 0.5)
