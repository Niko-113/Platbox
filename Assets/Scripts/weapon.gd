extends Node


export var player_no = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", self, "_on_player_hit")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	


func _on_player_hit(body):
	#get_tree().reload_current_scene()
	print_debug(body.name + " was hit!")
	var manager = get_node("/root/GameManager")
	manager.addScore(player_no)
