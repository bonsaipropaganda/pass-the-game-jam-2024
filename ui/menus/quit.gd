extends Panel


func _on_resume_pressed():
	Global.game_manager.close_quit_menu()


func _on_quit_pressed():
	Global.game_manager.quit()
