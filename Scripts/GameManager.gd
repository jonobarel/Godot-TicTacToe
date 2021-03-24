extends Node

var board : GameBoard
var players = [] # holds references to the players in order to get moves from them.
var last_symbol = ""
var human_player_turn = true
var single = 0
var ai_mode = "random" # "hack", "heuristic", "minimax"
var game_over = false

# Called when the node enters the scene tree for the first time.
func _ready():
	board = $GameBoard
	print(board.show_board())

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
		var textbox = $"../UI/GameResult"
		var winner = board.get_winner()
		if winner in ["x", "o"]:
			textbox.set_bbcode("[center]The winner is %s![/center]" % winner.to_upper())
		else:
			textbox.set_bbcode("[center]It's a tie![/center]")
		textbox.visible = true
		
	elif not human_player_turn:
		var pos = get_ai_move(board)
		board.play(pos, "o")
		human_player_turn = true
		
func get_ai_move(board : GameBoard) -> int:
	var moves = board.get_available_moves()
	match ai_mode:
		"random":
			return moves[randi() % moves.size()]
	return -1
