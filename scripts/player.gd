extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -240.0

@onready var player_animation: AnimatedSprite2D = %PlayerAnimation

var is_dead := false
func die():
	is_dead = true
	player_animation.play("death")

var is_dead := false
func die():
	is_dead = true
	animated_sprite_2d.play("die")

func _physics_process(delta: float) -> void:
	if is_dead:
		return  # Stop all movement if dead

	# Add gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get input direction
	var direction := Input.get_axis("ui_left", "ui_right")

	# Flip sprite
	if direction > 0:
<<<<<<< HEAD
		player_animation.flip_h = false
	elif direction < 0:
		player_animation.flip_h = true
=======
		animated_sprite_2d.flip_h = false
	elif direction < 0:
		animated_sprite_2d.flip_h = true
>>>>>>> 7d5ff87ffb0b1df65204bc50675f5cac6e598a30

	# Play animations
	if is_on_floor():
		if direction == 0:
			player_animation.play("idle")
		else:
			player_animation.play("Run")
	else:
<<<<<<< HEAD
		player_animation.play("Jumpo")
=======
		animated_sprite_2d.play("Jumpo")
>>>>>>> 7d5ff87ffb0b1df65204bc50675f5cac6e598a30

	# Movement logic
	if direction != 0:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
