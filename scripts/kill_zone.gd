extends Area2D

@onready var timer = $Timer

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("set_hp") and body.hp > 0:
		body.set_hp(body.hp - 1)
		print("Player took damage! HP left:", body.hp)

func _on_timer_timeout() -> void:
	get_tree().reload_current_scene()
