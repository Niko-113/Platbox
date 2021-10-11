extends Node2D

var points_1 = 0
var points_2 = 0
var current_scene = null
var root

# Called when the node enters the scene tree for the first time.
func _ready():

	_setup()
	

func _setup():
	points_1 = 0
	points_2 = 0
	print_debug("EEEEE")
	root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func addScore(player):
	# Should figure out a way to make this less hard-coded...
	var score = get_node("/root/Fight/Control/Score" + str(player))
	var pointer = "points_" + str(player)
	set(pointer, get(pointer) + 1)
	pointer = get(pointer)
	score.text = str(pointer)
	print_debug(pointer)
	if pointer >= 5:
		get_tree().reload_current_scene()
		_setup()
