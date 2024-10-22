class_name TButton extends TextureButton


const SHADOW_COLOR := Color.BLACK
const SHADOW_COLOR_HOVER := Color("#361e15")

const TEXT_COLOR := Color.WHITE
const TEXT_COLOR_HOVER := Color.GOLDENROD


func _ready() -> void:
	_set_text_color.bind(TEXT_COLOR, SHADOW_COLOR)
	mouse_exited.connect(_set_text_color.bind(TEXT_COLOR, SHADOW_COLOR))
	mouse_entered.connect(_set_text_color.bind(TEXT_COLOR_HOVER, SHADOW_COLOR_HOVER))
	mouse_entered.connect(AudioManager.sfx_play.bind(AudioManager.sfx_enum.SELECT, 0.0))


func _set_text_color(text: Color, shadow: Color) -> void:
	for c: Node in get_children():
		if c is RichTextLabel:
			c.add_theme_color_override(&"default_color", text)
			c.add_theme_color_override(&"font_shadow_color", shadow)
		if c is Label:
			c.add_theme_color_override(&"font_color", text)
			c.add_theme_color_override(&"font_shadow_color", shadow)
