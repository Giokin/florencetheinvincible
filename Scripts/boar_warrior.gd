extends CharacterBody2D

@onready var animation_sprite = $AnimatedSprite2D
@onready var vision = $Area2D/CollisionPolygon2D

const JUMP_POWER = -400
const GRAVITY = 50

var current_state: String = "Idle" # Can be "Idle", "Chase", "Attack" or "Patrol"
var detection: bool = false

func _physics_process(delta):
	if is_on_wall() and is_on_floor():
		velocity.y = JUMP_POWER
	else:
		velocity.y += GRAVITY

	match current_state:
		"Idle":
			idle_behavior(delta)
		"Patrol":
			pass
		"Chase":
			pass
		"Attack":
			pass
	
	move(1,50)
	move_and_slide()

func idle_behavior(delta):
	pass

func player_detected(body):
	if(body.name == "Thork"):
		print("Detected")

func update_flip():
	if velocity.x > 0:
		animation_sprite.flip_h = true
		vision.rotation = 180
	else:
		animation_sprite.flip_h = false
		vision.rotation = 0

func move(dir, speed):
	velocity.x = dir * speed
	#handle_animation()
	update_flip()
#
#@onready var animation_sprite = $AnimatedSprite2D
#
#const JUMP_POWER = -400
#const GRAVITY = 50
#
#func _physics_process(delta):
	#if is_on_wall() and is_on_floor():
		#velocity.y = JUMP_POWER
	#else:
		#velocity.y += GRAVITY
	#
	#move(-1, 50)
	#move_and_slide()
#
#func move(dir, speed):
	#velocity.x = dir * speed
	#handle_animation()
	#update_flip(dir)
	#
#func update_flip(dir):
	#if abs(dir) == dir:
		#animation_sprite.flip_h = true
	#else:
		#animation_sprite.flip_h = false
#
#func handle_animation():
	#if velocity.x != 0:
		#animation_sprite.play("walk")
	#else:
		#animation_sprite.play("idle")
