extends Area2D

signal bumper_hit(score_points: int)

@export var base_points: int = 150
@export var bounce_power: float = 680.0

var scroll_speed: float = 300.0
var pulse_time: float = 0.0

@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _process(delta: float) -> void:
	position.x -= scroll_speed * delta
	pulse_time += delta * 4.0
	var scale_pulse = 1.0 + 0.06 * sin(pulse_time)
	sprite.scale = Vector2(scale_pulse, scale_pulse)

	if position.x < -120.0:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("bounce_off_bumper"):
		var dir = (body.global_position - global_position).normalized()
		if dir.y > -0.35:
			dir.y = -0.75
		dir = dir.normalized()

		var impulse = Vector2(0.0, dir.y * bounce_power)
		body.bounce_off_bumper(impulse)
		emit_signal("bumper_hit", base_points)

		# punch effect
		var tw = create_tween()
		tw.tween_property(sprite, "scale", Vector2(1.35, 1.35), 0.07)
		tw.tween_property(sprite, "scale", Vector2.ONE, 0.14)
