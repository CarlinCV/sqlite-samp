/*
	ATENÇÃO!
	
	Esse gamemode foi criado em um tutorial sobre SQLite, tem total criação de Carlos Victor, autor do tutorial.
	Você não tem o direito de usar esse gamemode comercialmente, é fruto de um trabalho volúntário cujo é para ajudar pessoas a iniciar um bom servidor SA:MP usando SQLite.	

	Repositório: https://github.com/CarlinCV/sqlite-tutorial
*/

#include <a_samp>

#define MAX_LENGTH_IP (16)

enum playerData {
	pID,
	pName[MAX_PLAYER_NAME],
	pIP[MAX_LENGTH_IP],
	pPassword,

	pLevel,
	pMoney,

	bool:pLogged
};
new PlayerData[MAX_PLAYERS][playerData];

new DB:g_Handle;
new g_Query[1024];

main(){}

public OnGameModeInit() {
	if((g_Handle = db_open("database.db")) == DB:0) {
		print("[SQLite]: Não foi possível conectar-se ao arquivo 'database.db'.");
		SendRconCommand("exit");
	} else {
		print("[SQLite]: Foi conectado com sucesso ao arquivo 'database.db'.");
	}
	return 1;
}

public OnPlayerConnect(playerid)
{
	GetPlayerName(playerid, PlayerData[playerid][pName], MAX_PLAYER_NAME);
	GetPlayerIp(playerid, PlayerData[playerid][pIP], MAX_LENGTH_IP);

	static
		DBResult:result;
	
	format(g_Query, sizeof(g_Query), "SELECT * FROM Jogadores WHERE Name = '%q';", PlayerData[playerid][pName]);
	result = db_query(g_Handle, g_Query);
	
	if(db_num_rows(result) > 0) {
		ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Login", "Seja bem-vindo(a)! Insira sua senha para logar:", "Confirmar", "X");
	} else {
		ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_INPUT, "Registro", "Seja bem-vindo(a)! Insira uma senha para registrar sua conta:", "Confirmar", "X");
	}
	
	db_free_result(result);
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	Player_Save(playerid);
	Player_Reset(playerid);
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid)
	{		
		case DIALOG_REGISTER:
		{			
			if(strlen(inputtext) < 4 || strlen(inputtext) > 32)
				return ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_INPUT, "Registro", "ERRO: Sua senha deve ter de 4-32 caracteres.\n\nSeja bem-vindo(a)! Insira uma senha para registrar sua conta:", "Confirmar", "X");
						
			format(g_Query, sizeof(g_Query), "INSERT INTO Jogadores(Name, Password) VALUES('%q', '%q');", PlayerData[playerid][pName], inputtext);
			db_free_result(db_query(g_Handle, g_Query));

			Player_Load(playerid); 
		}
	}
	return 1;
}

Player_Load(playerid)
{
	static
		DBResult:result;

	format(g_Query, sizeof(g_Query), "SELECT * FROM Jogadores WHERE Name = '%q';", PlayerData[playerid][pName]);
	result = db_query(g_Handle, g_Query);

	if(db_num_rows(result) > 0) {
		PlayerData[playerid][pID] = db_get_field_assoc_int(result, "ID");

		PlayerData[playerid][pLevel] = db_get_field_assoc_int(result, "Level");
		PlayerData[playerid][pMoney] = db_get_field_assoc_int(result, "Money");
		
		PlayerData[playerid][pLogged] = true;
	}
	db_free_result(result);
	
	GivePlayerMoney(playerid, PlayerData[playerid][pMoney]);
	SetPlayerScore(playerid, PlayerData[playerid][pLevel]);

	SpawnPlayer(playerid);
	return 1;
}

Player_Save(playerid)
{
	format(g_Query, sizeof(g_Query), "UPDATE Jogadores SET \
		`Name`='%q',\
		`Level`='%d',\
		`Money`='%d' WHERE `ID`='%d';", 
										PlayerData[playerid][pName],
										PlayerData[playerid][pLevel],
										PlayerData[playerid][pMoney],
										PlayerData[playerid][pID]);
    db_free_result(db_query(g_Handle, result));
	return 1;
}

Player_Reset(playerid)
{	
	static
		dummy[playerData]; 
	
	PlayerData[playerid] = dummy;

	PlayerData[playerid][pID] = -1;	
	return 1;
}
