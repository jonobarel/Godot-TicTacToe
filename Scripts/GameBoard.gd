extends Node

class_name GameBoard

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var grid = []
var game_over = false
var is_virtual : bool = false

const WINNING_MOVES = [
	[0,1,2],
	[0,3,6],
	[0,4,8],
	[1,4,7],
	[2,5,8],
	[3,4,5],
	[6,7,8],
	[2,4,6]
]

#func _init(new_grid : Array = []):
#	if new_grid.empty():
#		board_init()
#	else:
#		grid = new_grid.duplicate()
#		grid = get_available_moves().empty() or get_winner() != ""

func _init(other : GameBoard = null):
	if other == null:
		board_init()
	else:
		grid = other.grid.duplicate()
		game_over = other.game_over
		is_virtual = true
	

func board_clear():
	for i in range(9):
		grid[i] = "_"
		if not is_virtual:
			getPosition(i).hide() 

func getPosition(i : int) -> Node:
	return get_node("Pos%s" % i)

func play(pos: int, p: String):
	if pos in range(9) and grid[pos] == "_":
		grid[pos] = p
		if not is_virtual:
			getPosition(pos).show_move(p) 
		if get_available_moves().size() == 0 or get_winner() != "":
			game_over = true
			

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
	if g[4] != '_' and (
			(g[0] == g[4] and g[4] == g[8]) 
			or (g[2] == g[4] and g[4] == g[6])
		):
		return g[4]
	
	return "" #empty string means no winner - check for ties by no-winner and no more available moves

#does this move win the game?
func test_winning_move(i : int, p : String)-> bool:
	for m in WINNING_MOVES:
		if i in m:
			var m_copy = m.duplicate()
			m_copy.erase(i)
			if grid[m_copy[0]]==grid[m_copy[1]] and grid[m_copy[0]] == p:
				return true
	return false
