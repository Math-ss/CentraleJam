extends CharacterBody2D
class_name Sprite

@export var vitesse : float = 10

# Movement

func walk_and_slide(direction : Vector2 = velocity.normalized()) -> bool:
    $AnimatedSprite2D.play(&"Walk")
    rotation = direction.angle() + PI/2
    return move_and_slide()

func stand_idle(direction : Vector2 = Vector2.ZERO):
    $AnimatedSprite2D.play(&"Idle")
    if direction != Vector2.ZERO : rotation = direction.angle() + PI/2

#TODO : Sound

