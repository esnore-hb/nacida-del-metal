class_name Lord
extends RigidBody2D

@export var MOVE_SPEED: float = 150.0
@export var MAX_SPEED: float = 200.0
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _physics_process(_delta: float) -> void:
	var direction: float = Input.get_axis("nacida_left", "nacida_right")
	var force: Vector2 = Vector2.ZERO

	if direction:
		force.x = MOVE_SPEED * direction

		if abs(linear_velocity.x) > MAX_SPEED:
			linear_velocity.x = MAX_SPEED * direction

	apply_central_impulse(force)


func _integrate_forces(_state: PhysicsDirectBodyState2D) -> void:
	rotation_degrees = 0.0
