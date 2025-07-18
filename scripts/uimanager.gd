# UIManager.gd
extends CanvasLayer

@onready var score: Label = $CoinsUI/ScoreContainer/Score



func _ready():
	var game_manager: Node = %GameManager
	if game_manager:
		game_manager.connect("score_changed",Callable (self, "_on_score_changed"))
	else:
		printerr("GameManager not found!")

func _on_score_changed(new_score: int):
	score.text = "%d" % new_score
