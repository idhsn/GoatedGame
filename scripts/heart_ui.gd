extends AnimatedSprite2D


@onready var heart_ui: AnimatedSprite2D = $"."
@onready var player: CharacterBody2D = $"../../../player"

func _process(delta: float) -> void:
	var hp = player.hp
	match hp:
		8:
			heart_ui.play("full")
		7:
			heart_ui.play("full-1")
		6:
			heart_ui.play("full-2")
		5:
			heart_ui.play("full-3")
		4:
			heart_ui.play("full-4")
		3:
			heart_ui.play("full-5")
		2:
			heart_ui.play("full-6")
		1:
			heart_ui.play("full-7")
		0:
			heart_ui.play("dead")
