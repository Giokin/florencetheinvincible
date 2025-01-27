extends CharacterBody2D

@onready var animation_sprite = $AnimatedSprite2D

const JUMP_POWER = -400
const GRAVITY = 50

func _physics_process(delta):
	if is_on_wall() and is_on_floor():
		velocity.y = JUMP_POWER
	else:
		velocity.y += GRAVITY
	
	move(-1, 50)
	move_and_slide()

func move(dir, speed):
	velocity.x = dir * speed
	handle_animation()
	update_flip(dir)
	
func update_flip(dir):
	if abs(dir) == dir:
		animation_sprite.flip_h = true
	else:
		animation_sprite.flip_h = false

func handle_animation():
	if velocity.x != 0:
		animation_sprite.play("walk")
	else:
		animation_sprite.play("idle")
