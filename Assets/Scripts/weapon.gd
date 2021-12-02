extends Node


export var player_no = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", self, "_on_player_hit")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	


func _on_player_hit(body):
	var manager = get_node("/root/GameManager")
	if (not "Player" in body.name) or str(player_no) in body.name or manager.input_disabled:
		return
	get_parent()._sound.stream = load("res://Assets/Sounds/PlayerHurt.wav")
	get_parent()._sound.play()
	manager.addScore(player_no)
