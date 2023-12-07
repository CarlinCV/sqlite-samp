# Iniciando gamemode
Irei começar com um gamemode vazio, limpo, virgem, com nada nele, o código inicial do gamemode será:
```pwn
#include <a_samp>

main(){}

public OnGameModeInit()
{
	return 1;
}
```

Não é necessário, mas caso retornar erros, inclua o `a_sampdb` no topo do seu gamemode.
```pwn
#include <a_sampdb>
```

Ele geralmente é nativo do Pawn e já está incluido em `a_samp`, mas em caso de erros, o arquivo também ficará disponível no repositório, caso precise baixar.

Para iniciarmos o SQLite no SAMP, precisamos criar uma variável que irá manipular o banco de dados, e também temos que criar a conexão com o arquivo `database.db` que criamos na [Aula 2](https://github.com/CarlinCV/sqlite-tutorial/blob/main/Aulas/Aula_2.md).

Adicionem no gamemode de vocês o seguinte código:
```pwn
#include <a_samp>

new DB:g_Handle;

main(){}

public OnGameModeInit() {
	if((g_Handle = db_open("database.db")) == DB:0) {
		printf("[SQLite]: Não foi possível conectar-se ao arquivo 'database.db'.");
		SendRconCommand("exit");
	} else {
		printf("[SQLite]: Foi conectado com sucesso ao arquivo 'database.db'.");
	}
	return 1;
}
```

Acima criamos a variável responsável pela manipulação do banco de dados, também criamos uma operação if, com a condição de que se o retorno de `db_open` for igual a `DB:0` que é considerado uma conexão inválida, retornamos um erro no console e também fechamos o servidor, afinal, se a conexão for inválida? Porque iremos continuar? Nada será carregado.

Caso o retorno de `db_open` for diferente de `DB:0` significa que deu tudo certo e que a conexão foi um sucesso e que a variável `g_Handle` já está com a conexão armazenada na variável.

Na Aula 4 irei explicar sobre as funções e já entraremos escrevendo códigos já utilizando funções do `SQLite`.

# Aulas
- [Aula 1](https://github.com/CarlinCV/sqlite-tutorial/blob/main/Aulas/Aula_1.md)
- [Aula 2](https://github.com/CarlinCV/sqlite-tutorial/blob/main/Aulas/Aula_2.md)
- [Aula 3](https://github.com/CarlinCV/sqlite-tutorial/blob/main/Aulas/Aula_3.md) (Atual)
- [Aula 4](https://github.com/CarlinCV/sqlite-tutorial/blob/main/Aulas/Aula_4.md) (Próximo)
- [Aula 5](https://github.com/CarlinCV/sqlite-tutorial/blob/main/Aulas/Aula_5.md)
- [Aula 6](https://github.com/CarlinCV/sqlite-tutorial/blob/main/Aulas/Aula_6.md)
- [Aula 7](https://github.com/CarlinCV/sqlite-tutorial/blob/main/Aulas/Aula_7.md) 
- [Aula 8](https://github.com/CarlinCV/sqlite-tutorial/blob/main/Aulas/Aula_8.md)