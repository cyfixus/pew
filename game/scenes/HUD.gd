extends CanvasLayer

func _ready():
	set_process_input(true)
	
func _input(event):
	if event.is_action_pressed("ui_pause"):
		Global.paused = !Global.paused
		get_tree().set_pause(Global.paused)
		get_node("pause_panel").set_hidden(!Global.paused)
		get_node("message").set_hidden(Global.paused)

func update(player):
	update_shield(player.shield_level)
	get_node("score").set_text(str(Global.score))
	
func update_shield(shield_level):
	var color = "green"
	if shield_level < 40:
		color = "red"
	elif shield_level < 70:
		color = "yellow"
	var texture = load("res://assets/sprites/barHorizontal_%s_mid 200.png" % color)
	get_node("shield_bar").set_progress_texture(texture)
	get_node("shield_bar").set_value(shield_level)


func show_message(text):
	get_node("message").set_text(text)
	get_node("message").show()
	get_node("message_timer").start()
	
func _on_mesage_timer_timeout():
	get_node("message").hide()
	get_node("message").set_text("")
