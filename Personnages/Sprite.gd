extends CharacterBody2D
class_name Sprite

enum mode_brownien {DISABLE, WALK, IDLE}

@export var vitesse : float = 10

@export_group("Mouvement brownien")
@export var pourcentageStatique : float = 0.2
@export var distanceMoyenne : float = 50
@export var distanceVariance : float = 5

var _mvtB_mode : mode_brownien = mode_brownien.WALK
var _mvtB_remaining = 0.0
var _mvtB_direction = Vector2.ZERO

##Private method

func _renew_brownien():
    _mvtB_mode = mode_brownien.WALK if randf() > pourcentageStatique else mode_brownien.IDLE
    _mvtB_direction = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized()        
    _mvtB_remaining = randfn(distanceMoyenne, distanceVariance)

func _rebounce_descartes(collision : KinematicCollision2D):
    var normal = collision.get_normal().normalized()
    _mvtB_direction = _mvtB_direction - 2 * normal.dot(_mvtB_direction) * normal #Mathématical reflexion lol

##Protected method

func start_mvt_brownien():
    _renew_brownien()

func stop_mvt_brownien():
    _mvtB_mode = mode_brownien.DISABLE

##Specific signals

func _process(delta):
    if _mvtB_mode != mode_brownien.DISABLE :
        $AnimatedSprite2D.play(&"Walk" if _mvtB_mode == mode_brownien.WALK else &"Idle")
        _mvtB_remaining -= vitesse*delta #Just theoritical distance, collision aren't taken in account
        rotation = _mvtB_direction.angle() + PI/2

        if _mvtB_mode == mode_brownien.WALK:
            velocity = vitesse * _mvtB_direction
            if move_and_slide() : _rebounce_descartes(get_last_slide_collision())
        
        if _mvtB_remaining < 0.0: _renew_brownien()

