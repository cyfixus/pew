extends Area2D

signal explode

export var rot_speed = 2.6
export var thrust = 500
export var max_vel = 400
export var friction = 0.8
export (PackedScene) var bullet
onready var bullet_container = get_node("bullet_container")
onready var gun_timer = get_node("gun_timer")
onready var shoot_sounds = get_node("shoot")

var screen_size = Vector2()
var rot = 0
var pos = Vector2()
var vel = Vector2()
var acc = Vector2()

var shield_level = Global.shield_max
var shield_up = true

func _ready():
	add_to_group("players")
	screen_size = get_viewport_rect().size
	pos = screen_size/2
	set_pos(pos)
	set_process(true)
	
func _process(delta):
	if shield_up:
		shield_level = min(shield_level + Global.shield_regen * delta, 100)
		if shield_level <= 0 and shield_up:
			shield_up = false
			shield_level = 0
			get_node("shield").hide()
		
	if Input.is_action_pressed("player_shoot"):
		if !gun_timer.get_time_left():
			shoot()
	if Input.is_action_pressed("ui_left"):
		rot += rot_speed * delta
	if Input.is_action_pressed("ui_right"):
		rot -= rot_speed * delta
	if Input.is_action_pressed("ui_up"):
		acc = Vector2(thrust, 0).rotated(rot)
		get_node("exhaust").show()
	else:
		acc = Vector2(0, 0)
		get_node("exhaust").hide()
	acc += vel * -friction
	vel += acc * delta
	pos += vel * delta
	if pos.x > screen_size.width:
		pos.x = 0
	if pos.x < 0:
		pos.x = screen_size.width
	if pos.y > screen_size.height:
		pos.y = 0
	if pos.y < 0:
		pos.y = screen_size.height
	set_pos(pos)
	set_rot(rot - PI/2)

func shoot():
	gun_timer.start()
	var b = bullet.instance()
	bullet_container.add_child(b)
	b.start_at(get_rot(), get_node("muzzle").get_global_pos(), vel)
	shoot_sounds.play("laser2")

func _on_Player_body_enter( body ):
	if is_hidden():
		return
	if body.get_groups().has("asteroids"):
		if shield_up:
			body.explode(vel)
			damage(Global.ast_damage[body.size])
	if body.get_groups().has("lasers"):
		if shield_up:
			damage(20)
		else:
			emit_signal("explode")
			
func damage(amount):
	if shield_up:
		shield_level -= amount
	else:
		disable()
		emit_signal("explode")
func disable():
	hide()
	set_process(false)
