@tool
extends StaticBody3D

@onready var forest_floor = preload("res://forest_floor.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var mult = 500
	for tile_x in range(-10,11):
		for tile_y in range(-10,11):
			if tile_x == 0 and tile_y == 0:
				pass
			else:
				var tile = Vector3(tile_x*mult,-0.1,tile_y*mult)
				var ff = forest_floor.instantiate()
				ff.position = tile
				add_child(ff)
				


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
