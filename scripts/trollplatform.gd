extends Node2D

@export var moving_speed: float = 3000
@export var max_position_x: float = 200
var mooving: bool = false


@onready var troll_trigger: Area2D = $troll_trigger

func _physics_process(delta: float) -> void:
	if mooving:
		var target_x = global_position.x + moving_speed * delta
		if target_x < max_position_x:
			global_position.x = target_x
		else:
			global_position.x = max_position_x

func _on_troll_trigger_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		mooving = true
