extends Animal
class_name Mouton

var _mvtF_enable = false
var _mvtF_leader : Mouton = null
var _mvtF_remaining : float = 0.0

func _enter_tree():
    getLevelManager().sheep_follow_leader.connect(_on_follow_leader)
    getLevelManager().sheepArray.push_back(self)

func _exit_tree():
    getLevelManager().sheep_follow_leader.disconnect(_on_follow_leader)
    getLevelManager().sheepArray.remove_at(getLevelManager().sheepArray.find(self))

func _process(delta):
    super(delta)

    if _mvtF_enable:
        velocity = vitesse * (_mvtF_leader.global_position - global_position).normalized()
        _mvtF_remaining -= delta

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
