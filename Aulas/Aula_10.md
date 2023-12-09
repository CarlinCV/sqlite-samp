# Otimizando o gamemode
Nesse aulão 10, vamos otimizar e usar tudo que temos direito para o nosso servidor, vamos criar macros e adicionar novos plugins e includes.

# Include's e plugin's
- [streamer](https://github.com/samp-incognito/samp-streamer-plugin/releases)
- [sscanf2](https://github.com/Y-Less/sscanf/releases)
- [Pawn.CMD](https://github.com/katursis/Pawn.CMD/releases)

- [easyDialog](https://github.com/Awsomedude/easyDialog/releases)

## streamer
O `streamer` é um plugin dinâmico que otimiza e manipula criações de interações in-game, desde objetos, pickups, text 3d até areas, checkpoints, etc... É um plugin necessário que deveria ser inclusive nativo. Ele é perfeito para servidores que utilizam muitas desses itens que possuem limite, já que seu funcionamento é dinâmico, ele só carrega/cria o necessário, se algo não estiver sendo renderizado, ele não será carregado.

## sscanf2
O `sscanf2` é crucial para extrair dados estruturados básicos de uma string. Isto é, você consegue separar dados de um string com expressões e específicadores, tendo controle total da estrutura exata dos dados. Bom simples especificadores conseguimos por exemplo pegar a string "5 dinheiro 250" e separar isso e atribuir esses dados para variáves e assim setar '250' de 'dinheiro' no ID '5'.

## Pawn.CMD
O `Pawn.CMD` como o nome diz é um processador de comandos Pawn, é muito bom e tem diversas funções interessantes nele que usaremos no futuro, aliases, flag's, callbacks etc... É atualmente um dos melhores e mais rápidos processadores de comandos do SA:MP, iremos utilizar para melhorar a criação de comandos e facilitar nossas vidas.

## easyDialog
O `easyDialog` é um include que facilita a estruturação e retorno dos Dialog's, semelhante a callbacks conseguimos tornar a responsiva de cada dialog de forma simples, fácil e estruturada, não se perdendo no código e nem ficando com dificuldade de compreender, veremos no futuro exemplos e como ele funciona.

Para adicionar todos esses includes e plugins acima, vamos fazer no inicio do gamemode:
```pwn
#include <a_samp>

#include <streamer>
#include <sscanf2>

#include <Pawn.CMD>
#include <easyDialog>
[...]
```
Para plugins, os arquivos `.dll` ou `.so` (depende do seu sistema operacinal, Windows e Linux respectivamente) serão extraidos para a pasta `plugins` (se não existir, crie) no diretório do seu servidor.

Também devemos incluir o nome desses plugins no arquivo `server.cfg` que está no diretório do seu servidor.
```cfg
[...]
plugins streamer sscanf2 pawncmd
```

Pronto! Agora compile seu gamemode para atualizar os includes e já pode iniciar seu servidor com os plugins e includes carregados.

# Macros e funções
Para a facilitação de nossas vidas, existe o macro que como seu nome diz, ele simplifica algo que seria gigante, para algo simples e básico, então ao invés de você por exemplo, criar uma variável string, formatar essa variável, depois enviar para o jogador, é possível criar um macro que faça isso automáticamente e nós apenas passamos os paramêtros `playerid` e a `string` COM um adicional que é a formatação, caso haja.

O primeiro macro é para o `SendClientMessage` e também o `SendClientMessageToAll`, adicione no final do seu gamemode o seguinte código:
```pwn
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
```

Pronto, agora um código que seria escrito assim:
```pwn
new string[128], name[MAX_PLAYER_NAME];
GetPlayerName(playerid, name, sizeof(name));

format(string, sizeof(string), "* Olá mundo! Seja bem-vindo(a) %s.", name);
SendClientMessage(playerid, -1, string);
```

Agora poderá ser escrito assim:
```pwn
new name[MAX_PLAYER_NAME];
GetPlayerName(playerid, name, sizeof(name));

SendClientMessageEx(playerid, -1, "* Olá mundo! Seja bem-vindo(a) %s.", name);
```
Notaram a diferença? Pode ser mínima? Pode, mas se você pegar por exemplo em um arquivo ou gamemode de 50 mil linhas, é uma diferença absurda que faz! Ainda mais quando você souber que podemos criar outro macro que não precisa desse `GetPlayerName`!

No nosso tutorial, nós armazenamos o nome e o IP do jogador em uma variável do enumerador `playerData`, certo? Então, podemos então fazer dessa forma um macro que retorne o nome do jogador, atráves do `playerid`.
```pwn
[...]
new PlayerData[MAX_PLAYERS][playerData];

#define ReturnName(%0) (PlayerData[%0][pName])
```

E pronto, agora podemos utilizar a função `ReturnName` para pegar o nome do jogador, então o código já otimizado de cima poderá ficar mais otimizado ainda, da seguinte forma:
```pwn
SendClientMessageEx(playerid, -1, "* Olá mundo! Seja bem-vindo(a) %s.", ReturnName(playerid));
```

Legal né? Então, o que era antes 4 linhas, virou 3 e agora uma só. Esse é o poder da otimização, e o melhor ainda, é que dessa forma é mais otimizado do que ficar criando variáveis e variáveis por aí para fazer a mesma função que um macro faria, como eu disse, em um código pequeno como esse, não pode fazer tanta diferença, mas se você pegar um gamemode ou um servidor já estruturada, você verá que terá diferença, até mesmo no consumo de memória do servidor.

Aproveitando essa aula, irei também disponibilizar algumas definições de cores, para utilizarmos no tutorial.
```pwn
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
```

Essas cores poderão ser usadas com a função `SendClientMessageEx`. Exemplo:
```pwn
SendClientMessageEx(playerid, COLOR_GREEN, "* Mensagem verde.");
SendClientMessageEx(playerid, COLOR_YELLOW, "* Mensagem amarela.");
SendClientMessageEx(playerid, COLOR_CYAN, "* Mensagem ciano.");
SendClientMessageEx(playerid, COLOR_RED, "* Mensagem vermelho.");
```

--------------------------------

Agora, alguns macros uteis.
```pwn
#define callback%0(%1) \
	forward%0(%1); public%0(%1)
```

Esse macro, otimiza a criação de publics, uma callback normal seria:
```pwn
forward MyPublic(params);
public MyPublic(params)
{

	return 1;
}
```

E com o macro você pode fazer:
```pwn
callback MyPublic(params)
{

	return 1;
}
```

Um macro útil também é
```pwn
#define Kick(%0) \
	SetTimerEx("KickPlayer", 200, false, "i", %0)

[...]

forward  KickPlayer(playerid);
public KickPlayer(playerid)
{
    #undef Kick

    Kick(playerid);

    #define Kick(%0) \
    	SetTimerEx("KickPlayer", 200, false, "i", %0)

	return 1;
}
```

No SA:MP tem um problema que o `Kick` é mais rápido do que uma mensagem, então por padrão, se você fizer:
```pwn
SendClientMessage(playerid, COLOR_RED, "* Você foi expulso do servidor por suspeitas de cheater.");
Kick(playerid);
```

Provavelmente o jogador não irá ver a mensagem, porque ele foi expulso e não deu tempo dele receber a mensagem no seu cliente. Utilizando aquele macro, após utilizar a função `Kick`, o jogador será expulso em 300ms.

Por enquanto, eu já que isso tudo já serve, vamos continuar as aulas e implementar isso tudo no seu gamemode. Para implementar isso, os macros deixem eles no topo, as funções deixem no final do gamemode, o macro `ReturnName` deixa em baixo de `new PlayerData[...`. As cores ficam lá em cima também, e é isso. Caso tenha dúvidas, o arquivo do gamemode atualizado está em [Files](../Files/gamemode.pwn).

# Aulas
- Aula 10 (Atual)
- [Aula 11](../Aulas/Aula_11.md) (Próximo)