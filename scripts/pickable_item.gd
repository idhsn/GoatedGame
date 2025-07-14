extends Node2D

# References to child nodes
@onready var pickable_item: Area2D = $"."
@onready var item_label: Label = $ItemLabel
@onready var item_sprite: AnimatedSprite2D = $ItemSprite

var is_player_near: bool = false

func _ready() -> void:
	item_label.visible = false

func _process(delta: float) -> void:
	if is_player_near and Input.is_action_just_pressed("Interact"):
		pickup()
		
func pickup():
	var player = get_tree().get_first_node_in_group("Player")
	if player and player.has_method("pickup_weapon"):
		player.pickup_weapon()
		
		visible = false

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		is_player_near = true
		item_label.visible = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		is_player_near = false
		item_label.visible = false
