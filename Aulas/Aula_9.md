# Login
Vamos terminar nosso sistema de login? Agora está fácil para você! Vamos lá.

Vamos adicionar em nosso enumerador o ID do Dialog `DIALOG_LOGIN`:
```pwn
enum {
	DIALOG_VIEW,
	DIALOG_REGISTER,
	DIALOG_LOGIN
};
```

E agora vamos manipular uma pequena parte do código onde verificamos se a conta do jogador exite.
```pwn
[...]
{
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
}
[...]
```
Se o jogador tiver uma conta, vamos carregar a senha dele junto com o ID da conta dele. Dessa forma, durante o login, podemos manipular e verificar se a senha que ele digitou é igual a da conta.

```pwn
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
				if(strcmp(PlayerData[playerid][pPassword], inputtext) == 0)
				{
					// Senha correta
				} else {
					// Senha incorreta.
				}
			}
		}
	}
	return 1;
}
```

Pronto, temos a base do sistema de login e agora é fácil, se o jogador acertar a senha, iremos chamar a função `Player_Load` e assim carregaremos os dados do jogador.

Só que vamos fazer mais um ajuste, vamos adicionar a variável `pWrong` no enumerador do jogador para manipular os erros de tentativas de senhas.
```pwn
enum playerData {
	[...],

	bool:pLogged,
	pWrong
};
new PlayerData[MAX_PLAYERS][playerData];
```
Certo, agora podemos continuar.

```pwn
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
```
No código acima, podemos ver que se o jogador acertar a senha armazenada em `pPassword`, carregamos os dados dele e se errar, será incrementado +1 na variável `pWrong` e se acumular 3 ou mais erros, o jogador será expulso do servidor, será considerado um invasor, já que errou a senha 3 vezes.

Na próxima aula iremos OTIMIZAR completamente o nosso código e fazer melhorias, funções, macros para facilitar nossas vidas.

# Aulas
- [Aula 9](Aulas/Aula_9.md) (Atual)
- [Aula 10](Aulas/Aula_10.md) (Próximo)