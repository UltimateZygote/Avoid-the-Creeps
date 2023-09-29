extends Node

@export var mob_scene: PackedScene
var score = 0
var save_path = "res://gamesave.txt"
var highscore

func _ready():
	load_highscore()
	$HUD.update_highscore(highscore)

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	load_highscore()
	if score > highscore:
		save_score()
		$HUD.update_highscore(score)
	$HUD.show_game_over(score, highscore)
	$Music.stop()
	$DeathSound.play()
	
	
func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	get_tree().call_group("mobs", "queue_free")
	$Music.play()



func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()


func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)


func _on_mob_timer_timeout():
	var mob = mob_scene.instantiate()
	
	var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
	mob_spawn_location.progress_ratio = randf()
	
	var direction = mob_spawn_location.rotation + PI / 2
	
	mob.position = mob_spawn_location.position
	
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	add_child(mob)
	
func save_score():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(score)

func load_highscore():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		highscore = file.get_var()
	else:
		print("file not found")
		
