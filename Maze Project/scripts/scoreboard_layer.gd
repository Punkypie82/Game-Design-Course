extends CanvasLayer

@onready var camera = $"../Player/Camera2D"  # Adjust this path to your Camera2D node
@onready var score_label = $ScoreLabel
@onready var coin_icon = $CoinIcon
@onready var score_container = $ScoreContainer

@onready var bonus_score_label = $bonusScoreLabel
@onready var bonus_coin_icon = $bonusCoinIcon
@onready var bonus_score_container = $bonusScoreContainer

func _process(delta):
	if camera and score_label and bonus_score_label:
		score_label.global_position = camera.global_position + Vector2(-198, -114)
		coin_icon.global_position = camera.global_position + Vector2(-218, -117)
		score_container.global_position = camera.global_position + Vector2(-220, -120)
		
		bonus_score_label.global_position = camera.global_position + Vector2(-198, -90)
		bonus_coin_icon.global_position = camera.global_position + Vector2(-218, -92)
		bonus_score_container.global_position = camera.global_position + Vector2(-220, -96)
		
		

		
