extends Control

@export var questions_temp:Array[Question]
@export var passed_questions:Array = []

# -1 そもそも選択肢問題じゃなかったとき
# それ以降はボタン番号に対応
signal response_accepted(choise_number:int)

# Called when the node enters the scene tree for the first time.
func _ready():
	start_lesson(questions_temp)


func start_lesson(questions:Array[Question]):
	for _i in range(questions.size()):
		update_info_with_question(questions[_i])
		
		if questions[_i].choises.is_empty():
			$Button.button_down.connect(button_accepted, -1)
		else:
			for _ii in range($VBoxContainer.get_child_count()):
				$VBoxContainer.get_child(_ii).button_down.connect(button_accepted, _ii)
		
		passed_questions.push_back([questions[_i].question, await response_accepted, questions[_i].get_answer_example()])
	print(passed_questions)

func update_info_with_question(question:Question):
	$TextEdit.visible = question.choises.is_empty()
	$VBoxContainer.visible = not question.choises.is_empty()
	$Label.text = question.question
	if not question.choises.is_empty():
		for _i in range($VBoxContainer.get_child_count()):
			$VBoxContainer.get_child(_i).queue_free()
		for _i in range(question.choises.size()):
			var _temp = Button.new()
			_temp.text = question.choises[_i]
			$VBoxContainer.add_child(_temp)
func button_accepted(num:int):
	response_accepted.emit()
	if num == -1:
		return $TextEdit.text
	else:
		return $VBoxContainer.get_child(num)
