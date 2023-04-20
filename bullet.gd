extends CharacterBody2D 
# member variables
var speed = 100
var damage
var moving
var global_target 
var active = null





# Called when the node enters the scene tree for the first time.
func _ready():
	# setting damage to 20 hp
	damage = 20
	# setting moving var to false
	moving = false


	
	

	
	
func _physics_process(delta):
	if(moving):
		# moves the bullet
		# creates variable called collision_info and stores any collision info of collision. Also moves the bullet.
		var collision_info = move_and_collide(global_target * speed * delta)
		# if the collision info is full with a value
		if(collision_info != null):
			# if the collider of the other obj is in the group enemy and the bullet is active
			if(collision_info.get_collider().is_in_group("enemy") and active == true):
				# handles particle system using godot's particle system a greate system for making particles in godot
				# more specificly it stops the fireball emittion to false and starts the explosion particle effect
				$fireBall.emitting = false
				$explosion.emitting = true	
				# if the obj that has been collided with has the enemy hit method
					# it calls that method
				collision_info.get_collider().call("enemy_hit")
				# and sets the active variable to false so it won't kill all enemys in a line.
				active = false
				# it waits until the explosion effect is fully done
				await($explosion.hidden)
				# then destroys the bullet
				destroy()
			destroy()
		
		
		

func fire(target):
	# sets the active function to true so the bullet can do what it needs to do
	active = true
	# making bullet visible
	self.show()
	# setting global variable global_target to the target peramiter
	global_target = target.normalized()
	#setting moving to true
	moving = true
	

	
	
func destroy():
	# it destroys it. And seriously if you are reading this not knowing what this does look at the line above this. IT DESTROYS IT YOU LITTLE DUMB PEICE OF CRAB!
	self.queue_free()
	
	
	

func _on_visible_on_screen_notifier_2d_screen_exited():
	# when it is not on screen it is destroyed
	destroy()



