extends Sprite
class_name Animal

enum ModeBrownien {DISABLE, WALK, IDLE}

@export_group("Mouvement brownien")
@export var pourcentageStatique : float = 0.2
@export var distanceMoyenne : float = 50
@export var distanceVariance : float = 5

@export_group("Son aléatoire")
@export var attenteMoyenne : float = 50
@export var attenteVariance : float = 5

var _mvtB_mode : ModeBrownien = ModeBrownien.DISABLE
var _mvtB_remaining = 0.0
var _rdS_enable = false

##Private methods

func _renew_sound():
    _rdS_enable = true
    $SoundTimer.wait_time = randfn(attenteMoyenne, attenteVariance)
    $SoundTimer.start()

func _renew_brownien():
    _mvtB_mode = ModeBrownien.WALK if randf() > pourcentageStatique else ModeBrownien.IDLE        
    _mvtB_remaining = randfn(distanceMoyenne, distanceVariance) / vitesse
    velocity = vitesse * Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized()

func _rebounce_descartes(collision : KinematicCollision2D):
    var normal = collision.get_normal().normalized()
    velocity = velocity - 2 * normal.dot(velocity) * normal #Mathématical reflexion lol

## Public methods

func start_rd_behavior():
    if _mvtB_mode == ModeBrownien.DISABLE:
        _renew_brownien()
        _renew_sound()

func stop_rd_behavior():
    _mvtB_mode = ModeBrownien.DISABLE
    _rdS_enable = false

## Specific signals

func _ready(): 
    start_rd_behavior()

func _process(delta):
    if _mvtB_mode != ModeBrownien.DISABLE :
        _mvtB_remaining -= delta
        
        if _mvtB_mode == ModeBrownien.WALK &&  walk_and_slide():
            _rebounce_descartes(get_last_slide_collision())
        elif _mvtB_mode == ModeBrownien.IDLE:
            stand_idle(velocity)
        
        if _mvtB_remaining < 0.0: _renew_brownien()

func _on_sound_timer_timeout():
    if _rdS_enable : $AudioStreamPlayer2D.play()
    
func _on_audio_stream_player_2d_finished():
    if _rdS_enable : _renew_sound()
