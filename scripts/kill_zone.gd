extends Area2D

@onready var timer = $Timer

func _on_body_entered(body: Node2D) -> void:
	print("You died")

	if body.has_method("die"):
		body.die()  # This will trigger the death animation
		timer.start()
	else:
		_restart_scene()

func _on_timer_timeout() -> void:
	_restart_scene()

func _restart_scene():
	get_tree().reload_current_scene()
