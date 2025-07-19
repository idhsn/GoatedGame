extends CharacterBody2D

# Constants
const SPEED = 150.0
const JUMP_VELOCITY = -240.0
const GRAVITY = 700.0
const MAX_HP = 8
const HEALTH_BAR_SPEED = 5.0 # Adjust for faster/slower health bar transition

# Nodes
@onready var player_sprite: AnimatedSprite2D = $PlayerSprite
@onready var health_bar_fill: ColorRect = $"../UIHUD/HealthHUD/HealthBarContainer/HealthBarFill"

# Player state
@export var hp: int = MAX_HP
var is_dead := false
var has_weapon := false

# Smooth health bar interpolation
var current_fill_ratio: float = 1.0

func _ready():
	update_health_bar_immediate()

# Public methods
func die():
	if is_dead:
		return
	is_dead = true
	player_sprite.play("Death")
	velocity = Vector2.ZERO
	get_tree().create_timer(1.5).connect("timeout", Callable(get_tree(), "reload_current_scene"))

func pickup_weapon():
	has_weapon = true

# Health system
func set_hp(value: int) -> void:
	if hp == value:
		return

	hp = clamp(value, 0, MAX_HP)
	
	if hp <= 0 and not is_dead:
		die()

func _physics_process(delta: float) -> void:
	if not is_dead:
		# Apply gravity
		if not is_on_floor():
			velocity.y += GRAVITY * delta

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

	# Smoothly update health bar
	update_health_bar(delta)

# Sets the health bar instantly (used in _ready())
func update_health_bar_immediate():
	if health_bar_fill:
		var target_scale = hp / float(MAX_HP)
		health_bar_fill.scale = Vector2(target_scale, 1.0)
	else:
		printerr("ERROR: health_bar_fill is null!")

# Smoothly interpolates the health bar
func update_health_bar(delta: float):
	if health_bar_fill:
		var target_scale = hp / float(MAX_HP)
		current_fill_ratio = lerp(current_fill_ratio, target_scale, HEALTH_BAR_SPEED * delta)
		health_bar_fill.scale = Vector2(current_fill_ratio, 1.0)
	else:
		printerr("ERROR: health_bar_fill is null!")
