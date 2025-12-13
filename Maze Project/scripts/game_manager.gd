extends Node

# Global functions

# Player Score
var score: int = 2000
var bonus: int = 0
var won: bool = false
var fog_label: bool = false

func _input(event):
	if event.is_action_pressed("ui_cancel"):  # "ui_cancel" is mapped to Esc by default
		get_tree().paused = false
		get_tree().reload_current_scene()

func _init() -> void:
	Global.success.connect(_on_success)
	Global.fail.connect(_on_fail)

func _on_success(name: String) -> void:
	increase_score(60)

func _on_fail(name: String) -> void:
	decrease_score(10)

@onready var score_label = $"../ScoreboardLayer/ScoreLabel"
@onready var bonus_score_label = $"../ScoreboardLayer/bonusScoreLabel"

func update_score_display():
	if score_label:
		score_label.text = str(score)

func update_bonus_score_display():
	if bonus_score_label:
		bonus_score_label.text = str(bonus)

func decrease_score(amount: int) -> void:
	score -= amount
	score = max(score, 0)
	update_score_display()

func increase_score(amount: int) -> void:
	# Increase the score by the given amount
	if amount + score > 2000:
		bonus += amount + score - 2000
		update_bonus_score_display()
		score = 2000
	else:
		score += amount
	# Update the score display
	update_score_display()

func _ready():
	update_score_display()
	update_bonus_score_display()

# Item use Puzzle
enum Items {Oil, Cloth, Stick}
var player_items = []

func aquire_item(Item: Items):
	player_items.append(Item)

func has_all_items() -> bool:
	return [Items.Oil, Items.Cloth, Items.Stick].all(player_items.has)

# Match moving Puzzle
var num_turns = 3
var slot_occupancy: Dictionary = {1: true, 2: true, 3: true, 5: true, 6: true, 7: true, 8: true, 9: true, 10: true,
								11: true, 12: true, 13: true, 14: true, 15: true, 16: true, 17: true, 18: true, 19: true,
								20: true, 21: true, 22: true, 23: true, 24: true, 25: true, 26: true, 27: true, 28: true,
								29: true, 30: true, 31: true, 32: true}  # Tracks whether slots are occupied

# List of slot IDs that must be occupied to solve the puzzle
@export var solution_slots: Array = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 
									11, 12, 13, 14, 15, 16, 17, 18, 19, 20,
									21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]

@onready var match_label: Label = $"../CanvasLayer/PanelGUI/MatchPuzzle/Label"
@onready var panel_gui: Control = $"../CanvasLayer/PanelGUI"

func decrease_turns():
	if num_turns > 1:
		num_turns -= 1
		match_label.text = "move the matches so the equation is right\nyou have " + str(num_turns) + " tries left"
	else:
		match_label.text = "You Failed!"
		match_label.add_theme_color_override("font_color", Color(1, 0, 0))
		
		var timer = Timer.new()
		timer.one_shot = true
		timer.wait_time = 1
		add_child(timer)
		timer.start()
		await timer.timeout
		
		Global.fail.emit('match')

func update_slot_occupancy(slot_id: int, is_occupied: bool) -> void:
	slot_occupancy[slot_id] = is_occupied
	check_match_puzzle()

func check_match_puzzle() -> void:
	for slot_id in solution_slots:
		if not slot_occupancy.get(slot_id, false):  # If a required slot is not occupied
			return
	Global.success.emit('match')
