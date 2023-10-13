extends Area3D

func _on_body_entered(body):
	get_tree().call_group("node_3d", "update_body_target", body)

func _on_timer_timeout():
	queue_free()

func _on_area_entered(area):
	get_tree().call_group("node_3d", "update_movable_body_target", area.get_parent())
