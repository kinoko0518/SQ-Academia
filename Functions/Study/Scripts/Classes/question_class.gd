extends Resource
class_name Question

@export_multiline var question:String

@export_multiline var answers:Array[String]
@export_multiline var choises:Array[String]
@export var correct_choise:int = -1

func get_answers():
	if not correct_choise == -1:
		return [choises[correct_choise]]
	else:
		return answers
