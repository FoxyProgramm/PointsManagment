@tool
extends EditorScript

var custom_points:Array[Point] = []

func _run() -> void:
	var new_save:=PointsSave.new()
	var points:Array[Point] = []
	for file in DirAccess.get_files_at("res://Resources/Points/"):
		points.append( load("res://Resources/Points/" + file) )
	new_save.points = points
	if custom_points:
		new_save.points.append_array(custom_points)
	
	if ResourceSaver.save(new_save, "res://Resources/Points.tres") == 0:
		print("Resource was saved!")
	else :
		print("Something went wrong with saving resource")
