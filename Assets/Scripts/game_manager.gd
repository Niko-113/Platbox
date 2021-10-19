extends Node2D

var points_1 = 0
var points_2 = 0
var current_scene = null
var root

# Called when the node enters the scene tree for the first time.
func _ready():
	_setup()

func _setup():
	get_tree().reload_current_scene()
	Engine.time_scale = 1
	points_1 = 0
	points_2 = 0
	print_debug("EEEEE")
	root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)
	
	
func next_round():
	get_tree().paused = true
	yield(get_tree().create_timer(0.5), "timeout")
	get_tree().paused = false
	var player_1 = get_node("/root/Fight/Player")
	player_1.respawn()
	var player_2 = get_node("/root/Fight/Player2")
	player_2.respawn()
	

func addScore(player):
	# Should figure out a way to make this less hard-coded...
	var score = get_node("/root/Fight/Control/Score" + str(player))
	var pointer = "points_" + str(player)
	set(pointer, get(pointer) + 1)
	pointer = get(pointer)
	score.text = str(pointer)
	print_debug(pointer)
	if pointer >= 7:
		game_over(player)
	else:
		# Start the next round
		next_round()

func game_over(player):
	var results = get_node("/root/Fight/Control/Results")
	results.visible = true
	Engine.time_scale = 0
	
	var winner_text = get_node("/root/Fight/Control/Results/WinnerText")
	winner_text.text = "Player " + str(player) + " wins!"
	
	var restart_button = get_node("/root/Fight/Control/Results/RestartButton")
	restart_button.connect("pressed", self, "_setup")
	
