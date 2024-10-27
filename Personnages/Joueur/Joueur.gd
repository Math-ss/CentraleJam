extends Sprite
class_name Joueur

signal player_died(reason : String)
signal player_switch_costume(previous : Costume, new : Costume)

enum Costume {RAW, PIG, COW, GOOSE, SHEEP}
enum AbilityButtonMode {USABLE, STOPPABLE, USING, LOADING, DISABLE, INVISIBLE}

@export_group("Gestion des capacités speciales")
@export var attenteVache 		: float = 5.0
@export var attenteOie 			: float = 5.0

@export_subgroup("Cochon")
@export var attenteCochon 		: float = 5.0
@export var dureeDashCochon		: float = 5.0
@export var multVitesseCochon	: float = 2.0

@export_subgroup("Mouton")
@export var attenteMouton 		: float = 5.0
@export var dureeSuiviMouton 	: float = 5.0


var _costume_child : Array[NodePath] = [^"AudioStreamPlayer2D", ^"CollisionShape2D", ^"AnimatedSprite2D"]
var _costumes : Array[Node2D] = [null, null, null, null, null]
var _current_costume : Costume = Costume.RAW

var _speA_enable = false
var _speA_cooldowns : Array[float] = [0.0, 0.0, 0.0, 0.0, 0.0]
var _speA_input = true
var _speA_dir = Vector2.ZERO

## Private methods
func _launch_specific_ability_cooldown():
	if _current_costume == Costume.RAW :
		getLevelManager().setAbilityButtonMode(AbilityButtonMode.INVISIBLE)
		$"SpeTimer".stop()
	else:
		getLevelManager().setAbilityButtonMode(AbilityButtonMode.LOADING)
		$"SpeTimer".start(_speA_cooldowns[_current_costume])

func _enable_specific_ability():
	_speA_enable = true
	match _current_costume :		
		Costume.PIG :
			_speA_dir = (get_global_mouse_position() - get_global_transform().get_origin()).normalized()
			_speA_input = false #Block input from the player
			$"SpeTimer".start(dureeDashCochon)
			getLevelManager().setAbilityButtonMode(AbilityButtonMode.USING)

		Costume.COW :
			#TODO : Find a specific ability
			pass

		Costume.GOOSE :
			_walkAnim = &"Fly"
			_idleAnim = &"Fly"
			collision_layer = 2
			collision_mask = 2
			z_index = 5 #If specific overlapping need to be set in the scene
			getLevelManager().setAbilityButtonMode(AbilityButtonMode.STOPPABLE)

		Costume.SHEEP :
			$AudioStreamPlayer2D.play()
			getLevelManager().sheep_follow_leader_start.emit(self, INF) #ENH : Maybe call after the sheep stop screaming ?
			$"SpeTimer".start(dureeSuiviMouton)
			getLevelManager().setAbilityButtonMode(AbilityButtonMode.USING)
			getLevelManager().setFollowSystemState(false, true)

func _disable_specific_ability(force : bool = false) -> bool:
	if not _speA_enable : return false

	match _current_costume :
		Costume.COW :
			pass

		Costume.GOOSE :
			_walkAnim = &"Walk"
			_idleAnim = &"Idle"
			collision_layer = 1
			collision_mask = 1
			z_index = 0
			_speA_enable = false

		Costume.PIG :
			if force :
				$SpeTimer.stop()
				_speA_dir = Vector2.ZERO
				_speA_input = true
				_speA_enable = false

		Costume.SHEEP :
			if force :
				$SpeTimer.stop()
				getLevelManager().sheep_follow_leader_stop.emit()
				getLevelManager().setFollowSystemState(false, true)
				_speA_enable = false

	return _speA_enable

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
	#Stops current the working costume
	assert(not _disable_specific_ability(true), "DEBUG : Ability not correctly stopped") # For DEBUG only

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

	#Start the new costume
	player_switch_costume.emit(_current_costume, new_costume)
	_current_costume = new_costume
	_launch_specific_ability_cooldown()

## Specific signals

#TODO : Setup input management
func _unhandled_key_input(event):
	if event.is_action_pressed("make_noise"):
		$AudioStreamPlayer2D.play()
		switch_costume((_current_costume + 1) % 5)

func _ready():
	_costumes[Costume.RAW] = Node2D.new() #When a change occur, children are transfered...
	_speA_cooldowns[Costume.RAW] = INF
	_costumes[Costume.PIG]   = _create_costume(preload("res://Personnages/Cochon/Cochon.tscn")) 
	_speA_cooldowns[Costume.PIG] = attenteCochon
	_costumes[Costume.COW]   = _create_costume(preload("res://Personnages/Vache/Vache.tscn"))
	_speA_cooldowns[Costume.COW] = attenteVache
	_costumes[Costume.GOOSE] = _create_costume(preload("res://Personnages/Oie/Oie.tscn"))
	_speA_cooldowns[Costume.GOOSE] = attenteOie
	_costumes[Costume.SHEEP] = _create_costume(preload("res://Personnages/Mouton/Mouton.tscn"))
	_speA_cooldowns[Costume.SHEEP] = attenteMouton

	switch_costume(Costume.RAW)

func _process(_delta):
	if _speA_input:
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

	if  _current_costume == Costume.PIG && _speA_enable:
		velocity = multVitesseCochon * vitesse * _speA_dir
		walk_and_slide()

func _on_selection_button_pressed():
	$PlayerSelection.visible = true

func _on_spe_timer_timeout(): 
	if _speA_enable : # When specific abilities with determined time ends
		_disable_specific_ability(true)
		_launch_specific_ability_cooldown()

	else: # When the cooldown of the ability ends
		getLevelManager().setAbilityButtonMode(AbilityButtonMode.USABLE)

func _on_ability_button_pressed():
	if _speA_enable : 
		_disable_specific_ability()
		_launch_specific_ability_cooldown()
	else : 
		_enable_specific_ability()
