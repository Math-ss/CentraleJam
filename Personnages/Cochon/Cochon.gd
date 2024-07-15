extends Animal
class_name Cochon

enum ModeMud {DISABLE, ROLLING, DISAPPEARING}

@export_group("Roulade dans la boue")
@export var tempsMoyen : float = 500000000
@export var tempsVariance : float = 0.0
@export var palierVisibilite : float = 0.2

var _rdM_mode : ModeMud = ModeMud.DISABLE
var _rdM_remaining : float = 0.0
var _rdM_total : float = 0.0

## Private functions

func _renew_mud():
    #_mvtB_mode = ModeBrownien.DISABLE
    velocity = Vector2.ZERO

    _rdM_mode = ModeMud.ROLLING
    _rdM_remaining = randfn(tempsMoyen, tempsVariance)
    _rdM_total = _rdM_remaining

    $"AnimatedSprite2D-Mud".visible = true
    #$AnimatedSprite2D.play(&"MudRoll")

## Public functions

func stand_idle(direction : Vector2 = Vector2.ZERO):
    $"AnimatedSprite2D-Mud".frame_progress = $"AnimatedSprite2D".frame_progress
    $"AnimatedSprite2D-Mud".play(&"Idle")
    super(direction)

func walk_and_slide(direction : Vector2 = velocity.normalized()) -> bool:
    $"AnimatedSprite2D-Mud".frame_progress = $"AnimatedSprite2D".frame_progress
    $"AnimatedSprite2D-Mud".play(&"Walk")
    return super(direction)

func start_rd_behavior():
    super()
    _renew_mud()

## Specific signals

func _ready():
    super()

func _process(delta):
    super(delta)

    if _rdM_mode == ModeMud.DISAPPEARING:
        $"AnimatedSprite2D-Mud".modulate.a = _rdM_remaining / _rdM_total
        _rdM_remaining -= delta

        if _rdM_remaining / _rdM_total < palierVisibilite:
            _renew_mud()

func _on_animated_sprite_2d_animation_finished():
    if _rdM_mode == ModeMud.ROLLING :
        $"AnimatedSprite2D-Mud".visible = true
        _renew_brownien()
        _rdM_mode = ModeMud.DISAPPEARING
