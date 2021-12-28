extends KinematicBody2D

const max_speed = 100
const accelaration =500
const friction = 500
enum{
	MOVE,
	ROLL,
	ATTACK
}

var state = MOVE

var velocity = Vector2.ZERO

onready var animation = $AnimationPlayer
onready var animationtree = $AnimationTree
onready var animationstate = animationtree.get("parameters/playback")

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			pass
		ATTACK:
			attack_state(delta)
			
	
func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()

	if input_vector != Vector2.ZERO:
		animationtree.set("parameters/idle/blend_position", input_vector)
		animationtree.set("parameters/run/blend_position", input_vector)
		animationtree.set("parameters/attack/blend_position", input_vector)	
		animationstate.travel("run")
		velocity = velocity.move_toward(input_vector * max_speed, accelaration * delta)

	else:
		animationstate.travel("idle")
		velocity = velocity.move_toward(Vector2.ZERO , friction * delta)

	velocity = move_and_slide(velocity)
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
	
func attack_state(delta):
	velocity = Vector2.ZERO
	animationstate.travel("attack")

func attack_aimation_finished():
	state = MOVE
	

	
