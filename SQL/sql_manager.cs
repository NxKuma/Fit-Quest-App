using Godot;
using System;
using Npgsql;
using Godot.NativeInterop;
using System.Collections;
using System.Collections.Generic;
using System.Runtime.Intrinsics.Arm;

public partial class sql_manager : Node
{
	[Export]
	public string host_string {get; set;} = "";
	
	[Export]
	public string username_string {get; set;} = "";

	[Export]
	public string password_string {get; set;} = "";

	[Export]
	public string database_string {get; set;} = "";

	static string connectionString = "";
	static string setup_string = "CREATE TABLE car (car_id serial PRIMARY KEY,wheel_cnt int NOT NULL);\r\n\r\nINSERT INTO car (wheel_cnt) VALUES (10);";
	static string clear_string = "DROP TABLE car;";
	static string setup_sql_string = "";
	
	string setup = "";

	public void SaveToFile(string content)
	{
		using var file = FileAccess.Open("user://save_game.dat", FileAccess.ModeFlags.Write);
		file.StoreString(content);
	}

	public string LoadFromFile(string path)
	{
		using var file = FileAccess.Open(path, FileAccess.ModeFlags.Read);
		string content = file.GetAsText();
		return content;
	}

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		connectionString += "Host=" + host_string + ";";
		connectionString += "Username=" + username_string + ";";
		connectionString += "Password=" + password_string + ";";
		connectionString += "Database=" + database_string;
		setup_sql_string = LoadFromFile("res://SQL//setup.SQL");
		//GD.Print(setup_sql_string);
 		runSql();
	}
	
	static public void runSql()
	{
		var data_source = NpgsqlDataSource.Create(connectionString);

		List<String> sql_commands = new List<string>();
		string current_string = "";
		// Gets the entire string until the semicolon
		for (int i = 0; i < setup_sql_string.Length; i++) {
			char c = setup_sql_string[i];
			if (c == ';') {
				current_string += c;
				sql_commands.Add(current_string);
				current_string = "";
			} else if (c == '\r' || c == '\n') {
				continue;
			} else {
				current_string += c;
			}
		}

		for (int i = 0; i < sql_commands.Count; i++) {
			String current_command = sql_commands[i];
			List<String> words = new List<string>();
			String current_word = "";

			// Does not include the semicolon
			for (int j = 0; j < current_command.Length; j++) {
				char c = current_command[j];
				if (c == ' ' || c == ';') {
					words.Add(current_word);
					current_word = "";
				} else if (c == '\r' || c == '\n') {
					continue;
				} else {
					current_word += c;
				}
			}

			bool can_run = true;

			GD.Print("Current Words:");
			for (int j = 0; j < words.Count; j++) {
				GD.Print("Word Num " + j + ": " + words[j]);
			}
			GD.Print("Check Condition: "+ (words[0] == "DROP"));

			if (words[0] == "DROP") {
				GD.Print("CONTINUED!");
				String select_string = "SELECT EXISTS(SELECT FROM pg_tables WHERE tablename = \'"+  words[words.Count-1] + "\');";
				GD.Print("Current Select String: " + select_string);
				var bool_command = data_source.CreateCommand(select_string);
				var bool_reader = bool_command.ExecuteReader();
				bool does_exist = false;
				while (bool_reader.Read()) {
					does_exist = bool_reader.GetBoolean(0);
				}

				if (!does_exist) {
					can_run = false;
				}
			}
			GD.Print("Can run? " + current_command);
			GD.Print("Answer: " + can_run);
			if (can_run) {
				GD.Print("Current Command being run: " + current_command);
				var command = data_source.CreateCommand(current_command);
				var command_reader = command.ExecuteNonQuery();
			}
		}
	}
}
