using Godot;
using Microsoft.Extensions.Logging;
using Npgsql;
using System;


public partial class login_info_manager : Node
{
	[Export]
	sql_manager sql_Manager;
	private int p = 62773;
	private int q = 13967;
	private int n;
	private int euler_n;
	private bool alr_run = false;
	// Called when the node enters the scene tree for the first time.


	public int extended_euclid(int a, int b, ref int x, ref int y) {
		if (b == 0) {
			x = 1;
			y = 0;
			return a;
		}
		int g = extended_euclid(b, a%b, ref x, ref y);
		int z = x - a/b*y;
		x = y;
		y = z;
		return g;
	}

	public int mod_inv(int a, int m) {
		int x = 0, y = 0;
		int g = extended_euclid(a, m, ref x, ref y);
		if (g == 1 || g == -1) {
			return (x*g)%m;
		}
		return 0;
	}
	public override void _Ready()
	{
		n = p * q;
		euler_n = (p-1) * (q-1);


	}

	public int get_num_existing_accounts(){
		return sql_Manager.get_entry_count("logininfo");
	}


	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
		if (!alr_run) {
			GD.Print("testing");
			alr_run = set_current_user("thanie", "thanie");
		}
	}

	public bool set_current_user(String username, String password){
		var data_source = NpgsqlDataSource.Create(sql_manager.connectionString);
		String select_string = "SELECT EXISTS(SELECT FROM logininfo WHERE username = \'"+  username + "\' AND pass = \'" + password + "\' );";
		var search_command = data_source.CreateCommand(select_string);
		bool does_exist = false;
		var search_reader = search_command.ExecuteReader();
		while (search_reader.Read()){
			does_exist = search_reader.GetBoolean(0);
		}

		if (!does_exist) return false;

		String command_string = "SELECT info_id FROM logininfo WHERE username = \'"+  username + "\' AND pass = \'" + password + "\';";
		var command = data_source.CreateCommand(command_string);
		var command_reader = command.ExecuteReader();
		int current_id = -1;
		while (command_reader.Read()) {
			current_id = command_reader.GetInt32(0);
		}

		Node global =  GetNode("/root/global");
		global.Set("user_id", current_id.ToString());
		return true;

	}
}
