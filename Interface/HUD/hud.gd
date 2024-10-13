extends CanvasLayer
signal start_game
signal open_settings
signal playpause
signal active_competence

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func playpause_func():
	playpause.emit()
	get_tree().paused = true

func show_game_over():
	show_message("Game Over")
	await $MessageTimer.timeout
	$ScoreLabel.hide()
	$TimeLabel.hide()
	$BestScoreLabel.show()
	$StartButton.show()
	$CompetenceButton.hide()
	$PlayPauseButton.hide()
	$SettingsButton.show()

func update_score(score):
	$ScoreLabel.text = str(score)
func update_time_left_printed():
	$TimeLabel.text = str($TimeLeft.time_left)

func _on_start_button_pressed():
	$StartButton.hide()
	$ScoreLabel.show()
	$TimeLabel.show()
	$BestScoreLabel.hide()
	$CompetenceButton.show()
	$PlayPauseButton.show()
	$SettingsButton.hide()
	start_game.emit()

func _on_competence_button_pressed():
	active_competence.emit()

func _on_settings_button_pressed():
	playpause_func()
	open_settings.emit()

func _on_message_timer_timeout():
	$Message.hide()

# Called when the node enters the scene tree for the first time.
func _ready():
	$PlayPauseButton.set_button_icon(load("path"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
