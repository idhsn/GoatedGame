extends CharacterBody2D

# Constants
const SPEED = 150.0
const JUMP_VELOCITY = -280.0

# Nodes
@onready var player_sprite: AnimatedSprite2D = $PlayerSprite

# Player state
var is_dead := false
var has_weapon := false

# Public methods
func die():
	is_dead = true
	player_sprite.play("Death")

func pickup_weapon():
	has_weapon = true

func _physics_process(delta: float) -> void:
	if is_dead:
		return

	# Apply gravity
	if not is_on_floor():
		velocity.y += get_gravity().y * delta

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
			if has_weapon:
				if player_sprite.animation != "Idle_with_GUNX":
					player_sprite.play("Idle_with_GUNX")
			else:
				if player_sprite.animation != "idle":
					player_sprite.play("idle")
		else:
			if has_weapon:
				if player_sprite.animation != "Run_with_GUNX":
					player_sprite.play("Run_with_GUNX")
			else:
				if player_sprite.animation != "Run":
					player_sprite.play("Run")
	else:
		if has_weapon:
			if player_sprite.animation != "jump_with_weapon":
				player_sprite.play("jump_with_weapon")
		else:
			if player_sprite.animation != "Jumpo":
				player_sprite.play("Jumpo")

	# Horizontal movement
	if direction != 0:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
