@tool
extends MeshInstance3D

# Called when the node enters the scene tree for the first time.
func _ready():
	var arr_mesh = ArrayMesh.new()
	randomize()
	var surface_array = []
	surface_array.resize(Mesh.ARRAY_MAX)
	var verts = PackedVector3Array()
	var uvs = PackedVector2Array()
	var normals = PackedVector3Array()
	var inds = PackedInt32Array()
	#var colors = PackedColorArray()
	
	var ring = PackedVector3Array()
	var angle = 0.0
	for n in range(8):
		ring.append(Vector3(cos(angle),0.0,sin(angle)))
		angle += PI/4
	
	verts.append_array(ring)

	surface_array[Mesh.ARRAY_VERTEX] = verts
#	#surface_array[Mesh.ARRAY_INDEX] = inds
#	#surface_array[Mesh.ARRAY_TEX_UV] = uvs
#	surface_array[Mesh.ARRAY_NORMAL] = normals
#	#surface_array[Mesh.ARRAY_COLOR] = colors
#
#	# No blendshapes, lods, or compression used.
	arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_POINTS, surface_array)
#	#arr_mesh.regen_normal_maps()
	mesh = arr_mesh

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func generate_normals(verts, inds):
	var counter = 0
	var norms = PackedVector3Array()
	var buffer3 = PackedVector3Array()
	for i in inds:
		buffer3.append(verts[i])
		if counter == 2:
			counter = 0
			var pl = Plane(buffer3[0],buffer3[1],buffer3[2])
			for v in buffer3:
				norms.append(pl.normal.normalized())
			buffer3.clear()
		else:
			counter += 1
	return norms
