extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@export_range(0, 1) var acceleration = 0.1
@export_range(0, 1) var deceleration = 0.1

var jumping = false
var whacking = false

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		jumping = true
		velocity.y = JUMP_VELOCITY

	# Handle Whack
	if Input.is_action_just_pressed("Swing") and is_on_floor():
		whacking = true

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("Left", "Right")
	if direction:
		if whacking && is_on_floor():
			direction = 0
		velocity.x = move_toward(velocity.x, direction * SPEED, SPEED * acceleration)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * deceleration)
	
	movementAnimation()
	move_and_slide()

func movementAnimation():
	if jumping && velocity.y != 0:
		sprite.play("jump")
	elif whacking:
		sprite.play("whack")
	else:
		if velocity.x > 0:
			sprite.flip_h = false
			running()
		elif velocity.x < 0:
			sprite.flip_h = true
			running()
		elif velocity.x == 0 && is_on_floor():
			sprite.play("idle")

func running():
	if(is_on_floor()):
		sprite.play("run")


func _on_animated_sprite_2d_animation_finished():
	if whacking:
		whacking = false
	if jumping:
		jumping = false
