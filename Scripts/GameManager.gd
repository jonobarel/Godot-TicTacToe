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
		"minimax":
			return get_minimax_move()
			
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
	
func get_minimax_move():
	var value = -9999
	var chosen_move = null
	chat.chat_message("Going to test the following moves: %s" % String(board.get_available_moves()))
#	for i in board.get_available_moves():
#		var test_board = GameBoard.new(board)
#		test_board.play(i, "o")
#		var v = minimax(test_board, 0, false, "o", "x")
#		chat.chat_message("The value of playing %s is %s" % [i, v])
#		if v > value:
#			value = v
#			chosen_move = i
	var test_board = GameBoard.new(board)
	
	var best = minimax(test_board, 9, true, "o", "x")
	chat.chat_message("All things considered, my best move is %s with value %s" % [best[0], best[1]])
	return best[0]
	
func minimax(game_state : GameBoard, depth: int, maximizing_player : bool, target_player : String, opposing_player : String):
	var winner = game_state.get_winner()
	# print("%s %s" % [_multi_string(" ", 10-depth), game_state.grid])
	
#function minimax(node, depth, maximizingPlayer) is
#    if depth = 0 or node is a terminal node then
#        return the heuristic value of node

	if depth == 0 or game_state.game_over:
		match winner:
			target_player:
				return [-1,10]
			"": #tie
				return [-1,0]
			opposing_player:  #Opponent
				return [-1,-10]
		
	
	
#    if maximizingPlayer then
#        value := −∞
#        for each child of node do
#            value := max(value, minimax(child, depth − 1, FALSE))
#        return value
	var moves = game_state.get_available_moves()
	var value = -999
	var best = [-1, value]
	if maximizing_player:
		for i in moves:
			var new_state : GameBoard = GameBoard.new(game_state)
			new_state.play(i, target_player)
			var score = minimax(new_state, depth-1, false, target_player, opposing_player)
			if score[1] > best[1]:
				best = [i,score[1]]
		return best

#    else (* minimizing player *)
#        value := +∞
#        for each child of node do
#            value := min(value, minimax(child, depth − 1, TRUE))
#        return value


	else: # minimizing player	
		value = 999
		best = [-1, value]
		for i in moves:
			var new_state = GameBoard.new(game_state)
			new_state.play(i,opposing_player)
			var score = minimax(new_state, depth-1,  true, target_player, opposing_player)
			if score[1] < best[1]:
				best = [i,score[1]]
		return best





func _multi_string(s : String, rep : int):
	var ret = ""
	for _i in range(rep):
		ret+=s
	return ret
