extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var grid = []
var playerTurn = true
var gameOver = false

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	board_init()
	print(show_board())
	
	
func board_init():
	for _i in range(9):
		grid.append('_')
		
	
func show_board():
	var s = ""
	
	for i in range(3):
		var pos = i*3
		s+=grid[pos]+grid[pos+1]+grid[pos+2]+"\n"
		
	return s

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if (gameOver):
		return
	if not playerTurn:
		ai_move()

	
func _input(event):
	if (playerTurn):
		if event is InputEventKey and event.pressed and int(event.as_text()) in range(10):
		#	print("number %s pressed" % event.as_text())
			handle_move(int(event.as_text()))
			
func handle_move(i):
	if (grid[i-1] == '_'):
		grid[i-1] = 'X'
		if (is_game_over()):
			print("human wins")
			gameOver = true
		elif (is_full_board()):
			print("game over - tie")
			gameOver = true
		print(show_board())
		playerTurn = false

func ai_move():
	var i = find_free_space()
	if (i > -1):
		grid[i] = 'O'
		print('computer chooses %s' % i)
		print(show_board())
		if is_game_over():
			print('Computer wins')
			gameOver = true
		playerTurn = true
	else:
		print('error, could not find free space')
		gameOver = true

func find_free_space():
	var ret
	var i = 0
	while (i < 20):
		i+=1
		ret = randi() % 9
		if grid[ret] == '_':
			return ret
	return -1

func is_full_board():
	return not grid.has('_') 
	# return not '_' in grid

func is_game_over():
	# row
	for i in [0,3,6]:
		if (grid[i] != '_' and grid[i] == grid[i+1] and grid[i] == grid[i+2]):
			return true
	
	# column
	for i in range(3):
		if (grid[i] != '_' and grid[i]== grid[i+3] and grid[i] == grid[i+6]):
			return true

	# diagonals
	if (grid[4] != '_' and
		((grid[0] == grid[4] and grid[0] == grid[8]) 
		or (grid[2] == grid[4] and grid[0] == grid[6]))
		):
		return true
	
	return false
