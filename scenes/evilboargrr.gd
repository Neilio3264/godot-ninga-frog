extends CharacterBody2D


var speed = -40.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var facing_right = false
var on_patrol = false
var patrol_finished = true

func _ready():
	$AnimatedSprite2D.play("walk")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	if !$RayCast2D.is_colliding() && is_on_floor():
		flip()

	if !on_patrol:
		velocity.x = speed 
		move_and_slide()

func patrol():
	$AnimatedSprite2D.play("idle")
	if $Timer.get_time_left() == 0 && patrol_finished:
		$Timer.start()
		on_patrol = true
		patrol_finished = false
	elif !patrol_finished:
		patrol_finished = true

func flip():
	patrol()
	
	if !on_patrol:
		$AnimatedSprite2D.play("walk")
		facing_right = !facing_right
		
		scale.x = abs(scale.x) * -1
		if facing_right:
			speed = abs(speed)
		else:
			speed = abs(speed) * -1


func _on_hitbox_area_entered(area):
	if area.get_parent() is Player:
		area.get_parent().death()


func _on_timer_timeout():
	on_patrol = false
