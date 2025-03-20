using Godot;
using System;
using Npgsql;
using Godot.NativeInterop;

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
		GD.Print(setup_sql_string);
 		runSql();
	}
	
	static public void runSql()
	{
		var dataSource = NpgsqlDataSource.Create(connectionString);
		var check_exists = dataSource.CreateCommand("SELECT EXISTS(SELECT FROM pg_tables WHERE tablename = 'car');");
		var bool_reader = check_exists.ExecuteReader();
		bool does_exist = false;
		while (bool_reader.Read()) {
			does_exist = bool_reader.GetBoolean(0);
		}


		if (does_exist) {
			var test1 = dataSource.CreateCommand(clear_string);
			test1.ExecuteReader();
		}
		
		
		var test2 = dataSource.CreateCommand(setup_string);
		test2.ExecuteReader();

		var test3 = dataSource.CreateCommand("SELECT * FROM car");
		var reader = test3.ExecuteReader();
		while (reader.Read())
		{
			//GD.Print(reader.GetInt32(0));
			//GD.Print(reader.GetInt32(1));
		}
	}
}
