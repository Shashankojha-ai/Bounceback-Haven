extends CharacterBody2D

signal bounced(type: String, combo: int)
signal coin_collected(amount: int)
signal died

const GRAVITY: float = 1320.0
const THRUST_ACCEL: float = -2250.0
const MAX_RISE_SPEED: float = -660.0
const MAX_FALL_SPEED: float = 880.0
const FLOOR_BOUNCE: float = -520.0
const CEILING_BOUNCE: float = 380.0

@export var max_combo: int = 5
@export var combo_timeout: float = 2.8

var is_alive: bool = true
var combo_count: int = 1
var combo_timer: float = 0.0

var target_scale: Vector2 = Vector2.ONE
var current_scale: Vector2 = Vector2.ONE

@onready var sprite: Node2D = $Sprite2D
@onready var thruster_particles: CPUParticles2D = $ThrusterParticles
@onready var bounce_particles: CPUParticles2D = $BounceParticles
@onready var death_particles: CPUParticles2D = $DeathParticles
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	is_alive = true
	velocity = Vector2.ZERO
	thruster_particles.emitting = false

func _physics_process(delta: float) -> void:
	if not is_alive:
		# spin out and fall on crash
		velocity.y += GRAVITY * delta
		move_and_slide()
		sprite.rotation += 9.0 * delta
		return

	process_combo_decay(delta)
	handle_flight_physics(delta)
	move_and_slide()
	check_bounces()
	update_squash_and_stretch(delta)

func handle_flight_physics(delta: float) -> void:
	var wants_thrust = (
		Input.is_action_pressed("thrust")
		or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)
		or Input.is_key_pressed(KEY_SPACE)
		or Input.is_key_pressed(KEY_W)
		or Input.is_key_pressed(KEY_UP)
	)

	if wants_thrust:
		velocity.y = maxf(velocity.y + THRUST_ACCEL * delta, MAX_RISE_SPEED)
		thruster_particles.emitting = true
		target_scale = Vector2(0.85, 1.18)
	else:
		velocity.y = minf(velocity.y + GRAVITY * delta, MAX_FALL_SPEED)
		thruster_particles.emitting = false
		target_scale = Vector2.ONE

func check_bounces() -> void:
	if is_on_floor():
		trigger_bounce("floor", FLOOR_BOUNCE)
	elif is_on_ceiling():
		trigger_bounce("ceiling", CEILING_BOUNCE)

func trigger_bounce(type: String, impulse_y: float) -> void:
	if not is_alive:
		return

	velocity.y = impulse_y
	combo_count = mini(combo_count + 1, max_combo)
	combo_timer = combo_timeout

	# impact deformation
	if type == "floor":
		current_scale = Vector2(1.35, 0.65)
	elif type == "ceiling":
		current_scale = Vector2(1.25, 0.75)
	elif type == "bumper":
		current_scale = Vector2(1.45, 0.55)

	bounce_particles.restart()
	bounce_particles.emitting = true
	emit_signal("bounced", type, combo_count)

func bounce_off_bumper(impulse: Vector2) -> void:
	if not is_alive:
		return
	velocity = impulse
	trigger_bounce("bumper", impulse.y)

func process_combo_decay(delta: float) -> void:
	if combo_count > 1:
		combo_timer -= delta
		if combo_timer <= 0.0:
			combo_count = 1
			emit_signal("bounced", "decay", 1)

func update_squash_and_stretch(delta: float) -> void:
	current_scale = current_scale.lerp(target_scale, delta * 14.0)
	sprite.scale = current_scale
	# dynamic pitch tilt according to vertical velocity
	var target_tilt = clampf(velocity.y * 0.0005, -0.28, 0.35)
	sprite.rotation = lerp_angle(sprite.rotation, target_tilt, delta * 8.0)

func take_hit() -> void:
	if not is_alive:
		return
	is_alive = false
	thruster_particles.emitting = false
	collision_shape.set_deferred("disabled", true)
	death_particles.restart()
	death_particles.emitting = true
	velocity = Vector2(-220.0, -420.0)
	emit_signal("died")
