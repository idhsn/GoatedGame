extends Node2D

const SPEED = 20

var direction = 1

@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var enemy_sprite: AnimatedSprite2D = $EnemySprite

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if ray_cast_right.is_colliding():
		direction = -1
		enemy_sprite.flip_h = true 
	if ray_cast_left.is_colliding():
		direction = 1
		enemy_sprite.flip_h = false

	
	position.x += direction * SPEED * delta



	
