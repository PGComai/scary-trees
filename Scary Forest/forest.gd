@tool
extends Node3D

@export var tree = preload("res://tree.tscn")
@export var quantity: int


# Called when the node enters the scene tree for the first time.
func _ready():
	for q in range(quantity):
		var seed_drop = Vector3(randfn(0,500.0), 0.0, randfn(0,500.0))
		if abs(seed_drop.x) < 3 and abs(seed_drop.z) < 3:
			pass
		else:
			var t = tree.instantiate()
			add_child(t)
			t.position = seed_drop


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
