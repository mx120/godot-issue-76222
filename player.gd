extends CharacterBody2D
signal health_changed

var MAX_SPEED = 1.5
var ACCELERATION = 1
var motion = Vector2.ZERO
var cur_anim = null
var bullet_class = preload("res://bullet.tscn")
var health
var enemy_class = preload("res://enemy.tscn")
var health_bar
var old_health
var coolDownActive


func _ready():
	cur_anim = "still_down"
	$/root/Main/enemySpawnTimer.start()
	health = 100
	health_bar = $ProgressBar
	old_health = 100
	coolDownActive = false



	
	

func _process(_delta):
	if(health != old_health):
		emit_signal("health_changed")
	if(Input.is_action_pressed("shoot") and coolDownActive == false):
		shoot()
		coolDownActive = true
		$bulletCoolDown.start()
	
	
func _physics_process(_delta):
	var axis = get_movement_vector()
	if (axis == Vector2.ZERO):
		apply_animation()
		apply_friction(ACCELERATION)
	else:
		apply_motion(axis * ACCELERATION)

	var collision_info = move_and_collide(motion)





func get_movement_vector():
	var axis = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	get_animation(axis.x, axis.y)
	apply_animation()
	return axis.normalized()




func apply_friction(amount):
	if(motion.length() > amount):
		motion -= motion.normalized() * amount
	else:
		motion = Vector2.ZERO 




func apply_motion(amount):
	motion += amount
	motion = motion.limit_length(MAX_SPEED)




func get_animation(axis_x, axis_y):
	# refactor the following code:
	#-----------------------------------
	if(axis_x == 1):
		cur_anim = "moving_right"
	elif(axis_x == -1):
		cur_anim = "moving_left"
	
	if(axis_y == 1):
		cur_anim = "moving_down"
	elif(axis_y == -1):
		cur_anim = "moving_up"
	if(axis_x == 0 && axis_y == 0):
		if(cur_anim == "moving_right"):
			cur_anim = "still_right"
		elif(cur_anim == "moving_left"):
			cur_anim = "still_left"
		elif(cur_anim == "moving_up"):
			cur_anim = "still_up"
		elif(cur_anim == "moving_down"):
			cur_anim = "still_down" 
	# -----------------------------
	
	
	
	
func apply_animation():

	$AnimatedSprite2D.play(cur_anim)




func shoot():
		var bullet = bullet_class.instantiate()
		$/root/Main.add_child(bullet)
		bullet.global_position = self.global_position
		#print("position of bullet: ", get_node("/root/Main/bullet").global_position, "position of player: ", self.global_position)
		bullet.fire(get_local_mouse_position())
	
		





func _on_enemy_spawn_timer_timeout():
	var randNum = RandomNumberGenerator.new()
	randNum.randomize()
	$Path2D/PathFollow2D.progress_ratio = randNum.randf()
	
	var enemy = enemy_class.instantiate()
	$/root/Main.add_child(enemy)
	enemy.global_position = $Path2D/PathFollow2D/Marker2D.global_position






func _on_health_changed():
	health_bar.value = health
	old_health = health
	$bloodSplatter.emitting = true




func _on_bullet_cool_down_timeout():
	coolDownActive = false
