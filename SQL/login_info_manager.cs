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
	Node global;

	[Export]
	Node DataTransporter;
	// Called when the node enters the scene tree for the first time.

	[Signal] public delegate void OnCSharpSentDataEventHandler(string theData);


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

		global =  GetNode("/root/Global");


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
			int userinfo_id = global.Get("info_id").As<int>();
			bool test = transfer_avatar_info(userinfo_id);
			GD.Print("did this one run? ", test);
			test = transfer_person_info(userinfo_id);
			GD.Print("did this one run? ", test);
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
		GD.Print("finished?");
		while (command_reader.Read()) {
			current_id = command_reader.GetInt32(0);
		}

		Node global =  GetNode("/root/Global");
		global.Set("info_id", current_id.ToString());

		
		return true;
	}

	public bool transfer_avatar_info(int info_id) {
		var data_source = NpgsqlDataSource.Create(sql_manager.connectionString);
		String select_string_person = "SELECT EXISTS(SELECT FROM person WHERE logininfo_id = \'" + info_id  + "\' );";
		var search_person = data_source.CreateCommand(select_string_person);
		bool does_exist = false;
		var person_reader = search_person.ExecuteReader();
		while (person_reader.Read()) {
			does_exist = person_reader.GetBoolean(0);
		}

		if (!does_exist) return false;

		int avatar_id = -1;
		String get_person_string = "SELECT avatar_id FROM person WHERE logininfo_id = \'" + info_id  + "\' ";
		var get_person = data_source.CreateCommand(get_person_string);
		var get_person_reader = get_person.ExecuteReader();

		GD.Print("sure ", get_person_reader.GetOrdinal("avatar_id"));
		while (get_person_reader.Read()) {
			avatar_id = get_person_reader.GetInt32(get_person_reader.GetOrdinal("avatar_id"));
		}
		GD.Print("sure");
		if (avatar_id == -1) {
			return false;
		}


		float shoulders = 0.0f, arms= 0.0f, breasts= 0.0f, torso= 0.0f, belly= 0.0f, hips= 0.0f, legs= 0.0f, neck= 0.0f;
		String get_avatar_string = "SELECT * FROM avatar WHERE avatar_id = " + avatar_id.ToString() + ";";
		var get_avatar = data_source.CreateCommand(get_avatar_string);
		var get_avatar_reader = get_avatar.ExecuteReader();
		
		while (get_avatar_reader.Read()) {
			shoulders = get_avatar_reader.GetFloat(get_avatar_reader.GetOrdinal("shoulder_param"));
			arms = get_avatar_reader.GetFloat(get_avatar_reader.GetOrdinal("arms_param"));
			breasts = get_avatar_reader.GetFloat(get_avatar_reader.GetOrdinal("breasts_param"));
			torso = get_avatar_reader.GetFloat(get_avatar_reader.GetOrdinal("torso_param"));
			belly = get_avatar_reader.GetFloat(get_avatar_reader.GetOrdinal("belly_param"));
			hips = get_avatar_reader.GetFloat(get_avatar_reader.GetOrdinal("hips_param"));
			legs = get_avatar_reader.GetFloat(get_avatar_reader.GetOrdinal("legs_param"));
			neck = get_avatar_reader.GetFloat(get_avatar_reader.GetOrdinal("neck_param"));
		}


		DataTransporter.Set("shoulders", shoulders.ToString());
		DataTransporter.Set("arms", arms.ToString());
		DataTransporter.Set("breasts", breasts.ToString());
		DataTransporter.Set("torso", torso.ToString());
		DataTransporter.Set("belly", belly.ToString());
		DataTransporter.Set("hips", hips.ToString());
		DataTransporter.Set("legs", legs.ToString());
		DataTransporter.Set("neck", neck.ToString());

		// GD.Print("HMMM");
		// GD.Print(shoulders);
		// GD.Print(arms);
		// GD.Print(breasts);
		// GD.Print(torso);
		// GD.Print(belly);
		// GD.Print(hips);
		// GD.Print(legs);
		// GD.Print(neck);
		DataTransporter.Call("_process_avatar_data");

		return true;
	}

	public bool transfer_person_info(int info_id) {
		var data_source = NpgsqlDataSource.Create(sql_manager.connectionString);
		String select_string_person = "SELECT EXISTS(SELECT FROM person WHERE logininfo_id = \'" + info_id  + "\' );";
		var search_person = data_source.CreateCommand(select_string_person);
		bool does_exist = false;
		var person_reader = search_person.ExecuteReader();
		while (person_reader.Read()) {
			does_exist = person_reader.GetBoolean(0);
		}

		if (!does_exist) return false;

		int person_id = -1;
		float height = -1;
		float weight = -1;
		float bmi = -1;
		int guild_id = -1;

		String get_person_string = "SELECT * FROM person WHERE logininfo_id = \'" + info_id  + "\' ";
		var get_person = data_source.CreateCommand(get_person_string);
		var get_person_reader = get_person.ExecuteReader();

		while (get_person_reader.Read()) {
			person_id = get_person_reader.GetInt32(get_person_reader.GetOrdinal("person_id"));
			height = get_person_reader.GetFloat(get_person_reader.GetOrdinal("person_height_m"));
			weight = get_person_reader.GetFloat(get_person_reader.GetOrdinal("person_weight_kg"));
			bmi = get_person_reader.GetFloat(get_person_reader.GetOrdinal("person_bmi"));
			// guild_id = get_person_reader.GetInt32(get_person_reader.GetOrdinal("guild_id"));
		}

		if (person_id == -1) {
			return false;
		}

		

		DataTransporter.Set("person_id", person_id);
		DataTransporter.Set("height", height);
		DataTransporter.Set("weight", weight);
		DataTransporter.Set("bmi", bmi);
		DataTransporter.Set("guild_id", guild_id);
		
		DataTransporter.Call("_process_person_data");

		return true;
	}

	public bool add_user(string username, string password){

		return true;
	}
}
