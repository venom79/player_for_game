extends KinematicBody2D

const max_speed = 100
const accelaration =500
const friction = 500

var velocity = Vector2.ZERO

onready var animation = $AnimationPlayer
onready var animationtree = $AnimationTree
onready var animationstate = animationtree.get("parameters/playback")

func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		animationtree.set("parameters/idle/blend_position", input_vector)
		animationtree.set("parameters/run/blend_position", input_vector)
		animationstate.travel("run")
		velocity = velocity.move_toward(input_vector * max_speed, accelaration * delta)
	
	else:
		animationstate.travel("idle")
		velocity = velocity.move_toward(Vector2.ZERO , friction * delta)
		
	velocity = move_and_slide(velocity)

