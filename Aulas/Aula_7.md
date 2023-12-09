# Manipulando colunas
Nessa aula, iremos manipular as colunas que criamos na aula passada, que são a `Email`, `RegisterIP` e `IP`.

A coluna `Email` irá armazenar o e-mail do jogador, ele poderá adicionar esse e-mail com um comando, lembre-se que o e-mail do jogador serve como um código de verificação, caso ele perca a senha ou o acesso da conta, você pode utilizar esse e-mail como um método de recuperação. Não compartilhe informações pessoais de seus jogadores, eles confiam no servidor e aproveitando sobre esse assunto, recomendo lerem sobre [SHA256](https://github.com/PawnTeam/Criptografia-Nativa-/tree/main) uma explicação sobre criptografia que eu ajudei a fazer.

Continuando...
As colunas `RegisterIP` e `IP` iremos armazenar o IP do jogador, é necessário armazenar o IP de registro? Eu recomendo que sim, dessa forma você consegue descobrir outras contas de uma mesma pessoa que sei lá, utilizou cheater no seu server ou fez algo e você deve banir todas as contas dessa pessoa, então eu recomendo fazer dessa forma.

A coluna `RegisterIP` iremos utilizar apenas uma vez em todo código, apenas quando criarmos a conta do jogador, já que é o IP de registro, só podemos atualizar quando ele se registrar, concorda?

```pwn
[...]

// Então na consulta de vocês, do INSERT INTO no registro, adicionem:

format(g_Query, sizeof(g_Query), "INSERT INTO Jogadores(Name, Password, RegisterIP) VALUES('%q', '%q', '%q');", PlayerData[playerid][pName], inputtext, PlayerData[playerid][pIP]);
```
Pronto, agora quando um jogador tiver sua conta registrada, o IP dele do registro já será salvo na coluna `RegisterIP`. Agora precisamos atualizar a coluna `IP` toda vez que ele logar, já que toda conexão é um IP diferente ou não, mas pode mudar a cada conexão.

```pwn
[...]

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

		format(g_Query, sizeof(g_Query), "UPDATE Jogadores SET IP = '%q' WHERE ID = '%d';", PlayerData[playerid][pIP], PlayerData[playerid][pID]);
		db_free_result(db_query(g_Handle, g_Query));
	}
	db_free_result(result);
	
	GivePlayerMoney(playerid, PlayerData[playerid][pMoney]);
	SetPlayerScore(playerid, PlayerData[playerid][pLevel]);

	SpawnPlayer(playerid);
	return 1;
}
```
Iremos salvar o IP do jogador caso a conta dele for carregada, percebam que eu utilizo a mesma string para formatar, já que eu não irei precisar dela mais no código, eu utilizo e ainda mais, eu faço a query e já libero a memória dentro da função, percebe que uma coisa leva a outra? Eu matei dois coelhos com uma cajadada só.

É essa ideia que vocês precisam ter de programação, se tiver alguma forma de otimizar o seu código, otimize. Existem funções que otimiza isso, mas irei deixar esse assunto para uma próxima aula, estamos ainda no básico e explicando sobre algumas consultas, etc...

## Comando (/email)
Vamos agora criar um comando onde o jogador poderá inserir um email na sua conta.

O processador de comandos, você pode utilizar da sua forma, utilizarei o [Pawn.CMD](https://github.com/katursis/Pawn.CMD) para isso.
```pwn
CMD:email(playerid, params[])
{
	static
		string[148];

	if(isnull(params))
		return SendClientMessage(playerid, -1, "* /email [E-mail]");

	if(IsValidEmail(params) == 0)
		return SendClientMessage(playerid, -1, "* E-mail inválido, tente novamente.");

	format(g_Query, sizeof(g_Query), "UPDATE Jogadores SET Email = '%q' WHERE ID = '%d';", params, PlayerData[playerid][pID]);
	db_free_result(db_query(g_Handle, g_Query));

	format(string, sizeof(string), "* Você alterou seu e-mail para: %s", params);
	SendClientMessage(playerid, -1, string);	
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
```

Na próxima aula irei explicar sobre o `SQL Inject` e também sobre o específicador `%q` que eu utilizo bastante.

# Aulas
- [Aula 7](https://github.com/CarlinCV/sqlite-samp/blob/main/Aulas/Aula_7.md) (Atual)
- [Aula 8](https://github.com/CarlinCV/sqlite-samp/blob/main/Aulas/Aula_8.md) (Próximo)