# Funções do SQLite
Irei explicar cada função abaixo e para que elas servem, essa aula é somente para explicar as funções do include `a_sampdb` se você já sabe como elas funcionam, pode pular para [Aula 5](https://github.com/CarlinCV/sqlite-tutorial/blob/main/Aulas/Aula_5.md).

## [db_open](https://www.open.mp/docs/scripting/functions/db_open)
- Cria uma conexão SQLite.
```pwn
db_open(name[])
name[] = Nome do 'arquivo.db' localizado em '/scriptfiles/'

Retorna o identificador de conexões SQLite, começa em 1.
```

## [db_close](https://www.open.mp/docs/scripting/functions/db_close)
- Fecha uma conexão SQLite.
```pwn
db_close(DB:db)
DB:db = Identificador da conexão SQLite (criado com db_open).

Retorno 1 se executado com sucesso e caso contrário 0.
```

## [db_query](https://www.open.mp/docs/scripting/functions/db_query)
- Cria uma consulta, retorna o identificador da consulta e aloca a memória na máquina.
```pwn
DBResult:db_query(DB:db, const query[])
DB:db = Identificador da conexão SQLite.
query[] = Consulta que iremos fazer (INSERT INTO, SELECT, UPDATE, DELETE, ....)

Retorno `DBResult` o identificador da consulta.
```

## [db_free_result](https://www.open.mp/docs/scripting/functions/db_free_result)
- Libera a memória armazenada da consulta.
```pwn
db_free_result(DBResult:dbresult)
DBResult:dbresult = Identificador da consulta (criado com o db_query).

Retorno 1 se executado com sucesso e caso contrário 0.
```

## [db_num_rows](https://www.open.mp/docs/scripting/functions/db_num_rows)
- Retorna o número de linhas de uma consulta.
```pwn
db_num_rows(DBResult:dbresult)
DBResult:dbresult = Identificador da consulta (criado com o db_query).

Retorno: Número de linhas da consulta
```

## [db_next_row](https://www.open.mp/docs/scripting/functions/db_next_row)
- Move para próxima linha da consulta.
```pwn
db_next_row(DBResult:dbresult)
DBResult:dbresult = Identificador da consulta (criado com o db_query).

Retorno 1 se executado com sucesso e caso contrário 0.
```

## [db_num_fields](https://www.open.mp/docs/scripting/functions/db_num_fields)
- Retorna o número de colunas de uma consulta.
```pwn
db_num_fields(DBResult:dbresult)
DBResult:dbresult = Identificador da consulta (criado com o db_query).

Retorna: Número de colunas de uma consulta.
```

## [db_field_name](https://www.open.mp/docs/scripting/functions/db_field_name)
- Retorna o nome de uma coluna específica.
```pwn
db_field_name(DBResult:dbresult, field, result[], maxlength)
DBResult:dbresult = Identificador da consulta (criado com o db_query).
field = Índice da coluna (Ex.: 0, 1, 2, 3)
result[] = Retorna o nome da coluna
maxlength = Tamanho da string que retornará o nome da coluna.

Retorno 1 se executado com sucesso e caso contrário 0.
```

## [db_get_field](https://www.open.mp/docs/scripting/functions/db_get_field)
- Retorna o valor (string/TEXT) de uma coluna específica.
```pwn
db_get_field(DBResult:dbresult, field, result[], maxlength)
DBResult:dbresult = Identificador da consulta (criado com o db_query).
field = Índice da coluna (Ex.: 0, 1, 2, 3)
result[] = Retorna o valor que está na coluna
maxlength = Tamanho da string de retorno (result).

Retorno 1 se executado com sucesso e caso contrário 0.
```

## [db_get_field_int](https://www.open.mp/docs/scripting/functions/db_get_field_int)
- Retorna o valor (int/INTEGER) de uma coluna específica.
```pwn
db_get_field_int(DBResult:dbresult, field = 0)
DBResult:dbresult = Identificador da consulta (criado com o db_query).
field = Índice da coluna (Ex.: 0, 1, 2, 3)

Retorna: O valor da coluna, a consulta.
```

## [db_get_field_float](https://www.open.mp/docs/scripting/functions/db_get_field_float)
- Retorna o valor (float/REAL) de uma coluna específica.
```pwn
Float:db_get_field_float(DBResult:dbresult, field = 0)
DBResult:dbresult = Identificador da consulta (criado com o db_query).
field = Índice da coluna (Ex.: 0, 1, 2, 3)

Retorna: Valor em Float da coluna em específico.
```

## [db_get_field_assoc](https://www.open.mp/docs/scripting/functions/db_get_field_assoc)
- Retorna o valor (string/TEXT) de uma coluna específica.
```pwn
db_get_field_assoc(DBResult:dbresult, const field[], result[], maxlength)
DBResult:dbresult = Identificador da consulta (criado com o db_query).
field[] = Nome da coluna 
result[] = Retorno do valor da coluna
maxlength = Tamanho da string (result).

Retorno 1 se executado com sucesso e caso contrário 0.
```

## [db_get_field_assoc_int](https://www.open.mp/docs/scripting/functions/db_get_field_assoc_int)
- Retorna o valor (int/INTEGER) de uma coluna específica.
```pwn
db_get_field_assoc_int(DBResult:result, const field[])
DBResult:dbresult = Identificador da consulta (criado com o db_query).
field[] = Nome da coluna

Retorna o valor que está alocado na coluna.
```

## [db_get_field_assoc_float](https://www.open.mp/docs/scripting/functions/db_get_field_assoc_float)
- Retorna o valor (float/REAL) de uma coluna específica.
```pwn
db_get_field_assoc_int(DBResult:result, const field[])
DBResult:dbresult = Identificador da consulta (criado com o db_query).
field[] = Nome da coluna

Retorna o valor Float que está alocado na coluna.
```

## [db_get_mem_handle](https://www.open.mp/docs/scripting/functions/db_get_mem_handle)
- Retorna o índice (identificador) da conexão SQLite.
```pwn
db_get_mem_handle(DB:db)
DB:db = Identificador da conexão SQLite (criado com db_open).

Retorna o identificador da conexão.
```

## [db_get_result_mem_handle](https://www.open.mp/docs/scripting/functions/db_get_result_mem_handle)
- Retorna o índice (identificador) da consulta SQLite.
```pwn
db_get_result_mem_handle(DBResult:dbresult)
DBResult:dbresult = Identificador da consulta SQLite (criado com db_query).

Retorna o identificador da consulta.
```

## [db_debug_openresults](https://www.open.mp/docs/scripting/functions/db_debug_openresults) & [db_debug_openfiles](https://www.open.mp/docs/scripting/functions/db_debug_openfiles)
- São funções para desenvolvimento, não iremos utilizar no tutorial, mas básicamente elas retornam a quantidade de consultas abertas e também as conexões SQLite.

Caso queira aprender sobre outras funções não relacionadas ao SQLite, procure na documentação do [Open.MP](https://www.open.mp/docs).

# Aulas
- [Aula 1](https://github.com/CarlinCV/sqlite-tutorial/blob/main/Aulas/Aula_1.md)
- [Aula 2](https://github.com/CarlinCV/sqlite-tutorial/blob/main/Aulas/Aula_2.md)
- [Aula 3](https://github.com/CarlinCV/sqlite-tutorial/blob/main/Aulas/Aula_3.md)
- [Aula 4](https://github.com/CarlinCV/sqlite-tutorial/blob/main/Aulas/Aula_4.md) (Atual)
- [Aula 5](https://github.com/CarlinCV/sqlite-tutorial/blob/main/Aulas/Aula_5.md) (Próximo)
- [Aula 6](https://github.com/CarlinCV/sqlite-tutorial/blob/main/Aulas/Aula_6.md)
- [Aula 7](https://github.com/CarlinCV/sqlite-tutorial/blob/main/Aulas/Aula_7.md) 
- [Aula 8](https://github.com/CarlinCV/sqlite-tutorial/blob/main/Aulas/Aula_8.md)