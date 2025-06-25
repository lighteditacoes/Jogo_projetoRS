extends CharacterBody2D

var dir = Vector2.ZERO
var speed = 2000

func _physics_process(delta):
	velocity = dir * speed
	move_and_slide()
