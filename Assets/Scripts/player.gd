extends RigidBody2D


var speed = 15;
var max_speed = 250;
var jump_strength = 300;

export var move_right = "move_right"
export var move_left = "move_left"
export var move_up = "move_up"
export var attack = "attack"
export(NodePath) var opponent_path
export(NodePath) var respawn_path

onready var _hitbox = $Weapon
onready var _animator = $AnimationPlayer
onready var _sprite = $Sprite


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var _opponent = get_node(opponent_path)
	if  _opponent.position.x < self.position.x:
		_sprite.flip_v = true
	else:
		_sprite.flip_v = false
func _integrate_forces(state):
	var _opponent = get_node(opponent_path)
	self.look_at(Vector2(_opponent.position.x, self.position.y))
	
	if Input.is_action_just_pressed(attack):
		_animator.play("PlayerAttackAnim")
	
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

func respawn():
	var respawn_point = get_node(respawn_path)
	self.position = respawn_point.position
