Se não souber de nenhuma função SQLite e para o que elas servem, recomendo que leia a [Aula 4](https://github.com/CarlinCV/sqlite-tutorial/blob/main/Aulas/Aula_4.md) onde foi explicado sobre todas as funções do SQLite.

## Começando o SQLite
Com os códigos inicias já feitos, como a conexão com o SQLite, podemos partir para um sistema de registro de jogadores. Criaremos então um enumerador para armazenar as variáveis dos jogadores.
```pwn
#include <a_samp>

#define MAX_LENGTH_IP (16) // Definimos o valor do tamanho de um IP para facilitar no código.

// Um enumerador automáticamente enumera as variáveis do índice 0 como um autoincrement, então uma dica aí para criar id's de dialog é fazer dessa forma:
enum {
	DIALOG_LOGIN,
	DIALOG_REGISTER
};

enum playerData {
	pID, // Variável que iremos armazenar o ID único/fixo de cada jogador.
	pName[MAX_PLAYER_NAME], // Armazenaremos o nome do jogador aqui
	pIP[MAX_LENGTH_IP], // Armazenaremos o IP do jogador
	pPassword, // Armazenaremos a senha do jogador aqui

	pLevel, // Armazenaremos o level do jogador aqui
	pMoney, // Armazenaremos o dinheiro do jogador aqui 

	bool:pLogged // Iremos manipular essa variável para saber se o jogador logou ou não.
};
new PlayerData[MAX_PLAYERS][playerData];

new DB:g_Handle;
new g_Query[1024]; //Variável para formatar query's e evitar muitas memórias inúteis da máquina.

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
	// Aqui estamos armazenando alguns dados do jogador como nome e IP.
	GetPlayerName(playerid, PlayerData[playerid][pName], MAX_PLAYER_NAME);
	GetPlayerIp(playerid, PlayerData[playerid][pIP], MAX_LENGTH_IP);

	static
		DBResult:result; // Essa variável é responsável por manipular a consulta que iremos fazer, é ela que armazenará o identificador da consulta abaixo

	// Aqui formatamos a consulta para implementar o nome do jogador ali na referência, aliás, queremos saber se o jogador tem uma conta, certo? Então precisamos consultar o nome do jogador em especifico.
	format(g_Query, sizeof(g_Query), "SELECT * FROM Jogadores WHERE Name='%q';", PlayerData[playerid][pName]);
	// Notem que aqui eu utilizei o '*', como expliquei no arquivo INSERT.md, o '*' funciona para selecionarmos todas as colunas ao invés de uma específica

	result = db_query(g_Handle, g_Query);
	// Aqui lançamos a consulta na nossa conexão g_Handle formatada ali no OnGameModeInit e também a string formatada e o retorno é armazenado na variável 'result' (resultado).

	// Essa função é responsável por retornar a quantidade de linhas de uma consulta, aqui eu verifico se ela retornou mais do que zero linhas, ou seja, 1, 2, 3, 4.... Se sim, significa que o jogador possui uma conta.
	if(db_num_rows(result) > 0) {
		ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Login", "Seja bem-vindo(a)! Insira sua senha para logar:", "Confirmar", "X");
		// A consulta retornou linhas, então existe uma linha com o nome do jogador, ou seja, ele possui conta
	} else {
		ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_INPUT, "Registro", "Seja bem-vindo(a)! Insira uma senha para registrar sua conta:", "Confirmar", "X");
		// Não retornou nenhuma linha, então o jogador não possui uma conta.
	}

	// Aqui liberamos a consulta e a memória alocada na máquina, é obrigatório sempre liberar a consulta depois de usado, não é recomendado ficar armazenando algo que você não vai utilizar.
	db_free_result(result);
	return 1;
}

// Variável responsável por retornar as ações feitas em um dialog
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid)
	{
		// Vamos primeiro manipular o registro e depois o login
		case DIALOG_REGISTER:
		{
			// Nesse registro, vamos coletar apenas a senha para registrar o jogador, a senha deverá ter de 4-32 caracteres, é bom definir um valor mínimo e máximo para evitar problemas.

			// Aqui verificamos se a senha for menor que 4 ou maior que 32 retornamos o mesmo dialog porém com a mensagem de erro
			if(strlen(inputtext) < 4 || strlen(inputtext) > 32)
				return ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_INPUT, "Registro", "ERRO: Sua senha deve ter de 4-32 caracteres.\n\nSeja bem-vindo(a)! Insira uma senha para registrar sua conta:", "Confirmar", "X");

			// Se a senha for inserida entre 4-32 caracteres, podemos proseguir
			// Então, criaremos a conta do jogador fazendo uma consulta simples, vocês lembra qual é a instrução/comando responsável por inserir algo na tabela? Em? INSERT INTO.
			format(g_Query, sizeof(g_Query), "INSERT INTO Jogadores(Name, Password) VALUES('%q', '%q');", PlayerData[playerid][pName], inputtext);
			db_free_result(db_query(g_Handle, g_Query));

			// Pronto? Só isso? SIM! É fácil não é? Preciso explicar o que foi feito? Sim.

			/* 
				O que fizemos acima foi inserir o nome e a senha do jogador na tabela Jogadores, como lá no inicio eu defini algumas colunas padrões como Level(1) e Dinheiro(250) eu não preciso agora também passar um valor no INSERT INTO, e vocês lembram daquela coluna ID? Ela também não precissa ser passada já que é AUTOINCREMENT, ou seja, é auto incrementada

				Também, percebe-se que eu matei dois coelhos em uma cajadada só, eu utilizei o db_query dentro do db_free_result, por que? Porque eu não vou utilizar o resultado dessa consulta, eu nem consulta estou fazendo, então não tem a necessidade de criar uma variável para manipular isso, de certa forma se você seguir esse tutorial não terá problema com inserir dados, mas caso tenha, faça um debug e verifique se está tudo correto.

				Agora que inserimos a conta do jogador, podemos carregar ele no servidor, porque ele já tem uma conta.
			*/

			// Utilizaremos uma função para evitar códigos, criaremos uma função chamada Player_Load
			Player_Load(playerid); // Passamos como parametro o playerid, que é o nosso jogador
		}
	}
	return 1;
}

Player_Load(playerid)
{
	// Para carregarmos as informações do jogador aqui, precisamos fazer uma nova consulta e dessa vez, iremos utilizar uma variável para manipular a consulta e posteriormente pegar os dados corretos.

	// Esse código já foi explicado acima, em OnPlayerConnect, mas é simples, eu formato a consulta referenciando o nome do jogador na tabela Jogadores e verifico se retorna linhas, precisa dessa verificação? Sim, é sempre bom uma segurança a mais, se caso acontecer um problema no Login, você terá uma segurança quando for carregar o jogador e também liberamos a memória alocada na máquina usando a função db_free_result.
	static
		DBResult:result;

	format(g_Query, sizeof(g_Query), "SELECT * FROM Jogadores WHERE Name = '%q';", PlayerData[playerid][pName]);
	result = db_query(g_Handle, g_Query);

	if(db_num_rows(result) > 0) {
		// Por que eu usei 'db_get_field_assoc_int' ao invés de 'db_get_field_int'? Porque a nossa consulta, selecionamos todas as colunas, geralmente o db_get_field_int é usado para consultas em colunas especificas, iremos ver isso nas próximas aulas.
		PlayerData[playerid][pID] = db_get_field_assoc_int(result, "ID");

		PlayerData[playerid][pLevel] = db_get_field_assoc_int(result, "Level");
		PlayerData[playerid][pMoney] = db_get_field_assoc_int(result, "Money");	

		// Precisamos informar a variável 'pLogged' que o jogador foi logado e carregado.
		PlayerData[playerid][pLogged] = true;
	}
	db_free_result(result);

	// Depois de tudo selecionado e carregado, podemos spawnar o jogador	
	GivePlayerMoney(playerid, PlayerData[playerid][pMoney]);
	SetPlayerScore(playerid, PlayerData[playerid][pLevel]);

	SpawnPlayer(playerid);

	// Eu prefiro primeiro mexer na consulta e depois manipular o jogador, já que o Pawn é lido de cima para baixo, acredito que dependendo do código e como for feito, pode atrapalhar e assim afetando a consulta.	

	// Apenas nesse código, o jogador já tem seus dados inseridos na tabela e também é feito o registro, para finalizar o código, iremos resetar os dados quando ele for desconectado.
	// Para quem não sabe, é necessário resetar as variáveis para ela não ser passada para o próximo jogador que conectar-se.
	return 1;
}

// Para isso, vamos criar uma função chamada 'Player_Reset' fazendo jus ao o que a função faz, resetar o player (jogador)
Player_Reset(playerid)
{
	// Aqui, irei utilizar o famoso dummy reset, para quem não sabe, pode resetar um enumerador por completo ao igualar ao enumerador vazio, da seguinte forma:
	static
		dummy[playerData]; // Percebe que eu atribui a variável 'dummy' o enumerador 'playerData'? Agora a variável 'dummy' tem todos os valores de 'playerData' de forma resetada, padronizada.

	// Padronizada como assim? Todas as variáveis tem sua forma padrão, tipo o inteiro é 0, float é 0.0, boolean é false e string é '' (NULO)
	PlayerData[playerid] = dummy;
	// Pronto, resetamos tudo, o que antes era pID = 1, agora é pID 0, se antes a variável pMoney armazenava 250 agora armazena 0.

	// Depois de resetar todo enumerador, você ainda pode continuar manipulando a variável PlayerData, você pode definir por padrão o que você quiser, mas lembre-se que isso pode afetar seu código, então se for padronizar algo, padronize seu código com o valor que irá definir aqui.
	PlayerData[playerid][pID] = -1;
	// Eu acabei de definir que todo jogador que não se conectou tem a variável pID -1, eu posso usar essa informação em loopings ou em outros sistemas.

	// E por fim, é isso, essa função será utilizada em OnPlayerDisconnect.
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	Player_Reset(playerid);
	return 1;
}
```

Na próxima aula iremos fazer a função de salvar os dados do jogador e criar novas colunas para novos dados.

# Aulas
- [Aula 1](https://github.com/CarlinCV/sqlite-tutorial/blob/main/Aulas/Aula_1.md)
- [Aula 2](https://github.com/CarlinCV/sqlite-tutorial/blob/main/Aulas/Aula_2.md)
- [Aula 3](https://github.com/CarlinCV/sqlite-tutorial/blob/main/Aulas/Aula_3.md)
- [Aula 4](https://github.com/CarlinCV/sqlite-tutorial/blob/main/Aulas/Aula_4.md)
- [Aula 5](https://github.com/CarlinCV/sqlite-tutorial/blob/main/Aulas/Aula_5.md)
- [Aula 6](https://github.com/CarlinCV/sqlite-tutorial/blob/main/Aulas/Aula_6.md) (Atual)
- [Aula 7](https://github.com/CarlinCV/sqlite-tutorial/blob/main/Aulas/Aula_7.md) (Próximo)
- [Aula 8](https://github.com/CarlinCV/sqlite-tutorial/blob/main/Aulas/Aula_8.md)