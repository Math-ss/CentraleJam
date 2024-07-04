extends Sprite
class_name Animal

enum ModeBrownien {DISABLE, WALK, IDLE}

@export_group("Mouvement brownien")
@export var pourcentageStatique : float = 0.2
@export var distanceMoyenne : float = 50
@export var distanceVariance : float = 5

var _mvtB_mode : ModeBrownien = ModeBrownien.WALK
var _mvtB_remaining = 0.0

##Private methods

func _renew_brownien():
    _mvtB_mode = ModeBrownien.WALK if randf() > pourcentageStatique else ModeBrownien.IDLE        
    _mvtB_remaining = randfn(distanceMoyenne, distanceVariance) / vitesse
    velocity = vitesse * Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized()

func _rebounce_descartes(collision : KinematicCollision2D):
    var normal = collision.get_normal().normalized()
    velocity = velocity - 2 * normal.dot(velocity) * normal #Mathématical reflexion lol

## Public methods

func start_mvt_brownien():
    _renew_brownien()

func stop_mvt_brownien():
    _mvtB_mode = ModeBrownien.DISABLE

## Specific signals

func _process(delta):
    if _mvtB_mode != ModeBrownien.DISABLE :
        _mvtB_remaining -= delta
        
        if _mvtB_mode == ModeBrownien.WALK &&  walk_and_slide():
            _rebounce_descartes(get_last_slide_collision())
        elif _mvtB_mode == ModeBrownien.IDLE:
            stand_idle(velocity)
        
        if _mvtB_remaining < 0.0: _renew_brownien()