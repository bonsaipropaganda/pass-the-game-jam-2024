class_name CreditsMenu extends Control


## This signal is emitted when the main menu button is pressed
signal main_menu


const HEADING: String = "[font_size={font_size}][b]{heading}[/b][/font_size]\n\n"


@export var scroll_speed: float = 50.0
@export var boost_scroll_speed: float = 300.0


@onready var scroll_container: ScrollContainer = %ScrollContainer
@onready var credits_container: VBoxContainer = %CreditsContainer


var scroll_px: float = 0.0:
	set(value):
		scroll_px = value
		if is_inside_tree():
			scroll_px = clampf(
				scroll_px,
				0.0,
				get_credits_size()
			)
			scroll_container.scroll_vertical = int(scroll_px)

## The time since the mouse started to be pressed
var mouse_press_time: float = 0.0


func _ready() -> void:
	%Developers.text = get_developers_text("res://3_credits/developers.json")
	%Assets.text = get_assets_text("res://3_credits/assets.json")
	%SpecialThanks.text = read_file("res://3_credits/special_thanks.bbcode.txt")
	
	visibility_changed.connect(func():
		scroll_px = 0.0
	)


func _process(delta: float) -> void:
	if not visible:
		return
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		mouse_press_time += delta
	else:
		mouse_press_time = 0.0
	
	if Input.is_action_pressed(&"ui_focus_prev") or Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		scroll_px -= boost_scroll_speed * delta
	elif Input.is_action_pressed(&"ui_focus_next") or mouse_press_time > 0.12:
		scroll_px += boost_scroll_speed * delta
	else:
		scroll_px += scroll_speed * delta


func get_developers_text(file: String) -> String:
	const DEV_LINE: String = "[cell]\t{DAY_COUNT}:[/cell][cell]{PFP}[b]{NAME}[/b][/cell] [cell]\t[/cell][cell]\t[/cell]"
	
	const DAY_COUNT: String = "Day {day_count}"
	
	const NAME_ALIAS: String = "@{alias}"
	const NAME_IRL  : String = "{name}"
	const NAME_BOTH : String = "{name} (aka. {alias})"
	
	const PFP: String = "[img=center,center]{path}[/img] "
	
	var data: Array = JSON.parse_string(read_file(file))
	var day: int = 1
	var text: String = HEADING.format({"heading": "Developers", "font_size": 16})
	text = str(text, "[table=2]")
	
	for dev in data:
		var day_count: String = DAY_COUNT.format({"day_count": day})
		var dev_name: String
		var pfp_tag: String = ""
		
		# Get devloper information
		if dev is Dictionary:
			var has_alias: bool = ("alias" in dev)
			var has_name: bool = ("name" in dev)
			var has_pfp: bool = ("pfp" in dev)
			
			if has_name && has_alias:
				dev_name = NAME_BOTH.format({"name": dev["name"], "alias": dev["alias"]})
			elif has_name:
				dev_name = NAME_IRL.format({"name": dev["name"]})
			elif has_alias:
				dev_name = NAME_ALIAS.format({"alias": dev["alias"]})
			
			if has_pfp:
				pfp_tag = PFP.format({"path": dev["pfp"]})
		elif dev is String:
			# Assume that the name is an alias by default
			dev_name = NAME_ALIAS.format({"alias": dev})
		else:
			push_error("Incorrect type for developer credits, expecting Dictionary or String, got object: `%s`", dev)
			breakpoint
		
		# Concatenate the developer' credits line
		text = str(
			text,
			DEV_LINE.format({
				"DAY_COUNT": day_count,
				"NAME": dev_name,
				"PFP": pfp_tag
			}),
		)
		day += 1
	text = str(text, "[/table]")
	return text


func get_assets_text(file: String) -> String:
	const ASSET_LINE: String = "[url=\"{link}\"]{name} by {author} (from: {from})[/url]\n\n"
	
	var data: Dictionary = JSON.parse_string(read_file(file))
	var text: String = HEADING.format({"heading": "External Assets", "font_size": 16})
	
	for asset_type: String in data:
		text = str(text, HEADING.format({"heading": asset_type, "font_size": 12}))
		for asset_name: String in data[asset_type]:
			var asset: Dictionary = data[asset_type][asset_name]
			text = str(text,
				ASSET_LINE.format({
					"name": asset_name,
					"link": asset["link"],
					"author": asset["by"],
					"from": asset["from"]
				})
			)
	return text


func read_file(path: String) -> String:
	var file := FileAccess.open(path, FileAccess.READ)
	var text: String = file.get_as_text()
	file.close()
	return text


func get_credits_size() -> int:
	return int(scroll_container.get_v_scroll_bar().max_value)


func _on_main_menu_pressed() -> void:
	main_menu.emit()


func _on_assets_meta_clicked(meta: Variant) -> void:
	OS.shell_open(meta)
