extends TButton


func _on_toggled(toggled_on: bool) -> void:
	if toggled_on:
		get_tree().paused = true
		Global.fade_black(0.6, 0.5)
		%Controls_Menu.visible = true # Note - Setting visibility like this is quite abrupt
		$RichTextLabel.text = "Hide Controls"
	else:
		get_tree().paused = false
		Global.fade_black(0, 0.5)
		%Controls_Menu.visible = false
		$RichTextLabel.text = "Show Controls"
