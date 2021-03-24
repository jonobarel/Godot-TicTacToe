extends Node


var grid = []
var active_player # 0,1

var players = [] #interface to talk to the players via get_next_move()


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	reset_game()
	

func reset_game():
	init_grid()
	active_player = randi() % 2 # choose a starting player
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
