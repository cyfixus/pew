extends Node

var asteroid = preload("res://game/scenes/Asteroid.tscn")
var explosion = preload("res://game/scenes/Explosion.tscn")
var enemy = preload("res://game/scenes/Enemy.tscn")
onready var spawns = get_node("spawn_locations")
onready var asteroid_container = get_node("asteroid_container")
onready var explosions = get_node("explosions")
onready var HUD = get_node("HUD")
onready var player = get_node("Player")
onready var enemy_timer = get_node("enemy_timer")


func _ready():
	set_process(true)
	get_node("music").play()
	player.connect("explode", self, "explode_player")
	begin_next_level()
		
func begin_next_level():
	Global.level += 1
	enemy_timer.stop()
	enemy_timer.set_wait_time(rand_range(0,5))
	enemy_timer.start()
	HUD.show_message("Wave %s" % Global.level)
	for i in range(Global.level):
		spawn_asteroid("big", spawns.get_child(i).get_pos(),
					Vector2(0, 0))
func _process(delta):
	HUD.update(player)
	if !asteroid_container.get_child_count():
		begin_next_level()
func spawn_asteroid(size, pos, vel):
	var a = asteroid.instance()
	asteroid_container.add_child(a)
	a.connect("explode", self, "explode_asteroid")
	a.init(size, pos, vel)
	
func explode_asteroid(size, pos, vel, hit_vel):
	var newsize = Global.break_pattern[size]
	if newsize:
		for offset in [-1, 1]:
			var newpos = pos + hit_vel.tangent().clamped(100) * offset
			var newvel = (vel + hit_vel.tangent() * offset) * 0.9
			spawn_asteroid(newsize, newpos, newvel)
	var expl = explosion.instance()
	add_child(expl)
	expl.set_pos(pos)
	expl.play()
	explosions.play("expl1")
	
func explode_player():
	player.disable()
	var expl = explosion.instance()
	add_child(expl)
	expl.set_pos(player.pos)
	expl.scale(Vector2(1.5, 1.5))
	expl.play()
	explosions.play("expl1")
	HUD.show_message("Game Over")
	get_node("reset_timer").start()

func explode_enemy(pos):
	var expl = explosion.instance()
	add_child(expl)
	expl.set_pos(pos)
	expl.play()
	
func _on_reset_timer_timeout():
	Global.new_game("res://game/scenes/Main.tscn")


func _on_enemy_timer_timeout():
	var e = enemy.instance()
	add_child(e)
	e.target = player
	e.connect("explode", self, "explode_enemy")
	enemy_timer.set_wait_time(rand_range(0, 5))
	enemy_timer.start()
