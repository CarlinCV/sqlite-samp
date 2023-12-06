# Update
- A instrução 'UPDATE' tem sua principal função atualizar uma linha de uma tabela. A instrução é formada da seguinte forma:
```sql
UPDATE Tabela SET Coluna = Valor WHERE Referência;
```
Sobre os parâmetros, se você não sabe, leia [insert](https://github.com/CarlinCV/sqlite-tutorial/raw/CarlinCV/Extra/insert.md) e também [select](https://github.com/CarlinCV/sqlite-tutorial/raw/CarlinCV/Extra/select.md) que irá compreender.

Dessa forma, você pode atualizar linhas e dados da seguinte forma:
```sql
UPDATE Jogadores SET Idade = 24 WHERE Nome = 'Carlos Victor';
```
Nesse comando, eu atualizei a idade da coluna 'Carlos Victor' para 24 na tabela Jogadores, ou seja, antes a idade era 18, agora é 24.

Você também pode atualizar outras coisas, como o level e o dinheiro, etc...
```sql
UPDATE Jogadores SET Idade = 21, Level = 5, Dinheiro = 840 WHERE Nome = 'Carlos Victor';
```
Percebam que eu atualizei várias colunas de uma única vez? Sim, você pode atualizar de uma vez só várias colunas.