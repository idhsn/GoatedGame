extends Area2D

@onready var timer = $Timer

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("set_hp") and body.global_position.y > 41:
		body.die()
		
func _on_timer_timeout() -> void:
	get_tree().reload_current_scene()
