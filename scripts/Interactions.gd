extends Node2D

# Declare variables for the nodes
@onready var interac_trig: Area2D = $InteracTrig
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var label: Label = $Label  # Add this line to reference the Label node

# Variables to track state
var is_on: bool = false
var is_player_near: bool = false  # Track if the player is near the interaction trigger

func _ready() -> void:
	# Connect the body_entered and body_exited signals of the interaction trigger
	interac_trig.body_entered.connect(_on_interac_trig_body_entered)
	interac_trig.body_exited.connect(_on_interac_trig_body_exited)

	# Hide the label by default
	label.visible = false

func _process(delta: float) -> void:
	# Check if the player is near and has pressed the "interact" input
	if is_player_near and Input.is_action_just_pressed("Interact"):
		is_on = !is_on  # Toggle the light switch state
		sprite.frame = 1 if is_on else 0  # Change the frame based on the state

func _on_interac_trig_body_entered(body: Node2D) -> void:
	# Check if the entering body is the player
	if body.is_in_group("Player"):
		is_player_near = true  # Set the flag that the player is near
		label.visible = true  # Show the label when the player is near

func _on_interac_trig_body_exited(body: Node2D) -> void:
	# Check if the exiting body is the player
	if body.is_in_group("Player"):
		is_player_near = false  # Reset the flag that the player is near
		label.visible = false  # Hide the label when the player leaves
