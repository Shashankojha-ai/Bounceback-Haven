extends Area2D

@export var beam_length: float = 140.0
@export var beam_angle_deg: float = 0.0

var scroll_speed: float = 300.0
var flicker: float = 0.0

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var emitter_left: Sprite2D = $EmitterLeft
@onready var emitter_right: Sprite2D = $EmitterRight

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	rotation_degrees = beam_angle_deg

	var shape = CapsuleShape2D.new()
	shape.radius = 8.0
	shape.height = beam_length
	collision_shape.shape = shape
	collision_shape.rotation_degrees = 90.0

	var half_len = beam_length * 0.5
	emitter_left.position = Vector2(-half_len, 0.0)
	emitter_right.position = Vector2(half_len, 0.0)

func _process(delta: float) -> void:
	position.x -= scroll_speed * delta
	flicker += delta * 20.0
	queue_redraw()

	if position.x < -200.0:
		queue_free()

func _draw() -> void:
	var half_len = beam_length * 0.5
	var p1 = Vector2(-half_len, 0.0)
	var p2 = Vector2(half_len, 0.0)

	var pulse = 0.7 + 0.3 * sin(flicker)
	draw_line(p1, p2, Color(1.0, 0.25, 0.1, 0.35 * pulse), 14.0)
	draw_line(p1, p2, Color(1.0, 0.45, 0.1, 0.8 * pulse), 6.0)
	draw_line(p1, p2, Color(1.0, 0.95, 0.8, 1.0), 2.5)

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_hit"):
		body.take_hit()
