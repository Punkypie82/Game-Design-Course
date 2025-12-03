class_name InteractionsHost extends Node2D

@onready var player: Player = $".."

# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#player.DirectionChanged.connect( UpdateDirection )

#
#func UpdateDirection( new_direction: Vector2 ) -> void:
	#match new_direction:
		#Vector2.DOWN:
			#position.x = 0
			#position.y = 5
		#Vector2.UP:
			#position.x = 0
			#position.y = -35
		#Vector2.LEFT:
			#position.x = -20
			#position.y = -25
		#Vector2.RIGHT:
			#position.x = 20
			#position.y = -25
		#_:
			#position.x = 0
			#position.y = 5
