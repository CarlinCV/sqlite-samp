# Instalando
Vamos começar a praticar? Para isso, você precisa instalar alguns programas.

- [DB Browser (SQLite)](https://sqlitebrowser.org/dl/) - Utilizarei no tutorial.
- [HeidiSQL](https://www.heidisql.com/download.php)

Ambos programas acima abrem os arquivos e vai te ajudar a manipular o banco de dados de forma mais acessível e prática. Para o pessoal que está vendo isso no celular, eu não conheço os aplicativos, então procurem um app que consigam fazer edições SQL pelo celular.

# Criando banco de dados SQLite
Para criar um banco de dados para executarmos no SAMP, você precisa criar um arquivo `.db` na pasta `scriptfiles`, o nome eu recomendo que seja database para você saber que aquela é a database do seu servidor.
> `scripfiles/database.db`

O arquivo inicialmente não terá nada, óbvio. Então você poderá abrir ele no seu editor SQL.
![Imagem mostrando o programa DB Browser em sua página inicial.](Imagens/image_1.png)

# Criando tabelas
Você irá clicar no botão 'Criar tabela' localizado no canto esquerdo superior.
![Imagem mostrando o botão 'Criar tabela' do programa DB Browser.](Imagens/image_2.png)

![Imagem especificando cada conteúdo, input de uma criação de tabela.](Imagens/image_3.png)

Você irá criar uma tabela chamada `Jogadores` para iniciarmos os trabalhos e práticas no servidor SAMP.
Vamos inicialmente manipular apenas alguns dados, futuramente será ensinado como adicionar outras colunas em uma tabela, etc...

O código da tabela `Jogadores` deverá ficar semelhante a isto:
```sql
CREATE TABLE "Jogadores" (
	"ID"	INTEGER,
	"Name"	TEXT NOT NULL,
	"Password"	TEXT NOT NULL,
	"Money"	INTEGER DEFAULT 250,
	"Level"	INTEGER DEFAULT 1,
	PRIMARY KEY("ID" AUTOINCREMENT)
);
```

Vamos a explicação do comando acima?

## CREATE TABLE
A instrução `CREATE TABLE` tem por sua vez, a função de criar uma tabela, sua forma é:
```sql
CREATE TABLE Tabela(Coluna ValueType);
```
No SQLite temos 5 tipos de valores, eles são:
- `INTEGER` Armazena números inteiros, que podem ser positivos ou negativos. (Ex.: 1, -5, 500)
- `TEXT` Armazena texto ou cadeias de caracteres. (Ex.: 'Olá mundo!', 'Carlos Victor', 'SQLite Tutorial')
- `BLOB` Armazena dados binários, como imagens, arquivos ou qualquer tipo de dados não interpretado. (Ex.: Imagens codificadas em binário.)
- `REAL` Armazena valores de ponto flutuante, ou seja, números com casas decimais. (Ex.: 3.14, -0.5, 2.0)
- `NUMERIC` Armazena valores numéricos. Pode ser usado para armazenar inteiros ou números de ponto flutuante. (Ex.: 42, 3.14, -100)

## PRIMARY KEY
A cláusula `PRIMARY KEY` é usada para definir uma coluna (ou um conjunto de colunas) como chave primária da tabela. A chave primária é usada para identificar de forma única cada linha na tabela. Cada tabela geralmente tem uma chave primária que garante que cada linha possa ser distinguida de maneira única.

Essa chave primária é uma chave única, na tabela ela nunca se repete, se você tentar inserir uma chave primária que já está na tabela, receberá um erro e a consulta não será finalizada.

## AUTOINCREMENT
A cláusula `AUTOINCREMENT` é usada em conjunto com a `PRIMARY KEY` para criar uma chave primária que é automaticamente incrementada para cada nova linha adicionada à tabela. Isso é útil para garantir que cada linha tenha um identificador exclusivo sem exigir que você especifique explicitamente um valor para a chave primária durante a inserção.

A função da cláusula `AUTOINCREMENT` é incrementar automaticamente uma chave primária para cara linha da tabela, sendo assim, nunca repetirá e você não irá precisar especificar uma chave primária para inserir na tabela, é automático essa chave ou ID da tabela.

## DEFAULT
A cláusula `DEFAULT` é usada para definir um valor padrão em cada coluna, ou seja, você consegue definir um valor padrão caso ele não seja específicado, é muito útil para definir um level, dinheiro padrão para jogadores novatos, a criação dá conta só será definir o nome e a senha.

## NOT NULL
A cláusula `NOT NULL` é usada para definir que uma coluna não pode ser inserida sem um valor definido, isto é o contrário do `DEFAULT`, se você definir uma coluna `NOT NULL` você é obrigado a passar um valor na instrução `INSERT INTO`

## Crases (\`)
Ao decorrer do tutorial, vocês irão notar que eu irei utilizar muitas crases para espeficiar uma tabela, coluna ou valor. Isso tem um motivo e irei explicarei aqui.

A crase (`) no SQL é utilizada para criar identificadores, tais como nomes de tabelas, colunas, ou qualquer outro identificador, que podem incluir caracteres especiais, espaços ou palavras-chave reservadas do SQL. Isso é particularmente útil quando o identificador não atende às regras padrão de nomenclatura ou quando você deseja evitar conflitos com palavras reservadas.

Em um exemplo de tabela com o nome: player-data
```sql
INSERT INTO `player-data` (Nome) VALUES ('Carlos Victor');
```
A crase é usada para indicar que `'player-data'` é um identificador. Sem a crase, o SQL pode interpretar `'player-data'` como duas palavras separadas (`player data`), resultando em um erro.

Isso é especialmente útil quando você tem espaços, caracteres especiais ou palavras reservadas no nome da tabela ou coluna.

# Aulas
- [Aula 2](Aulas/Aula_2.md) (Atual)
- [Aula 3](Aulas/Aula_3.md) (Próximo)