extends CanvasLayer


@onready var health: Label = $Control/Health
@onready var cash: Label = $Control/Cash

func _ready() -> void:
	pass

func update_hp( _hp: int, _max_hp: int ) -> void:
	health.text = str( _hp ) + '/' + str( _max_hp ) + 'HP'

func update_cash( _cash: int ) -> void:
	cash.text = str( _cash )
