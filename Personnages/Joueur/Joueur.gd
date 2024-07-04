extends Sprite
class_name Joueur

signal player_died(reason : String)
signal player_switch_costume(previous : Costume, new : Costume)

enum Costume {RAW, PIG, COW, GOOSE, SHEEP}

var _costume_child : Array[NodePath] = [^"AudioStreamPlayer2D", ^"CollisionShape2D", ^"AnimatedSprite2D"]
var _costumes : Array[Node2D] = [null, null, null, null, null]
var _current_costume : Costume = Costume.RAW

## Private methods

func _create_costume(scene : PackedScene) -> Node2D:
	var costume = Node2D.new()
	var tempScene = scene.instantiate()

	for path in _costume_child:
		var tmp = tempScene.get_node(path)
		tmp.set_owner(null)
		tempScene.remove_child(tmp)
		costume.add_child(tmp)
	
	tempScene.free()
	return costume

## Public methods

func switch_costume(new_costume : Costume):
	#Removing current costume
	for path in _costume_child:
		var tmp = get_node(path)
		remove_child(tmp)
		_costumes[_current_costume].add_child(tmp)

	#Adding new costume
	for path in _costume_child:
		var tmp = _costumes[new_costume].get_node(path)
		_costumes[new_costume].remove_child(tmp)
		add_child(tmp)

	
	player_switch_costume.emit(_current_costume, new_costume)
	_current_costume = new_costume

## Specific signals

#TODO : Specific behavior
func _unhandled_key_input(event):
	if event.is_action_pressed("make_noise"):
		switch_costume((_current_costume + 1) % 5)

func _enter_tree(): #To avoid cyclic depedency
	_costumes[Costume.RAW]   = _create_costume(load("res://Personnages/Joueur/Joueur.tscn"))
	_costumes[Costume.PIG]   = _create_costume(load("res://Personnages/Cochon/Cochon.tscn")) 
	_costumes[Costume.COW]   = _create_costume(load("res://Personnages/Vache/Vache.tscn"))
	_costumes[Costume.GOOSE] = _create_costume(load("res://Personnages/Oie/Oie.tscn"))
	_costumes[Costume.SHEEP] = _create_costume(load("res://Personnages/Mouton/Mouton.tscn"))

func _process(delta):
	if Input.is_action_pressed("forward"):
		velocity = vitesse * (get_global_mouse_position() - get_global_transform().get_origin()).normalized()
		walk_and_slide()
	
	elif Input.is_action_pressed("left"):
		velocity = vitesse * (get_global_mouse_position() - get_global_transform().get_origin()).normalized().rotated(-PI/2)
		walk_and_slide()

	elif Input.is_action_pressed("right"):
		velocity = vitesse * (get_global_mouse_position() - get_global_transform().get_origin()).normalized().rotated(PI/2)
		walk_and_slide()

	elif Input.is_action_pressed("backward"):
		velocity = -vitesse * (get_global_mouse_position() - get_global_transform().get_origin()).normalized()
		walk_and_slide()
	
	else: stand_idle()
