extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var speed = 15;
var max_speed = 250;
var jump_strength = 300;


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _integrate_forces(state):
	
	var grounded = state.get_contact_count() > 0;
	
	var move_right = Input.is_action_pressed("ui_right");
	var move_left = Input.is_action_pressed("ui_left");
	var jump = Input.is_action_just_pressed("ui_up");
	
	if jump and grounded:
		state.apply_central_impulse(Vector2.UP * jump_strength);
		
	var vec = state.get_linear_velocity();
	
	vec.x += int(move_right) * speed;
	vec.x = min(vec.x, max_speed);
	
	vec.x -= int(move_left) * speed;
	vec.x = max(vec.x, -max_speed);
	
	state.set_linear_velocity(vec);
	
