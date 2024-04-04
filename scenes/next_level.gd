extends Area2D

const FILE_BEGIN = "res://levels/level_"

func _on_platform_area_entered(area):
	if area.get_parent() is Player:
		var current_scene_file = get_tree().current_scene.scene_file_path
		var next_level_number = current_scene_file.to_int() + 1
		
		var next_level_path = FILE_BEGIN + str(next_level_number) + ".tscn"
		get_tree().change_scene_to_file(next_level_path)
