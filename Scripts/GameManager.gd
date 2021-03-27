extends Node

var board : GameBoard
var players = [] # holds references to the players in order to get moves from them.
var last_symbol = ""
var human_player_turn = true
var single = 0
var ai_mode = "hack" # "hack", "heuristic", "minimax"
var game_over = false

onready var ai_selector : AISelector = $"../UI/AISelector"
onready var textbox  = $"../UI/GameResult" 
onready var chat : BotChat = $"../UI/BotChat"

# Called when the node enters the scene tree for the first time.
func _ready():
	board = $GameBoard
	#print(board.show_board())

func _input(event):
	if event is InputEventKey and event.pressed:
		if (human_player_turn):
			var pos = int(event.as_text())-1
			if pos in board.get_available_moves():
				print("human player chose %s " % event.as_text())
				# board.play(int(event.as_text()),)
				board.play(pos, "x")
				print(board.show_board())
				human_player_turn = false
			else:
				print("trying to choose occcupied spot %s" % pos)


func _process(delta):
	if board.game_over:
		
		var winner = board.get_winner()
		if winner in ["x", "o"]:
			textbox.set_bbcode("[center]The winner is %s![/center]" % winner.to_upper())
		else:
			textbox.set_bbcode("[center]It's a tie![/center]")
		textbox.visible = true
		
	elif not human_player_turn:
		var pos = get_ai_move()
		board.play(pos, "o")
		human_player_turn = true
		
func get_ai_move() -> int:
	ai_mode = ai_selector.get_item_text(ai_selector.get_selected_id())
	print("Choosing by method: %s" % ai_mode)
	match ai_mode.to_lower():
		"random":
			return get_random_move()
		"hack":
			return get_hack_move()
		"heuristic":
			return get_heuristic_move()
			
	return -1


func get_hack_move():
	# option one: find a winning move
	chat.chat_message("Looking for a winning move.")
	var i = find_winning_move("o")
	if i >= 0:
		return i
	# otherwise, try to block the opponent
	chat.chat_message("No winning move - checking for a block")
	i = find_blocking_move("o")
	if i >= 0:
		return i
	# otherwise, just go for a random move
	return get_random_move()

func get_random_move():
	chat.chat_message("choosing a random move")
	var moves = board.get_available_moves()
	if moves.size() > 0:
		return moves[randi() % moves.size()]
	return -1

func find_winning_move(p : String):
	var moves = board.get_available_moves()
	for i in moves:
		if board.test_winning_move(i, p):
			return i
	return -1

# finding a blocking move is just equivalent to identifying a winning move for your opponent
func find_blocking_move(p : String):
	var t = "o" if p == "x" else "x"
	return find_winning_move(t)

func get_heuristic_move():
	var avm = board.get_available_moves()
	chat.chat_message("Looking for a winning move.")
	var i = find_winning_move("o")
	if i >= 0:
		return i
	# otherwise, try to block the opponent
	chat.chat_message("Looking for a block")
	i = find_blocking_move("o")
	if i >= 0:
		return i
	chat.chat_message("going for center")
	if 4 in avm:
		return 4
	chat.chat_message("going for diagonals")
	if 0 in avm:
		return 0
	elif 2 in avm:
		return 2
	elif 6 in avm:
		return 6
	elif 8 in avm:
		return 8
	
	return get_random_move()
	
func minimax(game_state : Array, depth : int, maximizingPlayer : String):
	var board = GameBoard.new(game_state)
	if depth == 0:
		if board.get_winner() == maximizingPlayer
	 
	

#function minimax(node, depth, maximizingPlayer) is
#    if depth = 0 or node is a terminal node then
#        return the heuristic value of node
#    if maximizingPlayer then
#        value := −∞
#        for each child of node do
#            value := max(value, minimax(child, depth − 1, FALSE))
#        return value
#    else (* minimizing player *)
#        value := +∞
#        for each child of node do
#            value := min(value, minimax(child, depth − 1, TRUE))
#        return value
