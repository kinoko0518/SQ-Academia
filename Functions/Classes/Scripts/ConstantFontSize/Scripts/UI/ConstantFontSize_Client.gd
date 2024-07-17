extends Control

var default_font_size:float = 12
var default_line_spacing:float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	if self.get("theme_override_font_sizes/font_size") != null:
			default_font_size = self.get("theme_override_font_sizes/font_size")
	elif self.theme != null:
		default_font_size = self.theme.default_font_size
	
	if has_theme_constant_override("line_spacing"):
		default_line_spacing = get("theme_override_constants/line_spacing")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	self.set("theme_override_font_sizes/font_size", default_font_size * ConstantFontSize.diagonal_magnification)
	self.set("theme_override_constants/line_spacing", default_line_spacing * ConstantFontSize.diagonal_magnification)
