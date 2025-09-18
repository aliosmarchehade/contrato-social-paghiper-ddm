const criarTabelas = [
  '''
    CREATE TABLE teste(
      id INTEGER NOT NULL PRIMARY KEY
      ,teste VARCHAR(200) NOT NULL
      
    )
  ''',
];

const insercoes = [
  '''
    INSERT INTO teste (teste)
    VALUES ('teste')
  ''',
];
