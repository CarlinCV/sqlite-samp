# Insert
- A instrução 'INSERT' tem sua principal função inserir algo na tabela. A instrução é formada da seguinte forma:
```sql
INSERT INTO tabela(Colunas) VALUES(Valores);
```
O que são essas colunas e valores?

# Tabelas
- As tabelas são uma parte do banco de dados, onde cada tabela tem suas colunas e valores, por exemplo, tabela dos jogadores onde irei salvar os dados dos jogadores, tabela dos veículos onde irei salvar os dados dos veículos e por assim vai. As tabelas são semelhantes a arquivos.
```sql
Tabelas:

- jogadores
- veiculos
- casas
- empresas
```

# Colunas
- As colunas são uma parte específica de uma tabela que armazena um tipo específico de informação. Em outras palavras, uma coluna representa um campo ou atributo particular em uma tabela.

Exemplo:
```sql
Coluna1		Coluna2		Coluna3
Valor1		Valor2		Valor3
Valor4		Valor5		Valor6
Valor7		Valor8		Valor9
```
E por assim vai, percebem como é uma coluna? É um campo da tabela.

# Valores
- Os valores são os valores respectivos de cada coluna, se eu quero inserir um nome na tabela Nomes, eu devo passar o valor desse nome em Valores, exemplo:
```sql
INSERT INTO Jogadores(Nome) VALUES('Carlos Victor');
```
Agora na minha tabela 'Nomes' vai ter uma linha da coluna 'Nome' com o valor 'Carlos Victor', ficará assim:
```sql
Tabelas:

- Jogadores
	| Nome 				|
	| 'Carlos Victor'	|
- Veiculos
- Empresas
- Casas
```

E se eu quiser inserir a idade? Simples. Considerando que não exista a linha 'Carlos Victor', que tem as colunas 'Nome', 'Idade', 'Level' e 'Dinheiro', vamos executar o seguinte comando:
```sql
INSERT INTO Jogadores(Nome, Idade, Level, Dinheiro) VALUES('Carlos Victor', 18, 1, 250);
```

Agora a nossa tabela vai ficar tipo assim:
```sql
Tabelas:

- Jogadores
	| Nome 				| Idade | Level	| Dinheiro
	| 'Carlos Victor'	| 18 	| 1 	| 250
- Jogadores
- Veiculos
- Empresas
- Casas
```

É fácil, se você não aprendeu ainda, continue lendo as aulas.