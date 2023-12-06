Antes de começar a ler, leia primeiro [Insert](https://github.com/CarlinCV/sqlite-tutorial/blob/main/Extra/insert.md), [Select](https://github.com/CarlinCV/sqlite-tutorial/blob/main/Extra/select.md) e [Update](https://github.com/CarlinCV/sqlite-tutorial/blob/main/Extra/update.md) para compreender o contexto do que estiver escrito abaixo e não se perder.

# Delete
- A instrução 'DELETE' tem sua principal função deletar uma linha de uma tabela. A instrução é formada da seguinte forma:
```sql
DELETE FROM Tabela;
```

"Pera, pera, mas como assim? Visualmente, isso apaga o que? Não precisa passar nenhuma referência?"
- Sim, precisa. Só que o comando funciona por si só, dessa forma, se você executar esse comando no seu banco de dados, provavelmente todas as informações armazenadas na tabela 'Tabela' serão apagados. Agora como eu apago algo específico? Utilize o 'WHERE'.

```sql
DELETE FROM Tabela WHERE Condição;
```
Entendeu?

Exemplos abaixos:
```sql
DELETE FROM Jogadores WHERE Nome = 'Carlos Victor';
```
Agora o jogador 'Carlos Victor' não existe mais, ele foi apagado.

ATENÇÃO!
- Essa instrução deve ter cautela, qualquer referência errada poderá afetar toda tabela, então tome cuidado antes de utilizar ela, você pode apagar todas as contas sem querer, então sempre faça um backup.