extends Node3D

@export var enemy: PackedScene
@onready var timer := $Timer
@onready var scene_root := get_parent()
@onready var waves := $Waves.get_children()

var enemies_to_spawn := 0
var enemies_spawned := 0
var enemies_killed := 0


func _ready():
	start_next_wave()


func start_next_wave():

	if waves:
		var current_wave := waves.pop_front() as Wave
		print('Start wave:', current_wave)

		enemies_to_spawn = current_wave.enemy_count
		timer.wait_time = current_wave.interval
		timer.start()


func _on_Enemy_health_depleted():
	enemies_killed += 1
	print("Killed: ", enemies_killed, "of ", enemies_spawned)


func _on_Timer_timeout():
	if enemies_to_spawn:
		var set_enemy : Enemy = enemy.instantiate()
		var stats : Stats = set_enemy.get_node('Stats');
		stats.connect("health_depleted",Callable(self,'_on_Enemy_health_depleted'))
		scene_root.add_child(set_enemy)
		enemies_spawned+=1
		enemies_to_spawn-=1
	else:
		if enemies_killed == enemies_spawned:
			start_next_wave()
