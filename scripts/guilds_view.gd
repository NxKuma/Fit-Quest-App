extends Control

var guild_list: Array[GuildData]
var get_guild_done: bool = false
var load_guild_data: bool = false
@onready var label: Label = $Panel/Label
@onready var guilds_list: VBoxContainer = $"Guilds List"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print(Global.person_id)
	if Global.person_id != -1 and !load_guild_data:
		Global._get_guild()
		Global._process_guilds()
		load_guild_data = true
	show_guilds()



func show_guilds():
	if !get_guild_done and load_guild_data:
		label.text = Global.guild_data.guild_name
		guild_list = Global.all_guild_data
		
		for guild in guild_list:
			var label = Label.new()
			label.text = guild.guild_name
			label.add_theme_font_size_override("font_size", 25)
			label.add_theme_color_override("font_color", Color("#1e85bc"))
			guilds_list.add_child(label)
		
		get_guild_done = true
