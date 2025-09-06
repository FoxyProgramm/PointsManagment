extends Control

@export_group("TextureRect")
@export var texture_name:String

@export_group("TextureButton")
@export var normal_texture_name:String
@export var pressed_texture_name:String
@export var hover_texture_name:String
@export var disabled_texture_name:String
@export var focused_texture_name:String
@export var click_mask_texture_name:String

func _ready() -> void:
	if !Global.is_ready:
		await Global.final_ready
	if is_class("TextureRect"):
		self.texture = Global.textures[texture_name] if Global.textures.has(texture_name) else null
	elif is_class("TextureButton") :
		self.texture_normal = Global.textures[normal_texture_name] if Global.textures.has(normal_texture_name) else null
	#if self is TextureRect:
		#self.texture = Global.textures[texture_name]
