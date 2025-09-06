@tool
extends SubViewport

@export_tool_button("Bake!") var bake_button = bake

var data:Dictionary[String, ImageTexture] = {}

func bake() -> void:
	data.clear()
	var new_save := TexturesSave.new()
	await $TexturesCreator.queue_textures()
	new_save.textures = data
	if ResourceSaver.save(new_save, "res://Resources/Textures.tres") == OK:
		print("Textures was saved succssessfully!")
	else :
		print("Something went wrong while save Textures :<")
