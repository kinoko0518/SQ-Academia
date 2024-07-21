extends Resource
class_name Lesson

enum Subjects{
	JapaneseIB,
	JapaneseIA,
	EnglishIA,
	EnglishIB,
	MathIA,
	MathIB,
	Chemical,
	Geology,
	Biology,
	Geograph,
	DSBasic
}

@export var lesson_name:String
@export var subject:Subjects
@export var questions:Array[Question]
