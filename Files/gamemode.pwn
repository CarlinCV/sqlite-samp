/*
	ATENÇÃO!
	
	Esse gamemode foi criado em um tutorial sobre SQLite, tem total criação de Carlos Victor, autor do tutorial.
	Você não tem o direito de usar esse gamemode comercialmente, é fruto de um trabalho volúntário cujo é para ajudar pessoas a iniciar um bom servidor SA:MP usando SQLite.	

	Repositório: https://github.com/CarlinCV/sqlite-tutorial
*/

#include <a_samp>

#include <streamer>
#include <sscanf2>

#include <Pawn.CMD>
#include <easyDialog>

#define callback%0(%1) \
	forward%0(%1); public%0(%1)

#define Kick(%0) \
	SetTimerEx("KickPlayer", 200, false, "i", %0)

#define MAX_LENGTH_IP 			(16)
#define MAX_LENGTH_PASSWORD 	(32)

#define COLOR_LIGHTRED    (0xFF6347FF)
#define COLOR_LIGHTGREEN  (0x9ACD32FF)
#define COLOR_LIGHTYELLOW (0xF5DEB3FF)
#define COLOR_LIGHTBLUE   (0x007FFFFF)

#define COLOR_CLIENT      (0xAAC4E5FF)
#define COLOR_WHITE       (0xFFFFFFFF)
#define COLOR_RED         (0xFF0000FF)
#define COLOR_CYAN        (0x33CCFFFF)
#define COLOR_YELLOW      (0xFFFF00FF)
#define COLOR_GREY        (0xAFAFAFFF)
#define COLOR_PURPLE      (0xD0AEEBFF)
#define COLOR_DARKBLUE    (0x1394BFFF)
#define COLOR_ORANGE      (0xFFA500FF)
#define COLOR_LIME        (0x00FF00FF)
#define COLOR_GREEN       (0x33CC33FF)
#define COLOR_BLUE        (0x2641FEFF)
#define COLOR_SERVER      (0xFFFF90FF)

enum {
	DIALOG_VIEW,
	DIALOG_REGISTER,
	DIALOG_LOGIN
};

enum playerData {
	pID,
	pName[MAX_PLAYER_NAME],
	pIP[MAX_LENGTH_IP],
	pPassword,

	pLevel,
	pMoney,

	bool:pLogged,
	pWrong
};
new PlayerData[MAX_PLAYERS][playerData];
#define ReturnName(%0) (PlayerData[%0][pName])

new DB:g_Handle;
new g_Query[1024];

main(){}

public OnGameModeInit() {
	if((g_Handle = db_open("database.db")) == DB:0) {
		print("[SQLite]: Não foi possível conectar-se ao arquivo 'database.db'.");
		SendRconCommand("exit");
	} else {
		print("[SQLite]: Foi conectado com sucesso ao arquivo 'database.db'.");

		db_free_result(db_query(g_Handle, "ALTER TABLE Jogadores ADD COLUMN Admin INTEGER DEFAULT 0;"));
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
		PlayerData[playerid][pID] = db_get_field_assoc_int(result, "ID");
		db_get_field_assoc(result, "Password", PlayerData[playerid][pPassword], MAX_LENGTH_PASSWORD);

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
			if(response)
			{
				if(strlen(inputtext) < 4 || strlen(inputtext) > 32)
					return ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_INPUT, "Registro", "ERRO: Sua senha deve ter de 4-32 caracteres.\n\nSeja bem-vindo(a)! Insira uma senha para registrar sua conta:", "Confirmar", "X");
							
				format(g_Query, sizeof(g_Query), "INSERT INTO Jogadores(Name, Password, RegisterIP) VALUES('%q', '%q', '%q');", PlayerData[playerid][pName], inputtext, PlayerData[playerid][pIP]);
				db_free_result(db_query(g_Handle, g_Query));

				Player_Load(playerid);
			} 
		}
		case DIALOG_LOGIN:
		{
			if(response)
			{
				if(strcmp(PlayerData[playerid][pPassword], inputtext) == 0) {
					Player_Load(playerid);
				}
				else {
					PlayerData[playerid][pWrong]++;

					if(PlayerData[playerid][pWrong] >= 3)
						return Kick(playerid);

					ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Login", "ERRO: Senha incorreta, voce possui apenas 3 tentativas.\n\nSeja bem-vindo(a)! Insira sua senha para logar:", "Confirmar", "X");
				}
			}
		}
	}
	return 1;
}

CMD:email(playerid, params[])
{
	static
		string[148];

	if(isnull(params))
		return SendClientMessage(playerid, -1, "* /email [E-mail]");

	if(!IsValidEmail(params))
		return SendClientMessage(playerid, -1, "* E-mail inválido, tente novamente.");

	format(g_Query, sizeof(g_Query), "UPDATE Jogadores SET Email = '%q' WHERE ID = '%d';", params, PlayerData[playerid][pID]);
	db_free_result(db_query(g_Handle, g_Query));

	format(string, sizeof(string), "* Você alterou seu e-mail para: %s", params);
	SendClientMessage(playerid, -1, string);	
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

		PlayerData[playerid][pMoney] = db_get_field_assoc_int(result, "Money");
		PlayerData[playerid][pLevel] = db_get_field_assoc_int(result, "Level");		
		
		PlayerData[playerid][pLogged] = true;

		format(g_Query, sizeof(g_Query), "UPDATE Jogadores SET IP = '%q' WHERE ID = '%d';", PlayerData[playerid][pIP], PlayerData[playerid][pID]);
		db_free_result(db_query(g_Handle, g_Query));
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
		`Money`='%d',\
		`Level`='%d' WHERE `ID`='%d';", 
										PlayerData[playerid][pName],
										PlayerData[playerid][pMoney],
										PlayerData[playerid][pLevel],
										PlayerData[playerid][pID]);

    db_free_result(db_query(g_Handle, g_Query));
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

IsValidEmail(const email[])
{
    new
    	length = strlen(email),
        sign = -1,
        point = -1;

    if(!(64 < email[length - 1] < 91 || 96 < email[length - 1] < 123) || length < 7 )
        return 0;

    while(length--) {
        switch(email[length]) {
            case 64: {
                if(sign != - 1)
                    return 0;

                sign = length;
                continue;
            }
            case 46: {
                if(point != - 1 || sign != - 1 )
                    return 0;

                point = length;
                continue;
            }
            case 95, 45: {
                if(!point)
                	return 0;
            }

            case 48..57, 65..90, 97..122: {
                continue;
            }
        }
        return 0;
    }
    return (point != -1 && sign != -1);
}

forward  KickPlayer(playerid);
public KickPlayer(playerid)
{
    #undef Kick

    Kick(playerid);

    #define Kick(%0) \
    	SetTimerEx("KickPlayer", 200, false, "i", %0)

	return 1;
}

stock SendClientMessageEx(playerid, color, const string[], {Float, _}:...)
{
	static
	    args,
	    str[144];

	if ((args = numargs()) == 3)
	{
	    SendClientMessage(playerid, color, string);
	}
	else
	{
		while (--args >= 3)
		{
			#emit LCTRL 5
			#emit LOAD.alt args
			#emit SHL.C.alt 2
			#emit ADD.C 12
			#emit ADD
			#emit LOAD.I
			#emit PUSH.pri
		}
		#emit PUSH.S string
		#emit PUSH.C 144
		#emit PUSH.C str
		#emit PUSH.S 8
		#emit SYSREQ.C format
		#emit LCTRL 5
		#emit SCTRL 4

		SendClientMessage(playerid, color, str);

		#emit RETN
	}
	return 1;
}

stock SendClientMessageToAllEx(color, const string[], {Float, _}:...)
{
	static
	    args,
	    str[144];

	if ((args = numargs()) == 2)
	{
	    SendClientMessageToAll(color, string);
	}
	else
	{
		while (--args >= 2)
		{
			#emit LCTRL 5
			#emit LOAD.alt args
			#emit SHL.C.alt 2
			#emit ADD.C 12
			#emit ADD
			#emit LOAD.I
			#emit PUSH.pri
		}
		#emit PUSH.S string
		#emit PUSH.C 144
		#emit PUSH.C str
		#emit LOAD.S.pri 8
		#emit ADD.C 4
		#emit PUSH.pri
		#emit SYSREQ.C format
		#emit LCTRL 5
		#emit SCTRL 4

		SendClientMessageToAll(color, str);

		#emit RETN
	}
	return 1;
}
