extends Control

@export var questions_temp:Array[Question]
@export var passed_questions:Array = []

# -1 そもそも選択肢問題じゃなかったとき
# それ以降はボタン番号に対応
signal response_accepted(choise_number:int)

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false

func start_lesson(questions:Array[Question]):
	questions_temp = []
	passed_questions = []
	$TextEdit.text = ""
	$Button.text = "Next"
	
	$Button.button_down.connect(button_accepted.bind(-1))
	
	for _i in range(questions.size()):
		update_info_with_question(questions[_i])
		
		if not questions[_i].choises.is_empty():
			for _ii in range($VBoxContainer.get_child_count()):
				$VBoxContainer.get_child(_ii).button_down.connect(button_accepted.bind(_ii))
		
		passed_questions.push_back([questions[_i].question, get_response(await response_accepted), questions[_i].get_answers()])
		$TextEdit.text = ""
	
	#### 結果の計算 ####
	
	delete_all_child($VBoxContainer)
	
	var incorrects:int = 0
	
	$Label.text = "Result"
	$Button.text = "End"
	
	$Button.visible = true
	
	$TextEdit.visible = false
	$VBoxContainer.visible = true
	
	for _i in range(passed_questions.size()):
		if not passed_questions[_i][1] in questions[_i].get_answers():
			incorrects += 1
			add_message("Q. " + questions[_i].question + "：\n正答・" + questions[_i].get_answers()[0] + "　回答・" + passed_questions[_i][1])
	
	if float(passed_questions.size() - incorrects) / passed_questions.size() >= 1:
		add_message("Perfect!")
	elif float(passed_questions.size() - incorrects) / passed_questions.size() >= 0.9:
		add_message("Great!")
	elif float(passed_questions.size() - incorrects) / passed_questions.size() >= 0.7:
		add_message("Good!")
	elif float(passed_questions.size() - incorrects) / passed_questions.size() >= 0.6:
		add_message("Almost OK")
	elif float(passed_questions.size() - incorrects) / passed_questions.size() < 0.6:
		add_message("Study hard")
	
	await $Button.button_down
	
	self.visible = false
	$"../LessonSelect".visible = true

func add_message(_input):
	var _temp = preload("res://Functions/Study/checking_answer.tscn").instantiate()
	_temp.text = _input
	$VBoxContainer.add_child(_temp)

func update_info_with_question(question:Question):
	$TextEdit.visible = question.choises.is_empty()
	$VBoxContainer.visible = not question.choises.is_empty()
	$Button.visible = question.choises.is_empty()
	
	$Label.text = question.question
	
	delete_all_child($VBoxContainer)
	
	if not question.choises.is_empty():
		for _i in range(question.choises.size()):
			var _temp = Button.new()
			_temp.text = question.choises[_i]
			$VBoxContainer.add_child(_temp)
func button_accepted(num:int):
	response_accepted.emit(num)

func get_response(num:int):
	if num == -1:
		return $TextEdit.text
	else:
		return $VBoxContainer.get_child(num).text

func delete_all_child(node:Node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()
