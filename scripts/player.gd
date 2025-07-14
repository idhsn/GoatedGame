extends CharacterBody2D

# Constants
const SPEED = 150.0
const JUMP_VELOCITY = -240.0
const GRAVITY = 700.0
const MAX_HP = 3

# Nodes
@onready var player_sprite: AnimatedSprite2D = $PlayerSprite
@onready var health_bar_fill: ColorRect = $HUD/HealthBarContainer/HealthBarFill
@onready var damage_flash: ColorRect = $HUD/DamageFlash

# Player state
var hp: int = MAX_HP
var is_dead := false
var has_weapon := false

func _ready():
	update_health_bar()

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
	update_health_bar()
	flash_damage_feedback()

	if hp <= 0 and not is_dead:
		die()

func update_health_bar():
	if health_bar_fill:
		var target_scale = hp / float(MAX_HP)
		health_bar_fill.scale = Vector2(target_scale, 1.0)
	else:
		printerr("ERROR: health_bar_fill is null!")

func flash_damage_feedback():
	if damage_flash:
		damage_flash.modulate = Color(1, 0, 0, 0.4)
		damage_flash.show()
		get_tree().create_timer(0.2).connect("timeout", Callable(self, "_clear_damage_flash"))

func _clear_damage_flash():
	damage_flash.modulate = Color.TRANSPARENT

# Physics process
func _physics_process(delta: float) -> void:
	if is_dead:
		return

	# Instant death if falling off map
	if position.y > 1000:
		set_hp(0)
		return

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
