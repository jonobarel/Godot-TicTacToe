extends OptionButton

class_name AISelector

var ai_options = ["random", "hack", "heuristic", "minimax"]

func _ready():
	for i in  range(ai_options.size()):
		add_item(ai_options[i], i)
	select(3)
