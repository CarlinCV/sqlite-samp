Caso não tenha lido a [aula 5](https://github.com/CarlinCV/sqlite-tutorial/blob/main/Aulas/Aula_5.md), recomendo que leie para prosseguir o tutorial.

## Salvamento dos dados do jogador
Na última aula, aprendemos a como consultar, verificar se uma conta (linha) existe na tabela, além de criar a função para carregar os dados do jogador e também resetar, agora iremos aprender a como salvar os dados que o jogador adquire conforme joga, como dinheiro, level, etc...

Não irei ficar colocando os códigos das aulas anteriores para evitar poluição, o arquivo completo sem comentários, só pegar compilar e usar está em [arquivos](https://github.com/CarlinCV/sqlite-tutorial/blob/main/Files).

Considerando que você tenha seu gamemode em mãos, vamos lá.
```pwn
[...]
// Vamos criar a função Player_Save.
// Nota-se que também eu sigo um padrão, que é sempre criar funções em Inglês e também com "TAG's", tipo ..._Save, ..._Load, ..._Reset, isso ajuda muito na programação e localização de funções para corrigir futuramente. Caso você não siga essa prática, eu recomendo que comece a seguir, não serve apenas para jogadores, mas para sistemas de casas tipo: House_Load, House_Save, também para veículos: Vehicle_Load, Vehicle_Save, empresas: Bussines_Load, Bussines_Save, sempre mantendo o inglês presente e a padronização que fazem jus ao o que a função significa e faz.

// Vamos lá.
Player_Save(playerid)
{
	// Vamos formatar os dados e usar a instrução 'UPDATE' para atualizar a linha do jogador na tabela Jogadores.

	format(g_Query, sizeof(g_Query), "UPDATE Jogadores SET \
		`Name`='%q',\
		`Level`='%d',\
		`Money`='%d' WHERE `ID`='%d';", 
										PlayerData[playerid][pName],
										PlayerData[playerid][pLevel],
										PlayerData[playerid][pMoney],
										PlayerData[playerid][pID]);
    db_free_result(db_query(g_Handle, result));

    /*
    	É possível notar uma diferença nessa formatação, é possível ver que usei crases, aspas simples, além de ter usado barras inversas, isso meus amigos, se chama padronização e tipagem de programação, eu sigo essa ideia de ter um gamemode organizado e padronizado, além de ser possível ler cada linha do código, eu poderia colocar tudo na mesma linha? Sim, poderia, mas ficaria algo desorganizado, totalmente cru e sem nexo, é mais fácil eu quebrar linhas sando barras inversas do que escrever tudo na mesma linha. E percebem também que eu salvo o nome do jogador, por que isso? Simples, temos o ID fixo, o nome do jogador só importa quando vamos verificar se a conta existe, depois disso, o nome pouco importa, por conta do ID Fixo, manipularemos o ID fixo ao invés do nome, o nome pode ser alterado em um sistema de name-change, agora o ID não pode e recomendo que nunca altere o ID, é possível? Sim, mas não é recomendado, e também só é possível se você acessar o banco de dados e mudar manualmente. Não recomendo mudar, mantenha o ID único do jogador até o fim do seu projeto ou servidor.

    	Utilize essa função em OnPlayerDisconnect, antes de resetar os dados do jogador, aliás, se você resetar, você vai atualizar tudo zerado.
    */
	return 1;
}

[...]
public OnPlayerDisconnect(playerid, reason)
{
	Player_Save(playerid);
	Player_Reset(playerid);
	return 1;
}
```

Vamos adicionar novas colunas e aumentar nosso banco de dados? 
Nossa tabela de jogadores atualmente está dessa forma:
| ID | Name          | Password | Money | Level |
|----|-------------- |----------|-------|-------|
| 1  | Carlos_Victor | carlos   | 250   | 1     |

Vamos adicionar as colunas `Email`, `RegisterIP`, `IP`. Todas do tipo TEXT, porque iremos manipular textos/strings.

Você pode alterar no seu editor SQL, estou utilizando o DB Browser (SQLite) ou então executar o seguinte comando no seu servidor.
```pwn
db_free_result(db_query(g_Handle, "ALTER TABLE Jogadores ADD COLUMN 'Email' TEXT DEFAULT 'N/A';"));
db_free_result(db_query(g_Handle, "ALTER TABLE Jogadores ADD COLUMN 'RegisterIP' TEXT DEFAULT 'N/A';"));
db_free_result(db_query(g_Handle, "ALTER TABLE Jogadores ADD COLUMN 'IP' TEXT DEFAULT 'N/A';"));
```

Selecione a tabela em que você quer editar, no caso iremos editar a tabela Jogadores e clique em Modificar Tabela:
![Imagem mostra como editar uma coluna no DB Browser](https://github.com/CarlinCV/sqlite-tutorial/blob/main/Imagens/image_4.png)

Adicione as novas colunas `Email`, `RegisterIP`, `IP`.
![Imagem dizendo onde adicionar e ajudando a adicionar as colunas](https://github.com/CarlinCV/sqlite-tutorial/blob/main/Imagens/image_5.png)

Depois de adicionado as colunas, pressione 'OK' para atualizar a tabela e as colunas forem adicionadas.
![Imagem mostra que ao apertar 'OK' irá atualizar a tabela](https://github.com/CarlinCV/sqlite-tutorial/blob/main/Imagens/image_5.png)

Agora a nossa tabela Jogadores está tipo assim:
| ID | Name          | Email | RegisterIP | IP  | Password | Money | Level |
|----|-------------- |-------|------------|-----|----------|-------|-------|
| 1  | Carlos_Victor | N/A   | N/A        | N/A | carlos   | 250   | 1     |

Por que os valores estão N/A? Porque definimos isso, e também como a conta já existia, os valores são adicionados automáticamente para não deixar nulos.

Na próxima aula iremos manipular essas colunas e fazer alguns comandos e sistemas.

# Aulas
- [Aula 1](https://github.com/CarlinCV/sqlite-tutorial/blob/main/Aulas/Aula_1.md)
- [Aula 2](https://github.com/CarlinCV/sqlite-tutorial/blob/main/Aulas/Aula_2.md)
- [Aula 3](https://github.com/CarlinCV/sqlite-tutorial/blob/main/Aulas/Aula_3.md)
- [Aula 4](https://github.com/CarlinCV/sqlite-tutorial/blob/main/Aulas/Aula_4.md)
- [Aula 5](https://github.com/CarlinCV/sqlite-tutorial/blob/main/Aulas/Aula_5.md)
- [Aula 6](https://github.com/CarlinCV/sqlite-tutorial/blob/main/Aulas/Aula_6.md) (Atual)
- [Aula 7](https://github.com/CarlinCV/sqlite-tutorial/blob/main/Aulas/Aula_7.md) (Próximo)
- [Aula 8](https://github.com/CarlinCV/sqlite-tutorial/blob/main/Aulas/Aula_8.md)