# O que é SQL Inject?
SQL Injection é uma técnica de ataque cibernético em que um invasor insere código SQL malicioso em uma consulta SQL. Isso geralmente ocorre em campos de entrada de dados, como formulários da web, onde os dados inseridos pelos usuários não são devidamente validados ou escapados. O objetivo principal do ataque é manipular a consulta SQL para obter acesso não autorizado ao banco de dados, excluir dados, modificar registros ou realizar outras ações prejudiciais.

Para prevenir ataques de injeção SQL, é crucial usar práticas de programação seguras, como a parametrização de consultas SQL, validação de entrada de dados e o uso de funções que escapam caracteres especiais. Além disso, a implementação de princípios de menor privilégio e a aplicação de firewalls de aplicativos da web podem ajudar a fortalecer a segurança contra esse tipo de ataque.

# Exemplos
Em nossa última aula, atualizando o e-mail do jogador atráves de um comando, o jogador malicioso poderia:
```sql
UPDATE Jogadores SET Email = '%s' WHERE ID = '%d';
```
Como ele faz isso? Simples, nós damos ao jogador essa consulta e portanto, se ele tentasse:
```pwn
/email carlos@gmail.com'; UPDATE Jogadores SET Password = '123456'; --
```
E portanto, quando ele insere esse código malicioso, ele trocaria o email e senha de todas as contas para 'carlos@gmail.com' e '123456' e dessa forma ele poderia acessar contas administrativas e fazer diversas outras consultas, como apagar tudo, dessa forma:
```sql
UPDATE Jogadores SET Email = 'email@gmail.com'; DELETE FROM Jogadores; --' WHERE ID = '%d';
```
E kabum, você perdeu todas as contas registradas em seu servidor. Existem alternativas para evitar isso? Sim. As alternativas para evitar que seu servidor seja alvo de SQL Inject é:

- Não expor nome de suas tabelas.
- Evitar dar consultas públicas sem uma segurança mínima.
- Ter um registro de todas as consultas feitas por jogadores.
- Utilizar métodos anti SQL Inject, como escapar string's, etc...

# Escape SQL
O escape em uma query SQL é uma técnica usada para tratar caracteres especiais de forma que não sejam interpretados erroneamente como parte do código SQL. Isso é particularmente importante para evitar ataques de injeção SQL, onde um invasor pode inserir caracteres maliciosos para manipular a consulta.

A ideia é transformar os caracteres especiais em uma forma que não seja interpretada como parte da sintaxe SQL. Um método comum é adicionar uma barra invertida (\\) antes do caractere especial. Por exemplo, se um usuário insere uma aspa simples (') em um campo, ela pode ser escapada como (\\') para garantir que seja tratada como um caractere literal e não como parte de uma string SQL.

Vamos dar um exemplo prático. Considere a seguinte consulta SQL sem escape:
```sql
SELECT * FROM usuarios WHERE nome_usuario = '$nome_usuario';
```

Agora, imagine que o usuário insira o seguinte como nome de usuário:
```sql
' OR '1'='1'; --
```

A consulta resultante seria:
```sql
SELECT * FROM usuarios WHERE nome_usuario = '' OR '1'='1'; --';
```

Agora, se a entrada do usuário for adequadamente escapada, isso seria tratado como uma string literal:
```sql
SELECT * FROM usuarios WHERE nome_usuario = '\' OR \'1\'=\'1\'; --';
```

Dessa forma, o banco de dados entenderá que os caracteres especiais não têm um significado especial na sintaxe SQL e não serão interpretados de maneira maliciosa. O uso adequado de escapes, juntamente com técnicas como consultas parametrizadas, é essencial para prevenir ataques de injeção SQL.



# Sobre o especificador (%q)
Se você deseja ler mais sobre especificadores, [clique aqui](https://www.open.mp/docs/scripting/functions/format), iremos aqui abordar apenas o especificador `%q`.


> %q `Escape de um texto para SQLite. (Adicionado em 0.3.7 R2)`
Antes da versão do SA:MP `0.3.7 R2` era necessário utilizar a função `DB_Escape` para escapar as string's e de fato era um trabalhão, imagina ter que usar essa função toda vez que você for atualizar, inserir ou fazer algo usando SQLite, ainda mais quando seu gamemode todo for em SQL. (Eu acredito que por isso o pessoal opitava por salvamentos de texto mesmo não servindo para manipular dados em massa).

Essa função quebra o SQL Inject adicionando aspas simples `'` quando é utilizado o `%q` no format, assim o código malicioso não torna-se um comando interpretado no SQL, e torna-se um texto comum e não afeta a sua tabela.

Um exemplo básico e simples
```pwn
1°: db_query(DB:db, "UPDATE `contas` SET Name = 'Ninguem''; DELETE FROM `contas`; --' WHERE ID = '4';");

2°: db_query(DB:db, "UPDATE `contas` SET Name = 'Ninguem'; DELETE FROM `contas`; --' WHERE ID = '4';");
```
O 1° é utilizado o `%q` em `Name = '%q'` e no 2° eu não utilizo o `%q`, `Name = '%s'`, olhando as query's acima é possível ver a diferença.

Usando escape:
```sql
UPDATE contas SET Name = 'Ninguem''; DELETE FROM contas; --' WHERE ID = '4';
```
Aqui, a aspa simples dentro do valor `'Ninguem'` é escapada como `''`, o que significa que o banco de dados entenderá corretamente que você está inserindo o valor `Ninguem'; DELETE FROM contas; --` na coluna `Name` do registro com ID 4. Isso evita que o comando DELETE seja interpretado erroneamente como parte da mesma instrução SQL.

Não usando escape:
```sql
UPDATE contas SET Name = 'Ninguem'; DELETE FROM contas; --' WHERE ID = '4';
```
Neste caso, sem a escape adequada, o comando SQL seria interpretado de maneira diferente. O banco de dados pode executar tanto a atualização quanto a exclusão, dependendo da configuração específica. Isso pode resultar em consequências indesejadas, como a exclusão de registros da tabela `contas` de forma não intencional.

-----
Então, está explicado a SEGURANÇA, o MOTIVO e a NECESSIDADE de utilizar o `%q` em consultas abertas no SQLite, no MySQL tem o `%e` que funciona da mesma forma.

De recomendação, eu sempre utilizo o `%q` quando estou mexendo com o SQLite, é uma boa prática e dessa forma eu não preciso me preocupar com SQL Inject.

Recomendo a vocês que sempre utilizem o `%q` até mesmo em consultas privadas que não sejam públicas, é uma boa prática e salva a vida de muitos, também recomendo um método de backup, nunca se sabe... Um código que também lê e procura falhas mitigadas usando o Escape e apagando no banco de dados essa falhas. Sempre tome cuidado com essas coisas, existem métodos de segurança e você nunca deve achar que é muita segurança, sempre será pouca e você sempre deve colocar mais e mais segurança.

# Aulas
- [Aula 1](https://github.com/CarlinCV/sqlite-tutorial/blob/main/Aulas/Aula_1.md)
- [Aula 2](https://github.com/CarlinCV/sqlite-tutorial/blob/main/Aulas/Aula_2.md)
- [Aula 3](https://github.com/CarlinCV/sqlite-tutorial/blob/main/Aulas/Aula_3.md)
- [Aula 4](https://github.com/CarlinCV/sqlite-tutorial/blob/main/Aulas/Aula_4.md)
- [Aula 5](https://github.com/CarlinCV/sqlite-tutorial/blob/main/Aulas/Aula_5.md)
- [Aula 6](https://github.com/CarlinCV/sqlite-tutorial/blob/main/Aulas/Aula_6.md)
- [Aula 7](https://github.com/CarlinCV/sqlite-tutorial/blob/main/Aulas/Aula_7.md)
- [Aula 8](https://github.com/CarlinCV/sqlite-tutorial/blob/main/Aulas/Aula_8.md) (Atual)
- [Aula 9](https://github.com/CarlinCV/sqlite-tutorial/blob/main/Aulas/Aula_9.md) (Próximo)