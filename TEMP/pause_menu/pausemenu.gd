extends VBoxContainer
signal music
signal sound_effect

func on_music_button_pressed():
	music.emit()

func on_sound_effect_button_pressed():
	sound_effect.emit()

func on_back_button_pressed():
	get_tree().paused = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
