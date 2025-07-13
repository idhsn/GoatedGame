extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -280.0

@onready var player_sprite: AnimatedSprite2D = $PlayerSprite

var is_dead := false
func die():
	is_dead = true
	player_sprite.play("Death")

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
		player_sprite.flip_h = false
	elif direction < 0:
		player_sprite.flip_h = true

	# Play animations
	if is_on_floor():
		if direction == 0:
			player_sprite.play("idle")
		else:
			player_sprite.play("Run")
	else:
		player_sprite.play("Jumpo")

	# Movement logic
	if direction != 0:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
