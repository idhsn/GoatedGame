extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -280.0
const MAX_HP = 3

@onready var player_sprite: AnimatedSprite2D = $PlayerSprite
@onready var health_bar_fill: ColorRect = $HUD/HealthBarContainer/HealthBarFill
@onready var damage_flash: ColorRect = $HUD/DamageFlash  # <-- Add this node to your UI

var hp: int = MAX_HP
var is_dead := false

func _ready():
	update_health_bar()

func update_health_bar():
	if health_bar_fill:
		var target_scale = clamp(hp / float(MAX_HP), 0.0, 1.0)
		health_bar_fill.scale = Vector2(target_scale, 1.0)
	else:
		print("ERROR: health_bar_fill is null!")

func flash_damage_feedback():
	if damage_flash:
		damage_flash.modulate = Color(1, 0, 0, 0.4)  # Red tint
		damage_flash.show()
		get_tree().create_timer(0.2).connect("timeout", Callable(self, "_clear_damage_flash"))

func _clear_damage_flash():
	damage_flash.modulate = Color(0, 0, 0, 0)

func set_hp(value: int) -> void:
	if hp == value:
		return  # No change

	hp = clamp(value, 0, MAX_HP)
	update_health_bar()
	flash_damage_feedback()

	if hp <= 0 and not is_dead:
		die()

func die():
	is_dead = true
	player_sprite.play("Death")
	velocity = Vector2.ZERO
	
	# Reload scene after short delay
	get_tree().create_timer(1.5).connect("timeout", Callable(get_tree(), "reload_current_scene"))

func _physics_process(delta: float) -> void:
	if is_dead:
		return  # Stop all movement if dead

	# Instant death if falling off map
	if position.y > 1000:  # Adjust based on your map size
		set_hp(0)
		return

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

	if direction != 0:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
