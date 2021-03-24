extends Button


func _pressed():
	print("new game?")
	get_tree().reload_current_scene()

