extends CharacterBody2D
class_name Sprite

@export var vitesse : float = 10

@export_group("Mouvement brownien")
@export var distanceMoyenne : float = 50
@export var distanceVariance : float = 5

var _mvtB_enable = true
var _mvtB_remaining = 0.0
var _mvtB_direction = Vector2.ZERO

func _renew_brownien():
    _mvtB_remaining = randfn(distanceMoyenne, distanceVariance)
    _mvtB_direction = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized()

func _rebounce_descartes(collision : KinematicCollision2D):
    var normal = collision.get_normal().normalized()
    _mvtB_direction = _mvtB_direction - 2 * normal.dot(_mvtB_direction) * normal #Mathématical reflexion lol

func start_mvt_brownien():
    _mvtB_enable = true
    _renew_brownien()

func stop_mvt_brownien():
    _mvtB_enable = false

func _process(delta):
    if _mvtB_enable:
        $AnimatedSprite2D.play("Walk")
        velocity = vitesse * _mvtB_direction
        _mvtB_remaining -= vitesse*delta #Just theoritical distance, collision aren't taken in account

        if move_and_slide() : _rebounce_descartes(get_last_slide_collision())
        if _mvtB_remaining < 0.0: _renew_brownien()








#Déplacement brownien
#Jeu des bonnes anmations
#Interrupteur