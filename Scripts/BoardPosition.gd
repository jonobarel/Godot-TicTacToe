extends Sprite

class_name BoardPosition

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _onready():
	pass

func show_move(move : String):
	if move.to_lower() in ["x", "o"]:
		get_node(move.to_lower()).visible = true

func hide():
	$x.visible = false
	$o.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
