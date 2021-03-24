extends Node

class_name GameBoard

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var grid = []

func _init():
	board_init()

func _ready():
	pass
	

func board_clear():
	for i in range(9):
		grid[i] = "_"
		getPosition(i).hide()

func getPosition(i : int) -> Node:
	return get_node("Pos%s" % i)

func play(pos: int, p: String):
	if pos in range(9) and grid[pos] == "_":
		grid[pos] = p
		getPosition(pos).show_move(p)

func board_init():
	print("Board initiatlised")
	for _i in range(9):
		grid.append('_')
		
func get_available_moves() -> Array:
	var ret = []
	for i in range(grid.size()):
		if grid[i] == '_':
			ret.append(i)
	return ret

func get_board():
	return grid.duplicate()

func show_board():
	var s = ""
	
	for i in range(3):
		var pos = i*3
		s+=grid[pos]+grid[pos+1]+grid[pos+2]+"\n"
		
	return s

func get_winner() -> String:
	return _get_winner(grid)

func _get_winner(g: Array) -> String:
	# row
	for i in [0,3,6]:
		if (g[i] != '_' and g[i] == g[i+1] and g[i] == g[i+2]):
			return g[i]
	
	# column
	for i in range(3):
		if (g[i] != '_' and g[i]== g[i+3] and g[i] == g[i+6]):
			return g[i]

	# diagonals
	if (g[4] != '_' and
		((g[0] == g[4] and g[0] == g[8]) 
		or (g[2] == g[4] and g[0] == g[6]))
		):
		return g[4]
	
	return "" #empty string means no winner - check for ties by no-winner and no more available moves
