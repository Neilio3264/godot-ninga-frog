extends HBoxContainer


func _on_ninja_frog_health_depleted(value):
	for i in get_child_count():
		get_child(i).visible = value > i
