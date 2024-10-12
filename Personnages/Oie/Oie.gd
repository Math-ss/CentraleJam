extends Animal
class_name  Oie

func _enter_tree():
    getLevelManager().goose_repeat_leader.connect(_on_follow_leader)
    getLevelManager().gooseArray.push_back(self)

func _exit_tree():
    getLevelManager().goose_repeat_leader.disconnect(_on_follow_leader)
    getLevelManager().gooseArray.remove_at(getLevelManager().gooseArray.find(self))

func _on_follow_leader(durationAVG : float, durationVAR : float):
    _rdS_enable = false
    $FollowTimer.wait_time = randfn(durationAVG, durationVAR)
    $FollowTimer.start()
	
func _on_follow_timer_timeout():
    _rdS_enable = true
    $AudioStreamPlayer2D.play()
