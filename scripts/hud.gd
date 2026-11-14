extends CanvasLayer

signal restart_requested

@onready var distance_label: Label = $TopBar/DistanceLabel
@onready var coin_label: Label = $TopBar/CoinLabel
@onready var combo_label: Label = $TopBar/ComboLabel
@onready var game_over_panel: PanelContainer = $GameOverPanel
@onready var final_distance_label: Label = $GameOverPanel/VBoxContainer/FinalDistanceLabel
@onready var final_coins_label: Label = $GameOverPanel/VBoxContainer/FinalCoinsLabel
@onready var restart_button: Button = $GameOverPanel/VBoxContainer/RestartButton

var best_distance: int = 0

func _ready() -> void:
	game_over_panel.visible = false
	combo_label.visible = false
	restart_button.pressed.connect(_on_restart_pressed)

func update_stats(meters: int, coins: int) -> void:
	distance_label.text = "%d m" % meters
	coin_label.text = "🪙 %d" % coins

func update_combo(combo: int) -> void:
	if combo > 1:
		combo_label.visible = true
		combo_label.text = "BOUNCE x%d!" % combo
		var tw = create_tween()
		combo_label.scale = Vector2(1.25, 1.25)
		tw.tween_property(combo_label, "scale", Vector2.ONE, 0.12)
	else:
		combo_label.visible = false

func show_game_over(meters: int, coins: int) -> void:
	best_distance = maxi(best_distance, meters)
	final_distance_label.text = "Distance: %d m (Best: %d m)" % [meters, best_distance]
	final_coins_label.text = "Coins Collected: %d" % coins
	game_over_panel.visible = true

func _unhandled_input(event: InputEvent) -> void:
	if game_over_panel.visible:
		if (
			event.is_action_pressed("ui_accept")
			or (event is InputEventKey and event.pressed and event.keycode == KEY_SPACE)
			or (event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT)
		):
			_on_restart_pressed()

func _on_restart_pressed() -> void:
	emit_signal("restart_requested")
