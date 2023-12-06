Antes de começar a ler, leia primeiro [Insert](https://github.com/CarlinCV/sqlite-tutorial/blob/main/Extra/insert.md) e [Select](https://github.com/CarlinCV/sqlite-tutorial/blob/main/Extra/select.md) para compreender o contexto do que estiver escrito abaixo e não se perder.

# Update
- A instrução 'UPDATE' tem sua principal função atualizar uma linha de uma tabela. A instrução é formada da seguinte forma:
```sql
UPDATE Tabela SET Coluna = Valor WHERE Referência;
```
Sobre os parâmetros, se você não sabe, leia [insert](https://github.com/CarlinCV/sqlite-tutorial/blob/main/Extra/insert.md) e também [select](https://github.com/CarlinCV/sqlite-tutorial/blob/main/Extra/select.md) que irá compreender.

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

Próximo tópico [delete](https://github.com/CarlinCV/sqlite-tutorial/blob/main/Extra/delete.md)