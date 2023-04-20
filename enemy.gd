extends CharacterBody2D
# member variables
var targetPos
var SPEED = 100
var motion
var anim
var damage
var player
var oriented
var damageDeltForAnim
var health
var timerStopStartBool
var collision_info









func _ready():
	#setting player var to the player node
	player = $/root/Main/Player
	# creating target pos variable to represent target (player's pos)
	targetPos = player.global_position
	# starting the animation distance timer
	$walk_timer.start()
	#setting the variable anim (short for the animation sprite 2d node)
	anim = $AnimatedSprite2D
	# setting damage
	damage = 1
	
	oriented = false
	
	damageDeltForAnim = false
	
	health = 2
	
	timerStopStartBool = true
	
	
	
	
	
	
	
	
	
func _physics_process(delta):
	#if the enemy has a target
	if(targetPos):
		#move
		move(delta)
		targetDistanceCheck()








func move(delta):
	#if it should be moving
	if (anim.animation == "walking" 
	and anim.is_playing() == true 
	and anim.frame == 3
	or  anim.frame == 4
	or  anim.frame == 5):
#		print("should be moving ya boiiiis")
		#setting motion variable to the direction from the enemy's position and the player
		motion = global_position.direction_to(targetPos)
#		print("motion is this, ", motion)
		# moving the player and having the returned value stored in the collision_info variable
		collision_info = move_and_collide(motion * SPEED * delta)
#		print("moving and colliding")
		# reseting the target pos variable to the players positon (this will lead to the enemy's to constantly follow the player)
		targetPos = $/root/Main/Player.global_position
#		print("updating target")
	# if not
	else:
		# stop motion
		motion = Vector2.ZERO
		collision_info = move_and_collide(motion * SPEED * delta)
#		print("motion is null it is not moving")








func play_animation(animation):
	# plays specific animation based on the peramiter 
	$AnimatedSprite2D.play(animation)








func targetDistanceCheck():
	# the distance to the player is less than 13 pixles 
	if(global_position.distance_to(player.global_position) <= 13):
		#orient the enemy relative to the players position (this allows for enemys to be on the other side of the player and still be facing it)
		orientEnemy()
		# stop walk timer
		$walk_timer.stop()
		# if the chomp timer should be active
		if($chomp_timer.is_stopped()):
			#start it
			$chomp_timer.start()
			timerStopStartBool = true
		# if chomp chomp animation is at a stage were the jaw is clamped and it should be doing damage
		checkForAttackReady()
	else:
#		print("player has moved away, should start moving")
		# if chomp timer is on
		if(timerStopStartBool == true):
			#stop it
			$chomp_timer.stop()
			# start the walk timer
			$walk_timer.start()
			timerStopStartBool = false


func _on_walk_timer_timeout():
	# when the anim timer runs out it plays the walking anim
	play_animation("walking")
#	print("walktimer timeout")
#	print(anim.animation)

	


	
	
	
	
func orientEnemy():
	if(oriented == false):
		oriented = true
		# creates 3 variables that keep track of the player position, the enemy position, and the difference between them
		var playerPos = player.global_position
		var enemyPos = global_position
		var enemyPlayerPosDif = enemyPos.x - playerPos.x
		# if the difference is less than 0
		if(enemyPlayerPosDif < 0):
			# flip the animation's horizonal axis
			$AnimatedSprite2D.flip_h = true
	
	
	
	
	
	
	
func deal_damage(damageAmount):
	player.health -= damageAmount


func die():
	self.queue_free()



func enemy_hit():
	# subtracts health
	health -= 1
	#updates health bar
	$ProgressBar.value -= 1
	# if the health is at 0 die
	if(health <= 0):
		die()
		
		
		
		
func checkForAttackReady():
	if( anim.animation == "chomp_chomp" 
	and anim.is_playing() == true 
	and anim.frame == 3
	and damageDeltForAnim == false):
		#make sure it should not deal damage until chomp timer is in timeout
		damageDeltForAnim = true
		#calls the deal damage function
		deal_damage(damage)


func _on_chomp_timer_timeout():
	#play chomp anim
	damageDeltForAnim = false
	play_animation("chomp_chomp")
	
