extends Node

@onready var unit_diagonal : float = sqrt(pow(542, 2)+pow(1206, 2))
var current_diagonal

var window_width
var window_height

@export var diagonal_magnification : float

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	window_width = get_window().size[0]
	window_height = get_window().size[1]
	
	current_diagonal = sqrt(pow(window_width, 2)+pow(window_height, 2))
	
	diagonal_magnification = current_diagonal / unit_diagonal
