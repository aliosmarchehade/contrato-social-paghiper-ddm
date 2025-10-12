class ScriptSQLite {
  static const List<String> comandosCriarTabelas = [
    '''
      CREATE TABLE endereco (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        logradouro TEXT NOT NULL,
        numero TEXT NOT NULL,
        complemento TEXT,
        bairro TEXT NOT NULL,
        cidade TEXT NOT NULL,
        estado TEXT NOT NULL,
        cep TEXT NOT NULL
      )
    ''',
    '''
      CREATE TABLE empresa (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome_empresarial TEXT NOT NULL,
        cnpj TEXT NOT NULL,
        endereco_id INTEGER NOT NULL,
        objeto_social TEXT NOT NULL,
        duracao_sociedade TEXT NOT NULL,
        FOREIGN KEY (endereco_id) REFERENCES endereco(id)
      )
    ''',
    '''
      CREATE TABLE capital_social (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        valor_total REAL NOT NULL,
        forma_integralizacao TEXT NOT NULL,
        prazo_integralizacao TEXT NOT NULL
      )
    ''',
    '''
      CREATE TABLE administracao (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tipo_administracao TEXT NOT NULL,
        regras TEXT NOT NULL
      )
    ''',
    '''
      CREATE TABLE duracao_exercicio_social (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        periodo TEXT NOT NULL,
        data_inicio TEXT NOT NULL,
        data_fim TEXT NOT NULL
      )
    ''',
    '''
      CREATE TABLE clausulas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titulo TEXT NOT NULL,
        descricao TEXT NOT NULL,
        contrato_social_id INTEGER NOT NULL,
        FOREIGN KEY (contrato_social_id) REFERENCES contrato_social(id)
      )
    ''',
    '''
      CREATE TABLE socio (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        documento TEXT NOT NULL,
        endereco_id INTEGER NOT NULL,
        profissao TEXT NOT NULL,
        percentual REAL NOT NULL,
        tipo TEXT NOT NULL,
        nacionalidade TEXT NOT NULL,
        estado_civil TEXT NOT NULL,
        contrato_social_id INTEGER NOT NULL,
        FOREIGN KEY (endereco_id) REFERENCES endereco(id),
        FOREIGN KEY (contrato_social_id) REFERENCES contrato_social(id)
      )
    ''',
    '''
      CREATE TABLE contrato_social (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        data_upload TEXT NOT NULL,
        data_processamento TEXT NOT NULL,
        empresa_id INTEGER NOT NULL,
        administracao_id INTEGER NOT NULL,
        capital_social_id INTEGER NOT NULL,
        duracao_exercicio_id INTEGER NOT NULL,
        FOREIGN KEY (empresa_id) REFERENCES empresa(id),
        FOREIGN KEY (administracao_id) REFERENCES administracao(id),
        FOREIGN KEY (capital_social_id) REFERENCES capital_social(id),
        FOREIGN KEY (duracao_exercicio_id) REFERENCES duracao_exercicio_social(id)
      )
    ''',
    '''
      CREATE TABLE usuarios (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT,
        email TEXT UNIQUE,
        senha TEXT
      )
    ''',
  ];

  static const List<List<String>> comandosInsercoes = [
    [
      '''
      INSERT INTO usuarios (nome, email, senha) 
      VALUES ('admin', 'admin@sistema.com', 'admin123')
      ''',
    ],
  ];
}
