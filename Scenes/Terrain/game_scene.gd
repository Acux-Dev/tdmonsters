extends Node3D

@onready var Enemy = preload("res://Scenes/Enemies/TestingEnemies/enemy_bloon_1.tscn")
@export var tower_container: Node3D
@export var enemy_spawn_timer: Timer
@export var enemy_path: Path3D

var enemies_to_spawn = 3
var can_spawn = true

func _ready():
	pass

func _process(delta):
	game_manager()

func _on_player_spawn_tower(tower, raycast):
	if GameManager.building_mode == true:
		if !raycast.is_empty():
			var instance = tower.instantiate()
			instance.position = raycast["position"]
			tower_container.add_child(instance)
	else:
		pass

func game_manager():
	if enemies_to_spawn > 0 and can_spawn:
		enemy_spawn_timer.start()
		
		var newEnemy = Enemy.instantiate()
		enemy_path.add_child(newEnemy)
		enemies_to_spawn -= 1
		can_spawn = false

func _on_enemy_spawn_timer_timeout():
	can_spawn = true
