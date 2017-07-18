extends Node

#game settings
var game_over = false
var score = 0
var level = 0
var paused = false
var current_scene = null
var new_scene = null

#player settings
var shield_max = 100
var shield_regen = 10
var bullet_damage = 10

#enemy settings
var enemy_bullet_damage = 10
var enemy_health = 30
var enemy_points = 100

#asteroid settings
var break_pattern = {'big': 'med',
                     'med': 'sm',
					 'sm': 'tiny',
					 'tiny': null}
var ast_damage = {'big': 40,
                     'med': 20,
					 'sm': 15,
					 'tiny': 5}
var ast_points = {'big': 5,
                     'med': 10,
					 'sm': 15,
					 'tiny': 20}
					

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)
	
func goto_scene(path):
	var s = ResourceLoader.load(path)
	new_scene = s.instance()
	get_tree().get_root().add_child(new_scene)
	get_tree().set_current_scene(new_scene)
	current_scene.queue_free()
	current_scene = new_scene
	
func new_game(path):
	game_over = false
	score = 0
	level = 0
	goto_scene(path)