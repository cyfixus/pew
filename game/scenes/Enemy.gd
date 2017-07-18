extends Area2D

signal explode
signal pulse_timeout

var bullet = preload("res://game/scenes/enemy_bullet.tscn")
onready var paths = get_node("enemy_paths")
onready var bullet_container = get_node("bullet_container")
onready var shoot_timer = get_node("shoot_timer")
onready var shoot_sound = get_node("shoot")
onready var anim = get_node("Anim")

var path
var follow
var remote
var speed = 250
var accuracy = 0.1
var target = null
var health = Global.enemy_health
var pulse_timer

func _ready():
	pulse_timer = Timer.new()
	add_child(pulse_timer)
	pulse_timer.connect("timeout", self, "emit_pulse_timeout")
	add_to_group("enemies")
	set_process(true)
	randomize()
	path = paths.get_children()[randi() % paths.get_child_count()]
	follow = PathFollow2D.new()
	path.add_child(follow)
	follow.set_loop(false)
	remote = Node2D.new()
	follow.add_child(remote)
	shoot_timer.set_wait_time(1.5)
	shoot_timer.start()
	
func _process(delta):
	follow.set_offset(follow.get_offset() + speed * delta)
	set_pos(remote.get_global_pos())
	if follow.get_unit_offset() > 1:
		queue_free()


func shoot1():
	var dir = get_global_pos() - target.get_global_pos()
	var b = bullet.instance()
	bullet_container.add_child(b)
	b.start_at(dir.angle() + rand_range(-accuracy, accuracy), get_global_pos())

func shoot3():
	var dir = get_global_pos() - target.get_global_pos()
	for a in [-0.1, 0, 0.1]:
		var b = bullet.instance()
		bullet_container.add_child(b)
		b.start_at(dir.angle() + a, get_global_pos())
func _on_shoot_timer_timeout():
	if target.is_visible():
		shoot_pulse(3, 0.2)
	
func shoot_pulse(n, delay):
	for i in range(n):
		shoot1()
		pulse_delay(delay)
		yield(self, "pulse_timeout")
		
func pulse_delay(delay):
	pulse_timer.set_wait_time(delay)
	pulse_timer.set_timer_process_mode(0)
	pulse_timer.start()
	
func emit_pulse_timeout():
	emit_signal("pulse_timeout")
	
func damage(amount):
	health -= amount
	anim.play("hit")
	if health <= 0:
		Global.score += Global.enemy_points
		emit_signal("explode", get_global_pos())
		queue_free()
