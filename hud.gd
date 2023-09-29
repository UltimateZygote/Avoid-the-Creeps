extends CanvasLayer

signal start_game
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()


func show_game_over(score, highscore):
	show_message("Game Over")
	# Wait until the MessageTimer has counted down.
	if score >= highscore:
		$HighScoreLabel.show()
	await $MessageTimer.timeout
	$HighScoreLabel.show()
	$Message.text = "Dodge the\nCreeps!"
	$Message.show()
	# Make a one-shot timer and wait for it to finish.
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()
	
func update_score(score):
	$ScoreLabel.text = str(score)
	
func update_highscore(score):
	$HighScoreLabel.text = "Highscore: " + str(score)


func _on_message_timer_timeout():
	$Message.hide()


func _on_start_button_pressed():
	$HighScoreLabel.hide()
	$StartButton.hide()
	start_game.emit()
