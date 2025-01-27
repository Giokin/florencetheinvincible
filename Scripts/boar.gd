extends CharacterBody2D

const SPEED = 65.0
const MAXSPEED = 500.0
var currentSpeed = SPEED
var heatlh = 3
var direction = -1
var isCharging = false
var isMaxSpeed = false;

@onready var sprite = $BoarAnimations
@onready var agro_timer = $AgroTimer

func _ready():
	agro_timer.timeout.connect(_on_timer_timeout)
	
func _on_timer_timeout():
	# print("Timer has run out")
	agro_timer.stop()
	reset_agro()


func add_gravity(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta
		
func detect_player():
		if $BoarRayCast.is_colliding():
			if $BoarRayCast.get_collider().name == "Thork":
				isCharging = true
				if (agro_timer.is_stopped()):
					agro_timer.start()
			
func charge_player():
	currentSpeed += currentSpeed * .25
	if (currentSpeed >= MAXSPEED):
		isMaxSpeed = true
	else:
		isMaxSpeed = false
	return currentSpeed

func change_direction():
	if is_on_wall():
		direction = -direction
		sprite.flip_h = !sprite.flip_h;
		$BoarRayCast.scale.x *= -1
		
func movement_animation():
	if velocity.x != 0 and !isCharging:
		sprite.play("Walk")
	elif currentSpeed > SPEED and isCharging:
		sprite.play("Run")
	elif currentSpeed > 180 and isCharging:
		sprite.play("Charge1")
	elif currentSpeed > 250 and isCharging:
		sprite.play("Charge2")
	elif currentSpeed > 300 and isCharging:
		sprite.play("Charge3")

func move_enemy():
	if (isCharging and !isMaxSpeed):
		velocity.x = direction * charge_player()
	elif (isMaxSpeed):
		velocity.x = MAXSPEED * direction
	elif (!isCharging):#ToDO make speed a timer?
		velocity.x = currentSpeed * direction
		isCharging = false	
		
func reset_agro():
	velocity.x = SPEED
	isCharging = false
	isMaxSpeed = false
	currentSpeed = SPEED
	

# Maybe a slow down feature? 		
#func stop_charging():
#	currentSpeed -= currentSpeed * .25
#	return currentSpeed
	
			
## Executions of processes
func _physics_process(delta: float) -> void:
	detect_player()
	add_gravity(delta)
	move_enemy()
	move_and_slide()
	change_direction()	
	movement_animation()
