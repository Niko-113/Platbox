extends KinematicBody2D


var speed = 250
var jump_strength = -500
var dash_strength = speed * 2.5
var gravity = 1000
var plat_gravity = gravity / 4
var decel = 20


var direction = 0
var jumping = false
var dashing = false
var velocity = Vector2()

var x_right
var x_left
var jump
var dash
var attacked

export var move_right = "move_right"
export var move_left = "move_left"
export var move_up = "move_up"
export var attack = "attack"
export var dash_input = "dash"
export var drop_input = "drop"
export(NodePath) var opponent_path
export(NodePath) var respawn_path

var sound_player = preload("res://Assets/Prefabs/sound_player.tscn")

onready var _hitbox = $Weapon
onready var _animator = $AnimationPlayer
onready var _sprite = $Sprite
onready var _sound = $AudioStreamPlayer2D


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
		
		

func process_input():
	x_right = Input.is_action_pressed(move_right)
	x_left = Input.is_action_pressed(move_left)
	jump = Input.is_action_just_pressed(move_up)
	dash = Input.is_action_just_pressed(dash_input)
	attacked = Input.is_action_just_pressed(attack)


func _physics_process(delta):
	if not get_node("/root/GameManager").input_disabled:
		process_input()
	var _opponent = get_node(opponent_path)
	self.look_at(Vector2(_opponent.position.x, self.position.y))
	if attacked:
		_animator.play("PlayerAttackAnim")
	
	
	var attacking = _animator.current_animation == "PlayerAttackAnim"
	
	if Input.is_action_just_pressed(drop_input):
		self.set_collision_layer_bit(1, false)
	if Input.is_action_just_released(drop_input):
		self.set_collision_layer_bit(1, true)
	
	# TODO: Replace all of this with a proper state machine
	if not attacking:
		if not dashing:
			direction = int(x_right) - int(x_left)
			velocity.x = direction * speed
		
		if dash and not dashing:
			play_sound("Dash")
			dashing = true
#			if direction == 0:
#				direction = 1
			velocity.x = dash_strength * direction
	elif is_on_ground():	
		if velocity.x * direction > 0:
			velocity.x -= decel * direction
		else:
			velocity.x = 0
	
	if dashing:
		velocity.x -= decel * direction
		if (velocity.x * direction <= speed * 0.75):
			dashing = false
	
	
	var collision = move_and_collide(velocity * delta)
	if collision:
		move_and_collide(velocity.slide(collision.normal) * delta)
		var pancake = is_pancaked()
		if is_on_ground() and not pancake:
			if jump and not attacking:
				velocity.y = jump_strength
				play_sound("jump")
			else:
				velocity.y = plat_gravity
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
	
func play_sound(sound):
	var speaker = sound_player.instance() 
	add_child(speaker)
	speaker.play_sound("res://Assets/Sounds/" + sound + ".wav")
