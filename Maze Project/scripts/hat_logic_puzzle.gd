extends Container

@onready var game_manager: Node = %GameManager
@onready var answer: TextEdit = $Node/TextEdit
@onready var response: Label = $Label3

func _input(event: InputEvent) -> void:
	if visible:
		if event.is_action_pressed('next_stage'):
			if answer.text == '۲' or answer.text == '2':
				response.text = 'پاسختان درست است!!                                                                  '
				response.add_theme_color_override("font_color", Color(0, 1, 0))
				var timer = Timer.new()
				timer.one_shot = true
				timer.wait_time = 1
				add_child(timer)
				timer.start()
				await timer.timeout
				Global.success.emit('hat_logic')
			else:
				response.text = 'پاسختان نادرست است!!                                                                  '
				response.add_theme_color_override("font_color", Color(1, 0, 0))
				var timer = Timer.new()
				timer.one_shot = true
				timer.wait_time = 1
				add_child(timer)
				timer.start()
				await timer.timeout
				response.add_theme_color_override("font_color", Color(1, 1, 1))
				Global.fail.emit('hat_logic')
