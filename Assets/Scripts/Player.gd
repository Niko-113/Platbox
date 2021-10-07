extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var speed = 15;
var max_speed = 250;
var jump_strength = 300;

export var move_right = "move_right";
export var move_left = "move_left";
export var move_up = "move_up";
export var attack = "attack";

onready var _animated_sprite = $AnimatedSprite
onready var _hitbox = $Area2D
onready var _animator = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _integrate_forces(state):
	
	if Input.is_action_just_pressed(attack):
		state.apply_central_impulse(Vector2.RIGHT * jump_strength);
		#_animated_sprite.play("attack")
		_animator.play("TestAnim")
		
	
	var grounded = state.get_contact_count() > 0;
	
	var x_right = Input.is_action_pressed(move_right);
	var x_left = Input.is_action_pressed(move_left);
	var jump = Input.is_action_just_pressed(move_up);
	
	if jump and grounded:
		state.apply_central_impulse(Vector2.UP * jump_strength);
		
	var vec = state.get_linear_velocity();
	
	vec.x += int(x_right) * speed;
	vec.x = min(vec.x, max_speed);
	
	vec.x -= int(x_left) * speed;
	vec.x = max(vec.x, -max_speed);
	
	state.set_linear_velocity(vec);

func _on_hitbox_area_entered(area):
	print_debug("TEST");
