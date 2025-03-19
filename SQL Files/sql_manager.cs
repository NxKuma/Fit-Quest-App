using Godot;
using System;
using Npgsql;

public partial class sql_manager : Node
{
	static string connectionString = "Host=localhost;Username=thaniel;Password=thaniel;Database=c_sharp_testing";
	static string setup_string = "CREATE TABLE car (car_id serial PRIMARY KEY,wheel_cnt int NOT NULL);\r\n\r\nINSERT INTO car (wheel_cnt) VALUES (1);";
	static string clear_string = "DROP TABLE car;";
	
	string setup = "";
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		runSql();
	}
	
	static public void runSql()
{
	var dataSource = NpgsqlDataSource.Create(connectionString);
	var test1 = dataSource.CreateCommand(clear_string);
	test1.ExecuteReader();

	var test2 = dataSource.CreateCommand(setup_string);
	test2.ExecuteReader();

	var test3 = dataSource.CreateCommand("SELECT * FROM car");
	var reader = test3.ExecuteReader();
	while (reader.Read())
	{
		GD.Print(reader.GetInt32(0));
		GD.Print(reader.GetInt32(1));
	}
}
}
