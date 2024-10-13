extends Control

@onready var player : Joueur = get_parent()

func _process(_delta):
    rotation = -get_parent().rotation

func _on_button_pressed(costume : Joueur.Costume):
    visible = false
    player.switch_costume(costume)

func _on_button_cow_pressed():
    _on_button_pressed(Joueur.Costume.COW)

func _on_button_pig_pressed():
    _on_button_pressed(Joueur.Costume.PIG)

func _on_button_sheep_pressed():
    _on_button_pressed(Joueur.Costume.SHEEP)

func _on_button_goose_pressed():
    _on_button_pressed(Joueur.Costume.GOOSE)

func _on_button_raw_pressed():
    _on_button_pressed(Joueur.Costume.RAW)
