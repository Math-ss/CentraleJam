extends Node2D
class_name  LevelManager

signal sheep_follow_leader(leader : Mouton, duration : float)
signal goose_follow_leader(durationAVG : float, durationVAR : float)

@export_group("Mouton Management")
@export var moutonTempsMoyen = 0.0
@export var moutonTempsVariance = 0.0
@export var moutonTempsMultiplicateur = 5.0
var sheepArray : Array[Mouton] = []

@export_group("Mouton Management")
@export_subgroup("Attente des cris")
@export var oieAttenteMoyen = 0.0
@export var oieAttenteVariance = 0.0
@export var oieAttenteMultiplicateur = 5.0
@export_subgroup("Reponse aux cris")
@export var oieReponseMoyen = 0.0
@export var oieReponseVariance = 0.0

var gooseArray : Array[Oie] = []

var _timerMouton = -1.0
var _timerGoose = -1.0

## Private functions

func _start_sheep_leading():
    _timerMouton = randfn(moutonTempsMoyen, moutonTempsVariance)
    sheep_follow_leader.emit(sheepArray.pick_random(), _timerMouton)
    _timerMouton *= moutonTempsMultiplicateur

func _start_goose_leading():
    _timerGoose = randfn(moutonTempsMoyen, moutonTempsVariance)
    goose_follow_leader.emit(oieReponseMoyen, oieReponseVariance)

## Specific signals

func _ready():
    _start_sheep_leading()

func _process(delta):
    if _timerMouton > 0.0:
        _timerMouton -= delta
        if _timerMouton <= 0.0 : _start_sheep_leading()
    if _timerGoose > 0.0:
        _timerGoose -= delta
        if _timerGoose <= 0.0 : _start_goose_leading()