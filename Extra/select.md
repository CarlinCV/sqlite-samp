Antes de começar a ler, leia primeiro [Insert](https://github.com/CarlinCV/sqlite-tutorial/blob/main/Extra/insert.md) para compreender o contexto do que estiver escrito abaixo e não se perder.

# Select
- A instrução 'SELECT' tem sua principal função selecionar dados de uma tabela. A instrução é formada da seguinte forma:
```sql
SELECT Coluna FROM Tabela WHERE Condição;
```
A condição pode também ser lida como referência, iremos ler abaixo sobre.

# Condição
- As condições, podem ser interpretadas também como referências, como assim? Bom, se você selecionar a idade de um nome específico da tabela Jogadores, você deve passar a referência 'Nome' na consulta 'SELECT', senão, como você iria conseguir pegar isso?

Exemplo:
```sql
SELECT Idade FROM Jogadores WHERE Nome = 'Carlos Victor';

* Retorno: *
| Idade	| Level	| Dinheiro |
|-------|-------|----------|
| 18	| 1 	| 250      |
```
Se existir uma linha com o nome 'Carlos Victor' irá retornar linhas, e provavelmente irá retornar apenas a Idade, já é que isso que pedimos na instrução acima, pedimos que selecione apenas a coluna Idade, se você deseja pegar tudo da linha 'Carlos Victor' você pode usar o '\*' ou 'ALL' no lugar de 'Idade', da seguinte forma:

```sql
SELECT * FROM Jogadores WHERE Nome = 'Carlos Victor';

* Retorno: *
Nome			| Idade | Level	| Dinheiro
'Carlos Victor'	| 18	| 1 	| 250
```

Veja como as coisas são simples e fáceis, não é um monstro de sete cabeças, é leitura e aprendizagem.

Próximo tópico [update](https://github.com/CarlinCV/sqlite-tutorial/blob/main/Extra/update.md)