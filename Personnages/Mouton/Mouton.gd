extends Animal
class_name Mouton

static var _sheep_in_scene : Array[Mouton] = []

var _mvtF_enable = false
var _mvtF_leader : Mouton = null
var _mvtF_remaining : float = 0.0

signal follow_leader(leader : Mouton, duration : float)

func _enter_tree():
    for sheep in _sheep_in_scene:
        sheep.follow_leader.connect(_on_follow_leader)
    _sheep_in_scene.append(self)

func _exit_tree():
    _sheep_in_scene.remove_at(_sheep_in_scene.find(self))
    for sheep in _sheep_in_scene:
        sheep.follow_leader.disconnect(_on_follow_leader)

func _process(delta):
    super(delta)

    if _mvtF_enable:
        velocity = vitesse * (_mvtF_leader.global_position - global_position).normalized()
        _mvtB_remaining -= delta

        if walk_and_slide() && not (get_last_slide_collision().get_collider() is Sprite) :
            _rebounce_descartes(get_last_slide_collision())

        if _mvtF_remaining < 0.0 :
            _mvtF_enable = false
            start_rd_behavior()

func _on_follow_leader(leader : Mouton, duration : float):
    stop_rd_behavior() #TODO : New sound pattern ?

    _mvtF_enable = true
    _mvtF_leader = leader
    _mvtF_remaining = duration

#TODO : How to trigger this signal ??