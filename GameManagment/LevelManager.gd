extends Node2D
class_name LevelManager

signal sheep_follow_leader_start(leader : Sprite, duration : float)
signal sheep_follow_leader_stop(leader : Sprite)
signal goose_repeat_leader(durationAVG : float, durationVAR : float)

@export_group("HUD Management")
@export var launchAbility           : CompressedTexture2D
@export var launchAbilityPressed    : CompressedTexture2D
@export var stopAbility             : CompressedTexture2D
@export var stopAbilityPressed      : CompressedTexture2D
@export var loadingAbility          : CompressedTexture2D
@export var usingAbility            : CompressedTexture2D
@export var disabledAbility         : CompressedTexture2D

@export_group("Mouton Management")
@export var moutonTempsMoyen = 0.0
@export var moutonTempsVariance = 0.0
@export var moutonTempsMultiplicateur = 5.0
var sheepArray : Array[Mouton] = []

@export_group("Oie Management")
@export_subgroup("Attente des cris")
@export var oieAttenteMoyen = 0.0
@export var oieAttenteVariance = 0.0
@export var oieAttenteMultiplicateur = 5.0
@export_subgroup("Reponse aux cris")
@export var oieReponseMoyen = 0.0
@export var oieReponseVariance = 0.0

var gooseArray : Array[Oie] = []

var _timerMouton = -1.0
var _timerOie = -1.0

## Private functions

func _start_sheep_leading():
    _timerMouton = randfn(moutonTempsMoyen, moutonTempsVariance)
    sheep_follow_leader_start.emit(sheepArray.pick_random(), _timerMouton)
    _timerMouton *= moutonTempsMultiplicateur

func _start_goose_leading():
    _timerOie = randfn(oieAttenteMoyen, oieAttenteVariance)
    goose_repeat_leader.emit(oieReponseMoyen, oieReponseVariance)

## Public functions

func setFollowSystemState(sheepState : bool, gooseState : bool = true):
    if gooseState and _timerOie < 0.0: _start_goose_leading()
    if not gooseState and _timerOie > 0.0 : _timerOie = -1.0
    if sheepState and _timerMouton < 0.0: _start_sheep_leading()

    if not sheepState and _timerMouton > 0.0 :
        _timerMouton = -1.0
        sheep_follow_leader_stop.emit()

func getPlayer() -> Joueur : return $Joueur

func getHUD() -> CanvasLayer : return $HUD

func setAbilityButtonMode(mode : Joueur.AbilityButtonMode):
    match mode:
        Joueur.AbilityButtonMode.USABLE:
            $HUD/AbilityButton.visible = true
            $HUD/AbilityButton.disabled = false
            $HUD/AbilityButton.texture_normal = launchAbility
        Joueur.AbilityButtonMode.STOPPABLE:
            $HUD/AbilityButton.visible = true
            $HUD/AbilityButton.disabled = false
            $HUD/AbilityButton.texture_normal = stopAbility
        Joueur.AbilityButtonMode.USING:
            $HUD/AbilityButton.visible = true
            $HUD/AbilityButton.disabled = true
            $HUD/AbilityButton.texture_disabled = usingAbility
        Joueur.AbilityButtonMode.LOADING:
            $HUD/AbilityButton.visible = true
            $HUD/AbilityButton.disabled = true
            $HUD/AbilityButton.texture_disabled = loadingAbility
        Joueur.AbilityButtonMode.DISABLE:
            $HUD/AbilityButton.visible = true
            $HUD/AbilityButton.disabled = true
            $HUD/AbilityButton.texture_disabled = disabledAbility
        Joueur.AbilityButtonMode.INVISIBLE:
            $HUD/AbilityButton.visible = false

## Specific signals

func _ready():
    _start_sheep_leading()

func _process(delta):
    # Following systems' timer
    if _timerMouton > 0.0:
        _timerMouton -= delta
        if _timerMouton <= 0.0 : _start_sheep_leading()
    if _timerOie > 0.0:
        _timerOie -= delta
        if _timerOie <= 0.0 : _start_goose_leading()