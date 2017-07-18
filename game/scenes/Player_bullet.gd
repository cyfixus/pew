extends Area2D

var vel = Vector2()
var screen_size = Vector2()
export var speed = 1000

func _ready():
	add_to_group("lasers")
	screen_size = get_viewport_rect().size
	set_fixed_process(true)

func start_at(dir, pos, v):
	set_rot(dir)
	set_pos(pos)
	vel = Vector2(speed, 0).rotated(dir + PI/2)
	
func _fixed_process(delta):
	var pos = get_pos() + vel * delta
	if pos.x > screen_size.width:
		pos.x = 0
	if pos.x < 0:
		pos.x = screen_size.width
	if pos.y > screen_size.height:
		pos.y = 0
	if pos.y < 0:
		pos.y = screen_size.height
	set_pos(pos)
		


func _on_lifetime_timeout():
	queue_free()

func _on_Player_bullet_body_enter( body ):
	if body.get_groups().has("asteroids"):
		queue_free()
		print(body.explode(vel.normalized()))


func _on_Player_bullet_area_enter( area ):
	if area.get_groups().has("enemies") || area.get_groups().has("players"):
		queue_free()
		area.damage(Global.bullet_damage)
