extends Node3D

@onready var tower_container = $TowerContainer
@onready var Enemy = preload("res://Scenes/Enemies/TestingEnemies/enemy_bloon_1.tscn")

var enemies_to_spawn = 3
var can_spawn = true

func _ready():
	pass

func _process(delta):
	game_manager()

func _on_player_spawn_tower(tower, raycast):
	if !raycast.is_empty():
		var instance = tower.instantiate()
		instance.position = raycast["position"]
		tower_container.add_child(instance)

func game_manager():
	if enemies_to_spawn > 0 and can_spawn:
		$EnemySpawnTimer.start()
		
		var newEnemy = Enemy.instantiate()
		$EnemyPath.add_child(newEnemy)
		enemies_to_spawn -= 1
		can_spawn = false

func _on_enemy_spawn_timer_timeout():
	can_spawn = true
