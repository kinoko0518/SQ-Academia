extends MarginContainer

@export var edited_question:Question
var question_type = 0

func _ready():
	$MarginContainer/Essenses/QuestionType.item_selected.connect(question_type_changed)
	$MarginContainer/Essenses/ChoiceQuestion/AddFalseChoice.button_down.connect(false_choice_added)
	$MarginContainer/Essenses/EssayQuestion/AddAnswer.button_down.connect(answer_added)
	
	$MarginContainer/Essenses/Delete.button_down.connect(func hoge(): queue_free())
	question_type_changed(0)

func question_type_changed(index:int):
	if index == 0:
		$MarginContainer/Essenses/ChoiceQuestion.visible = true
		$MarginContainer/Essenses/EssayQuestion.visible = false
		if $MarginContainer/Essenses/EssayQuestion/Answers.get_child_count() == 0:
			answer_added()
	elif index == 1:
		$MarginContainer/Essenses/ChoiceQuestion.visible = false
		$MarginContainer/Essenses/EssayQuestion.visible = true
		if $MarginContainer/Essenses/ChoiceQuestion/FalseChoicesContainer.get_child_count() == 0:
			false_choice_added()
	
	question_type = index

func false_choice_added():
	$MarginContainer/Essenses/ChoiceQuestion/FalseChoicesContainer.add_child(make_choice("False Choice Here"))

func answer_added():
	$MarginContainer/Essenses/EssayQuestion/Answers.add_child(make_choice("Answer Here"))

func make_choice(_text:String) -> HBoxContainer:
	var _temp = HBoxContainer.new()
	var _line_edit_temp = LineEdit.new()
	var delete_button = TextureButton.new()
	
	_temp.add_child(_line_edit_temp)
	_temp.add_child(delete_button)
	
	_line_edit_temp.placeholder_text = _text
	_line_edit_temp.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	
	delete_button.texture_normal = load("res://Editor/cross_mark.png")
	delete_button.ignore_texture_size = true
	delete_button.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
	delete_button.custom_minimum_size = Vector2(15 * ConstantFontSize.diagonal_magnification, 15 * ConstantFontSize.diagonal_magnification)
	delete_button.button_down.connect(func delete(): _temp.queue_free())
	
	return _temp

func compile():
	var compiled = Question.new()
	compiled.question = $MarginContainer/Essenses/Question.text
	
	if question_type == 1:
		for _i in range($MarginContainer/Essenses/EssayQuestion/Answers.get_child_count()):
			compiled.answers.append($MarginContainer/Essenses/EssayQuestion/Answers.get_child(_i).get_child(0).text)
	elif question_type == 0:
		for _i in range($MarginContainer/Essenses/ChoiceQuestion/FalseChoicesContainer.get_child_count()):
			compiled.choises.append($MarginContainer/Essenses/ChoiceQuestion/FalseChoicesContainer.get_child(_i).get_child(0).text)
		var correct_answer = randi_range(0, $MarginContainer/Essenses/ChoiceQuestion/FalseChoicesContainer.get_child_count() - 1)
		var _old = compiled.choises[correct_answer]
		compiled.choises[correct_answer] = $MarginContainer/Essenses/ChoiceQuestion/LineEdit.text
		compiled.choises.push_back(_old)
		compiled.correct_choise = correct_answer
	
	print(compiled.choises)
	return compiled
