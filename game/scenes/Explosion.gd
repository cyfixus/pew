extends AnimatedSprite

func _on_Explosion_finished():
	queue_free()
