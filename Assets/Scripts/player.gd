extends KinematicBody2D


var speed = 250
var jump_strength = -500
var gravity = 1000


var jumping = false
var velocity = Vector2()

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

func _physics_process(delta):
	var _opponent = get_node(opponent_path)
	self.look_at(Vector2(_opponent.position.x, self.position.y))
	if Input.is_action_just_pressed(attack):
		_animator.play("PlayerAttackAnim")
	
	var x_right = Input.is_action_pressed(move_right);
	var x_left = Input.is_action_pressed(move_left);
	var jump = Input.is_action_just_pressed(move_up);
	
	velocity.x = (int(x_right) - int(x_left)) * speed
#	if is_on_floor():
#		velocity.y = 0
#	if jump and is_on_floor():
#		velocity.y = jump_strength
#	velocity.y += gravity * delta
#	move_and_slide(velocity, Vector2(0, -1))
	
	
#	if is_on_ground() and jump:
#		velocity.y = jump_strength
	#velocity.y += gravity * delta
	#is_pancaked()
	
	var collision = move_and_collide(velocity * delta)
	if collision:
		move_and_collide(velocity.slide(collision.normal) * delta)
		var pancake = is_pancaked()
		if is_on_ground() and not pancake:
			if jump:
				velocity.y = jump_strength
		elif pancake and not is_on_ground():
			velocity.y = abs(pancake.collider_velocity.y)
		else:
			velocity.y += gravity * delta
	else:
		velocity.y += gravity * delta


func is_on_ground():
	var ground = move_and_collide(Vector2.DOWN, true, true, true)
	return ground

# Returns whether or not another player is on top
func is_pancaked():
	var pancake = move_and_collide(Vector2.UP, true, true, true)
	return pancake

func respawn():
	var respawn_point = get_node(respawn_path)
	self.position = respawn_point.position
	#self.linear_velocity = Vector2()
	velocity = Vector2()
	_animator.advance(1)
