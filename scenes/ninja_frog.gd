extends CharacterBody2D
class_name Player
signal health_depleted

@export var speed: float = 150.0
@export var jump_velocity: float = -225.0
@export var double_jump_velocity: float = -150
@onready var animated_sprite: AnimatedSprite2D = $NinjaFrogAnimations


# Get the gravity from the project settings to be synced with RigidBody nodes.
var default_gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var gravity = default_gravity
var water_gravity = -200
var has_double_jumped: bool = false
var animation_Locked: bool = false
var death_Lock: bool = false
var direction: Vector2 = Vector2.ZERO
var can_input = true
var start_pos = Vector2.ZERO
var lives = 3
var deathcount = 0
var was_in_air = false
var start_death = false

func _ready():
	health_depleted.emit(lives)


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		was_in_air = true
		if !has_double_jumped && velocity.y > 0:
			land()
	else:
		has_double_jumped = false
		if was_in_air == true:
			land()
		was_in_air = false
		animation_Locked = false
	if can_input:
			# Handle jump.
		if Input.is_action_just_pressed("Jump"): 
			if is_on_floor():
				jump()
			elif not has_double_jumped:
				doublejump()
	

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		direction = Input.get_vector("Left", "Right", "Down", "Up")
		if direction.x != 0:
			velocity.x = direction.x * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)

		move_and_slide()
	if start_death:
		death()
	update_anim()

func update_anim():
	update_facing()
	if not animation_Locked:
		if death_Lock:
			update_lives()

		if is_on_floor():
			if direction.x != 0:
				animated_sprite.play("Run")
			else:
				animated_sprite.play("idle")
			
func update_facing():
	if direction.x > 0:
		animated_sprite.flip_h = false
	elif direction.x < 0:
		animated_sprite.flip_h = true

func update_lives():
	gravity = default_gravity
	position.y = 0
	position.x = 0
	lives -= 1
	deathcount += 1
	health_depleted.emit(lives)
	print(lives)
	if lives == 1:
		lives = 4
	if deathcount == 5:
		print("Wow, you've died 5 times. ")
	if deathcount == 10:
		print("Dude, you actually kinda suck. How did you die 10 times?!")
	if deathcount == 15:
		print("..15..")
	if deathcount == 20:
		print("Achievment unlocked! You have died 20 times, you suck, absolute loser.")
	death_Lock = false

func jump():
	velocity.y = jump_velocity
	animated_sprite.play("Jump")
	
func doublejump():
	velocity.y = double_jump_velocity
	animated_sprite.play("Backflip")
	has_double_jumped = true
	animation_Locked = true
	
func land():
	animated_sprite.play("Fall")
	animation_Locked = true

func death_handler():
	gravity = 0
	velocity.y = 0
	velocity.x = 0
	animated_sprite.play("Death")
	animation_Locked = true
	death_Lock = true
	can_input = false

func death():
	start_death = true
	death_handler()


func _on_area_2d_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	death()

func _on_area_2d_2_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	death()

func _on_ninja_frog_animations_animation_finished():
	if(["Land", "Backflip", "Death"].has(animated_sprite.animation)):
		animation_Locked = false
		can_input = true
		start_death = false
		
