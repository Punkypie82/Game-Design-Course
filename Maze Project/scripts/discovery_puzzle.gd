extends Container

var discovery_turns = 3

@onready var discovery_label: Label = $Label
@onready var game_manager: Node = %GameManager
@onready var answer: TextEdit = $Node/TextEdit

func _input(event: InputEvent) -> void:
	if visible:
		if event.is_action_pressed('next_stage'):
			if answer.text == '9248':
				discovery_label.text = 'شما رمز را صحیح تشخیص دادین.'
				discovery_label.add_theme_color_override("font_color", Color(0, 1, 0))
				var timer = Timer.new()
				timer.one_shot = true
				timer.wait_time = 1
				add_child(timer)
				timer.start()
				await timer.timeout
				Global.success.emit('discovery')
			elif discovery_turns > 1:
				discovery_label.text = 'اشتباه بود!!!'
				discovery_label.add_theme_color_override("font_color", Color(1, 0, 0))
				var timer = Timer.new()
				timer.one_shot = true
				timer.wait_time = 1
				add_child(timer)
				timer.start()
				await timer.timeout
				discovery_turns -= 1
				discovery_label.text = 'رمز را وارد کنید\nشما ' + str(discovery_turns) + 'تلاش دیگر دارید'
				discovery_label.add_theme_color_override("font_color", Color(1, 1, 1))
			else:
				Global.fail.emit('discovery')
