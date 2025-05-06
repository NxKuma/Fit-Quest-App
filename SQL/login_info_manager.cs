using Godot;
using Microsoft.Extensions.Logging;
using Npgsql;
using System;


public partial class login_info_manager : Node
{
	[Export]
	sql_manager sql_Manager;
	private bool alr_run = false;
	Node global;

	[Export]
	Node DataTransporter;
	// Called when the node enters the scene tree for the first time.

	[Signal] public delegate void OnCSharpSentDataEventHandler(string theData);


	public int get_num_existing_accounts(){
		return sql_Manager.get_entry_count("logininfo");
	}


	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
		// if (!alr_run) {
		// 	GD.Print("testing");
		// 	add_user("thanie", "thanie");
		// 	alr_run = set_current_user("thanie", "thanie");
		// 	int person = add_person(1.69f, 70f, 1);
		// 	create_guild("revengers");	
		// 	assign_guild(1, 1);
		// 	int userinfo_id = global.Get("info_id").As<int>();
		// 	bool test;	
		// 	test = transfer_person_info(userinfo_id);
		// 	int new_avatar = add_avatar(1, 1.0f, 1.1f, 1.2f, 1.3f, 1.4f, 1.5f, 1.6f, 1.7f);
		// 	test = transfer_avatar_info(userinfo_id);
		// }
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
		search_reader.Close();
		if (!does_exist) {
			data_source.Clear();
			return false;
		}

		String command_string = "SELECT info_id FROM logininfo WHERE username = \'"+  username + "\' AND pass = \'" + password + "\';";
		var command = data_source.CreateCommand(command_string);
		var command_reader = command.ExecuteReader();
		int current_id = -1;
		while (command_reader.Read()) {
			current_id = command_reader.GetInt32(0);
		}
		command_reader.Close();

		Node global =  GetNode("/root/Global");
		global.Set("info_id", current_id.ToString());

		// transfer_avatar_info(current_id);
		// transfer_person_info(current_id);
		
		data_source.Clear();
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
		person_reader.Close();
		if (!does_exist) {
			data_source.Clear();
			return false;
		}

		int avatar_id = -1;
		String get_person_string = "SELECT avatar_id FROM person WHERE logininfo_id = \'" + info_id  + "\' ";
		var get_person = data_source.CreateCommand(get_person_string);
		var get_person_reader = get_person.ExecuteReader();

		GD.Print("sure ", get_person_reader.GetOrdinal("avatar_id"));
		while (get_person_reader.Read()) {
			avatar_id = get_person_reader.GetInt32(get_person_reader.GetOrdinal("avatar_id"));
		}
		get_person_reader.Close();
		GD.Print("sure");
		if (avatar_id == -1) {
			data_source.Clear();
			return false;
		}


		float arms= 0.0f, breasts= 0.0f, torso= 0.0f, belly= 0.0f, hips= 0.0f, legs= 0.0f, neck= 0.0f;
		String get_avatar_string = "SELECT * FROM avatar WHERE avatar_id = " + avatar_id.ToString() + ";";
		var get_avatar = data_source.CreateCommand(get_avatar_string);
		var get_avatar_reader = get_avatar.ExecuteReader();
		
		while (get_avatar_reader.Read()) {
			arms = get_avatar_reader.GetFloat(get_avatar_reader.GetOrdinal("arms_param"));
			breasts = get_avatar_reader.GetFloat(get_avatar_reader.GetOrdinal("breasts_param"));
			torso = get_avatar_reader.GetFloat(get_avatar_reader.GetOrdinal("torso_param"));
			belly = get_avatar_reader.GetFloat(get_avatar_reader.GetOrdinal("belly_param"));
			hips = get_avatar_reader.GetFloat(get_avatar_reader.GetOrdinal("hips_param"));
			legs = get_avatar_reader.GetFloat(get_avatar_reader.GetOrdinal("legs_param"));
			neck = get_avatar_reader.GetFloat(get_avatar_reader.GetOrdinal("neck_param"));
		}
		get_avatar_reader.Close();

		DataTransporter.Set("arms", arms.ToString());
		DataTransporter.Set("breasts", breasts.ToString());
		DataTransporter.Set("torso", torso.ToString());
		DataTransporter.Set("belly", belly.ToString());
		DataTransporter.Set("hips", hips.ToString());
		DataTransporter.Set("legs", legs.ToString());
		DataTransporter.Set("neck", neck.ToString());

		// GD.Print("HMMM");
		// GD.Print(arms);
		// GD.Print(breasts);
		// GD.Print(torso);
		// GD.Print(belly);
		// GD.Print(hips);
		// GD.Print(legs);
		// GD.Print(neck);
		DataTransporter.Call("_process_avatar_data");
		data_source.Clear();
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
		person_reader.Close();

		if (!does_exist) {
			data_source.Clear();
			return false;
		}

		int person_id = -1;
		float height = -1;
		float weight = -1;
		float bmi = -1;
		int guild_id = -1;
		int streak_days = -1;

		String get_person_string = "SELECT * FROM person WHERE logininfo_id = \'" + info_id  + "\' ";
		var get_person = data_source.CreateCommand(get_person_string);
		var get_person_reader = get_person.ExecuteReader();

		while (get_person_reader.Read()) {
			person_id = get_person_reader.GetInt32(get_person_reader.GetOrdinal("person_id"));
			height = get_person_reader.GetFloat(get_person_reader.GetOrdinal("person_height_cm"));
			weight = get_person_reader.GetFloat(get_person_reader.GetOrdinal("person_weight_kg"));
			bmi = get_person_reader.GetFloat(get_person_reader.GetOrdinal("person_bmi"));
			// guild_id = get_person_reader.GetInt32(get_person_reader.GetOrdinal("guild_id"));
		}
		get_person_reader.Close();
		if (person_id == -1) {
			data_source.Clear();
			return false;
		}

		streak_days = get_days(person_id);
		if (!does_workout_yesterday_exist(person_id)) {
			streak_days = 0;
		}

		set_days(person_id, streak_days);
		DataTransporter.Set("person_id", person_id);
		DataTransporter.Set("height", height);
		DataTransporter.Set("weight", weight);
		DataTransporter.Set("bmi", bmi);
		DataTransporter.Set("guild_id", guild_id);
		DataTransporter.Set("streak_days", streak_days);
	
		DataTransporter.Call("_process_person_data");
		data_source.Clear();
		return true;
	}

	public bool does_workout_yesterday_exist(int person_id) {
		var data_source = NpgsqlDataSource.Create(sql_manager.connectionString);
		String check_exist_string = "SELECT EXIST(SELECT * FROM workout_instance WHERE person_id=" + person_id +" AND date_executed=date_trunc('day', current_timestamp) - interval '1' day;);";
		bool does_exist = false;
		var exist_cmd = data_source.CreateCommand(check_exist_string);
		var exist_reader = exist_cmd.ExecuteReader();
		while(exist_reader.Read()) {
			does_exist = exist_reader.GetBoolean(0);
		}
		exist_reader.Close();
		data_source.Clear();
		return does_exist;
	}

	public bool set_days(int person_id, int day_cnt) {
		var data_source = NpgsqlDataSource.Create(sql_manager.connectionString);

		var search_person = data_source.CreateCommand(select_string_person);
		bool does_exist = false;
		var person_reader = search_person.ExecuteReader();
		while (person_reader.Read()) {
			does_exist = person_reader.GetBoolean(0);
		}
		person_reader.Close();

		if (!does_exist) {
			data_source.Clear();
			return false;
		}

		String set_days_string = "UPDATE person SET streak_day = " + day_cnt + " WHERE person_id=" + person + ";";
		var set_days_cmd = data_source.CreateCommand(set_days_string);
		var execute = set_cmd.ExecuteNonQuery();

		data_source.Clear();
		return true;
	}

	public int get_days(int person_id) {
		var data_source = NpgsqlDataSource.Create(sql_manager.connectionString);

		var search_person = data_source.CreateCommand(select_string_person);
		bool does_exist = false;
		var person_reader = search_person.ExecuteReader();
		while (person_reader.Read()) {
			does_exist = person_reader.GetBoolean(0);
		}
		person_reader.Close();

		if (!does_exist) {
			data_source.Clear();
			return false;
		}

		String get_days_string = "SELECT streak_days FROM person WHERE person_id=" + person_id + ";"
		var get_days_cmd = data_source.CreateCommand(set_days_string);
		int output_days = -1;
		var get_days_reader = get_days_cmd.ExecuteReader();
		while (get_days_reader.Read()) {
			output_days = get_days_reader.GetInt32(0);
		}


		get_days_reader.Close();
		data_source.Clear();
		return output_days;
	}

	public int add_user(string username, string password){
		GD.Print("what");
		var data_source = NpgsqlDataSource.Create(sql_manager.connectionString);
		String select_string_person = "SELECT EXISTS(SELECT FROM logininfo WHERE username = \'" + username  + "\' );";
		var search_person = data_source.CreateCommand(select_string_person);
		bool does_exist = false;
		var person_reader = search_person.ExecuteReader();
		GD.Print("what");
		while (person_reader.Read()) {
			does_exist = person_reader.GetBoolean(0);
		}
		person_reader.Close();
		GD.Print("DID IT EXIST? " + does_exist.ToString());
		if (does_exist) {
			data_source.Clear();
			return -1;
		}

		GD.Print("sure");
		String create_new_user_string = "INSERT INTO logininfo (username, pass) VALUES (\'" + username + "\', \'" + password + "\');";
		GD.Print("whynot");
		var execute_create = data_source.CreateCommand(create_new_user_string);
		var create_query = execute_create.ExecuteNonQuery();

		

		String command_string = "SELECT info_id FROM logininfo WHERE username = \'"+  username + "\' AND pass = \'" + password + "\';";
		var command = data_source.CreateCommand(command_string);
		var command_reader = command.ExecuteReader();
		int current_id = -1;
	
		while (command_reader.Read()) {
			current_id = command_reader.GetInt32(0);
		}
		command_reader.Close();
		return current_id;
	}


	public int add_avatar(int person_id, float arms, float breast, float torso, float belly, float hips, float legs, float neck) {
		var data_source = NpgsqlDataSource.Create(sql_manager.connectionString);

		// check if person exists
		String select_string_person = "SELECT EXISTS(SELECT FROM person WHERE person_id = \'" + person_id  + "\' );";
		var search_person = data_source.CreateCommand(select_string_person);
		bool does_exist = false;
		var person_reader = search_person.ExecuteReader();

		while (person_reader.Read()) {
			does_exist = person_reader.GetBoolean(0);
		}
		person_reader.Close();
		GD.Print("whut");
		if (!does_exist) {
			data_source.Clear();
			return -1;
		}

		String insert_string = "INSERT INTO avatar (arms_param, breasts_param, torso_param, belly_param, hips_param, legs_param, neck_param) VALUES (";
		insert_string += arms + ", ";
		insert_string += breast + ", ";
		insert_string += torso + ", ";
		insert_string += belly + ", ";
		insert_string += hips + ", ";
		insert_string += legs + ", ";
		insert_string += neck + ") RETURNING avatar_id;";
		GD.Print(insert_string);
		var insert_cmd = data_source.CreateCommand(insert_string);
		int avatar_id = (int)insert_cmd.ExecuteScalar();

		String set_avatar_to_person = "UPDATE person SET avatar_id = " + avatar_id + " WHERE person_id = " + person_id + ";";
		var set_cmd = data_source.CreateCommand(set_avatar_to_person);
		var execute_set = set_cmd.ExecuteNonQuery();
		data_source.Clear();
		return avatar_id;

	} 

	public int add_person(float height, float weight, int logininfo_id) {
		var data_source = NpgsqlDataSource.Create(sql_manager.connectionString);

		// check if login_id exists
		String select_string_person = "SELECT EXISTS(SELECT FROM logininfo WHERE info_id = " + logininfo_id  + " );";
		var search_person = data_source.CreateCommand(select_string_person);
		bool does_exist = false;
		var person_reader = search_person.ExecuteReader();

		while (person_reader.Read()) {
			does_exist = person_reader.GetBoolean(0);
		}
		person_reader.Close();
		if (!does_exist){
			data_source.Clear();
			return -1;
		}

		String insert_person_string = "INSERT INTO person (person_height_cm, person_weight_kg, logininfo_id) VALUES (";
		insert_person_string += height + ",";
		insert_person_string += weight + ",";
		insert_person_string += logininfo_id + ") RETURNING person_id;";
		var insert_cmd = data_source.CreateCommand(insert_person_string);
		int person_id = (int)insert_cmd.ExecuteScalar();
		data_source.Clear();
		return person_id;

	}

	public bool assign_guild(int person_id, int guild_id) {
		var data_source = NpgsqlDataSource.Create(sql_manager.connectionString);
		
		// check if person exists
		String select_string_person = "SELECT EXISTS(SELECT FROM person WHERE person_id = \'" + person_id  + "\' );";
		var search_person = data_source.CreateCommand(select_string_person);
		bool does_exist = false;
		var person_reader = search_person.ExecuteReader();
		GD.Print("what");
		while (person_reader.Read()) {
			does_exist = person_reader.GetBoolean(0);
		}
		person_reader.Close();
		GD.Print("DID IT EXIST? " + does_exist.ToString());
		if (!does_exist) {
			data_source.Clear();
			return false;
		}

		// check if guild exists
		String select_string_guild = "SELECT EXISTS(SELECT FROM guild WHERE guild_id = \'" + guild_id  + "\' );";
		var search_guild = data_source.CreateCommand(select_string_guild);
		var guild_reader = search_guild.ExecuteReader();
		while (guild_reader.Read()) {
			does_exist = guild_reader.GetBoolean(0);
		}
		guild_reader.Close();
		GD.Print("DID IT EXIST? " + does_exist.ToString());
		if (!does_exist && guild_id != -1) {
			data_source.Clear();
			return false;
		}
		String update_guild_string;
		if (guild_id == -1) {
			update_guild_string = "UPDATE person SET guild_id = NULL WHERE person_id = " + person_id + ";";
		} else {
			update_guild_string = "UPDATE person SET guild_id = " + guild_id + " WHERE person_id = " + person_id + ";";
		}
		var execute_update = data_source.CreateCommand(update_guild_string);
		var execute = execute_update.ExecuteNonQuery();
		data_source.Clear();
		return true;
	}	

	public int create_guild(String guild_name) {
		var data_source = NpgsqlDataSource.Create(sql_manager.connectionString);
		
		// check if guild name exists
		String select_string_guild = "SELECT EXISTS(SELECT FROM guild WHERE guild_name = \'" + guild_name  + "\' );";
		var search_guild = data_source.CreateCommand(select_string_guild);
		var guild_reader = search_guild.ExecuteReader();
		bool does_exist = false;
		while (guild_reader.Read()) {
			does_exist = guild_reader.GetBoolean(0);
		}
		guild_reader.Close();
		GD.Print("DID IT EXIST? " + does_exist.ToString());
		if (does_exist) {
			data_source.Clear();
			return -1;
		}

		String create_guild_string = "INSERT INTO guild (guild_name) VALUES (\'" + guild_name + "\') RETURNING guild_id;";
		var execute_insert = data_source.CreateCommand(create_guild_string);
		int execute = (int)execute_insert.ExecuteScalar();
		data_source.Clear();
		return execute;
	}


}
