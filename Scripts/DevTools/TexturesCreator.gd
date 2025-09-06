@tool
extends Node2D

class CustomTexture extends Object:
	var texture_name:String
	var callable:Callable
	var texture_size:Vector2i
	static func create_texture(name:String, cal:Callable, size:Vector2i) ->CustomTexture:
		var result := CustomTexture.new()
		result.texture_name = name
		result.texture_size = size
		result.callable = cal
		return result

var funcs:Array[CustomTexture] = [
	CustomTexture.create_texture(
		"Test",
		func():
			draw_circle(Vector2.ZERO, 16, Color.WHITE, true, -1, true)
			draw_circle(Vector2(32, 32), 16, Color.WHITE, true, -1, true)
			draw_circle(Vector2(0, 32), 16, Color.BLACK, true, -1, true)
			draw_circle(Vector2(32, 0), 16, Color.BLACK, true, -1, true)
			pass,
		Vector2i(32,32),
	),
	CustomTexture.create_texture(
		"MenuButton",
		func():
			draw_line(Vector2(0, 8), Vector2(64, 8), Color.WHITE, 4, true)
			draw_line(Vector2(0, 32), Vector2(64, 32), Color.WHITE, 4, true)
			draw_line(Vector2(0, 56), Vector2(64, 56), Color.WHITE, 4, true)
			pass,
		Vector2i(64,64),
	),
]

func queue_textures() -> void:
	for callable in funcs:
		self.draw.connect(callable.callable)
		$"..".size = callable.texture_size
		queue_redraw()
		await RenderingServer.frame_post_draw
		$"..".data[callable.texture_name] = ImageTexture.create_from_image($"..".get_texture().get_image())
		self.draw.disconnect(callable.callable)
