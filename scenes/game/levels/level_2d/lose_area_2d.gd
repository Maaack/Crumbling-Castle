extends Area2D


func _on_body_shape_entered(_body_rid: RID, body: Node2D, body_shape_index: int, _local_shape_index: int) -> void:
	var body_shape_owner = body.shape_find_owner(body_shape_index)
	var body_shape_node: CollisionShape2D = body.shape_owner_get_owner(body_shape_owner)

	#prints("body shape node", body_shape_node.name)

	if body_shape_node is Wall:
		body_shape_node.destroy_bottom_row()

	if body_shape_node.get_parent() is StairStep:
		body_shape_node.get_parent().destroy_bottom_row()

	if body_shape_node is Floor:
		body_shape_node.destroy()
