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
        FOREIGN KEY (endereco_id) REFERENCES endereco(id) ON DELETE CASCADE
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
        FOREIGN KEY (contrato_social_id) REFERENCES contrato_social(id) ON DELETE CASCADE
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
        FOREIGN KEY (endereco_id) REFERENCES endereco(id) ON DELETE CASCADE, 
        FOREIGN KEY (contrato_social_id) REFERENCES contrato_social(id) ON DELETE CASCADE
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
        favorito INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY (empresa_id) REFERENCES empresa(id),
        FOREIGN KEY (administracao_id) REFERENCES administracao(id) ON DELETE CASCADE,
        FOREIGN KEY (capital_social_id) REFERENCES capital_social(id) ON DELETE CASCADE,
        FOREIGN KEY (duracao_exercicio_id) REFERENCES duracao_exercicio_social(id) ON DELETE CASCADE
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
    [
      // Contract 1
      '''
      INSERT INTO endereco (logradouro, numero, complemento, bairro, cidade, estado, cep)
      VALUES ('Rua das Flores', '100', 'Apto 101', 'Centro', 'São Paulo', 'SP', '01001-000')
      ''',
      '''
      INSERT INTO empresa (nome_empresarial, cnpj, endereco_id, objeto_social, duracao_sociedade)
      VALUES ('Tech Solutions LTDA', '12.345.678/0001-99', 1, 'Desenvolvimento de software', 'Indeterminada')
      ''',
      '''
      INSERT INTO capital_social (valor_total, forma_integralizacao, prazo_integralizacao)
      VALUES (100000.00, 'Dinheiro', '12 meses')
      ''',
      '''
      INSERT INTO administracao (tipo_administracao, regras)
      VALUES ('Diretoria', 'Decisões por maioria')
      ''',
      '''
      INSERT INTO duracao_exercicio_social (periodo, data_inicio, data_fim)
      VALUES ('Anual', '2025-01-01', '2025-12-31')
      ''',
      '''
      INSERT INTO contrato_social (data_upload, data_processamento, empresa_id, administracao_id, capital_social_id, duracao_exercicio_id)
      VALUES ('2025-10-01T10:00:00Z', '2025-10-02T10:00:00Z', 1, 1, 1, 1)
      ''',
      '''
      INSERT INTO socio (nome, documento, endereco_id, profissao, percentual, tipo, nacionalidade, estado_civil, contrato_social_id)
      VALUES ('João Silva', '123.456.789-00', 1, 'Engenheiro', 60.0, 'Administrador', 'Brasileiro', 'Casado', 1)
      ''',
      '''
      INSERT INTO socio (nome, documento, endereco_id, profissao, percentual, tipo, nacionalidade, estado_civil, contrato_social_id)
      VALUES ('Maria Santos', '987.654.321-00', 1, 'Advogada', 40.0, 'Investidor', 'Brasileiro', 'Solteiro', 1)
      ''',
      '''
      INSERT INTO clausulas (titulo, descricao, contrato_social_id)
      VALUES ('Cláusula 1', 'Definição do objeto social', 1)
      ''',
      '''
      INSERT INTO clausulas (titulo, descricao, contrato_social_id)
      VALUES ('Cláusula 2', 'Distribuição de lucros', 1)
      ''',
    ],
    [
      // Contract 2
      '''
      INSERT INTO endereco (logradouro, numero, complemento, bairro, cidade, estado, cep)
      VALUES ('Avenida Brasil', '200', '', 'Jardins', 'Rio de Janeiro', 'RJ', '20040-000')
      ''',
      '''
      INSERT INTO empresa (nome_empresarial, cnpj, endereco_id, objeto_social, duracao_sociedade)
      VALUES ('Comércio Verde LTDA', '23.456.789/0001-88', 2, 'Venda de produtos orgânicos', '20 anos')
      ''',
      '''
      INSERT INTO capital_social (valor_total, forma_integralizacao, prazo_integralizacao)
      VALUES (50000.00, 'Bens móveis', '6 meses')
      ''',
      '''
      INSERT INTO administracao (tipo_administracao, regras)
      VALUES ('Conselho', 'Decisões unânimes')
      ''',
      '''
      INSERT INTO duracao_exercicio_social (periodo, data_inicio, data_fim)
      VALUES ('Anual', '2025-01-01', '2025-12-31')
      ''',
      '''
      INSERT INTO contrato_social (data_upload, data_processamento, empresa_id, administracao_id, capital_social_id, duracao_exercicio_id)
      VALUES ('2025-10-02T12:00:00Z', '2025-10-03T12:00:00Z', 2, 2, 2, 2)
      ''',
      '''
      INSERT INTO socio (nome, documento, endereco_id, profissao, percentual, tipo, nacionalidade, estado_civil, contrato_social_id)
      VALUES ('Ana Costa', '111.222.333-44', 2, 'Comerciante', 50.0, 'Administrador', 'Brasileiro', 'Casado', 2)
      ''',
      '''
      INSERT INTO socio (nome, documento, endereco_id, profissao, percentual, tipo, nacionalidade, estado_civil, contrato_social_id)
      VALUES ('Pedro Almeida', '555.666.777-88', 2, 'Contador', 50.0, 'Investidor', 'Brasileiro', 'Solteiro', 2)
      ''',
      '''
      INSERT INTO clausulas (titulo, descricao, contrato_social_id)
      VALUES ('Cláusula 1', 'Definição do objeto social', 2)
      ''',
      '''
      INSERT INTO clausulas (titulo, descricao, contrato_social_id)
      VALUES ('Cláusula 2', 'Regras de administração', 2)
      ''',
    ],
    [
      // Contract 3
      '''
      INSERT INTO endereco (logradouro, numero, complemento, bairro, cidade, estado, cep)
      VALUES ('Rua do Comércio', '300', 'Sala 10', 'Bela Vista', 'Belo Horizonte', 'MG', '30112-000')
      ''',
      '''
      INSERT INTO empresa (nome_empresarial, cnpj, endereco_id, objeto_social, duracao_sociedade)
      VALUES ('Inova Tech LTDA', '34.567.890/0001-77', 3, 'Consultoria em TI', 'Indeterminada')
      ''',
      '''
      INSERT INTO capital_social (valor_total, forma_integralizacao, prazo_integralizacao)
      VALUES (200000.00, 'Dinheiro', '24 meses')
      ''',
      '''
      INSERT INTO administracao (tipo_administracao, regras)
      VALUES ('Diretoria', 'Decisões por maioria')
      ''',
      '''
      INSERT INTO duracao_exercicio_social (periodo, data_inicio, data_fim)
      VALUES ('Anual', '2025-01-01', '2025-12-31')
      ''',
      '''
      INSERT INTO contrato_social (data_upload, data_processamento, empresa_id, administracao_id, capital_social_id, duracao_exercicio_id)
      VALUES ('2025-10-03T14:00:00Z', '2025-10-04T14:00:00Z', 3, 3, 3, 3)
      ''',
      '''
      INSERT INTO socio (nome, documento, endereco_id, profissao, percentual, tipo, nacionalidade, estado_civil, contrato_social_id)
      VALUES ('Lucas Ferreira', '222.333.444-55', 3, 'Programador', 70.0, 'Administrador', 'Brasileiro', 'Solteiro', 3)
      ''',
      '''
      INSERT INTO socio (nome, documento, endereco_id, profissao, percentual, tipo, nacionalidade, estado_civil, contrato_social_id)
      VALUES ('Clara Mendes', '666.777.888-99', 3, 'Designer', 30.0, 'Investidor', 'Brasileiro', 'Casado', 3)
      ''',
      '''
      INSERT INTO clausulas (titulo, descricao, contrato_social_id)
      VALUES ('Cláusula 1', 'Definição do objeto social', 3)
      ''',
      '''
      INSERT INTO clausulas (titulo, descricao, contrato_social_id)
      VALUES ('Cláusula 2', 'Distribuição de lucros', 3)
      ''',
      '''
      INSERT INTO clausulas (titulo, descricao, contrato_social_id)
      VALUES ('Cláusula 3', 'Resolução de conflitos', 3)
      ''',
    ],
    [
      // Contract 4
      '''
      INSERT INTO endereco (logradouro, numero, complemento, bairro, cidade, estado, cep)
      VALUES ('Rua das Palmeiras', '400', '', 'Boa Viagem', 'Recife', 'PE', '51020-000')
      ''',
      '''
      INSERT INTO empresa (nome_empresarial, cnpj, endereco_id, objeto_social, duracao_sociedade)
      VALUES ('Nordeste Turismo LTDA', '45.678.901/0001-66', 4, 'Agência de turismo', '15 anos')
      ''',
      '''
      INSERT INTO capital_social (valor_total, forma_integralizacao, prazo_integralizacao)
      VALUES (80000.00, 'Dinheiro', '18 meses')
      ''',
      '''
      INSERT INTO administracao (tipo_administracao, regras)
      VALUES ('Conselho', 'Decisões por maioria')
      ''',
      '''
      INSERT INTO duracao_exercicio_social (periodo, data_inicio, data_fim)
      VALUES ('Anual', '2025-01-01', '2025-12-31')
      ''',
      '''
      INSERT INTO contrato_social (data_upload, data_processamento, empresa_id, administracao_id, capital_social_id, duracao_exercicio_id)
      VALUES ('2025-10-04T16:00:00Z', '2025-10-05T16:00:00Z', 4, 4, 4, 4)
      ''',
      '''
      INSERT INTO socio (nome, documento, endereco_id, profissao, percentual, tipo, nacionalidade, estado_civil, contrato_social_id)
      VALUES ('Rafael Lima', '333.444.555-66', 4, 'Guia Turístico', 50.0, 'Administrador', 'Brasileiro', 'Casado', 4)
      ''',
      '''
      INSERT INTO socio (nome, documento, endereco_id, profissao, percentual, tipo, nacionalidade, estado_civil, contrato_social_id)
      VALUES ('Sofia Ribeiro', '777.888.999-00', 4, 'Administradora', 30.0, 'Investidor', 'Brasileiro', 'Solteiro', 4)
      ''',
      '''
      INSERT INTO socio (nome, documento, endereco_id, profissao, percentual, tipo, nacionalidade, estado_civil, contrato_social_id)
      VALUES ('Tiago Souza', '888.999.000-11', 4, 'Contador', 20.0, 'Investidor', 'Brasileiro', 'Casado', 4)
      ''',
      '''
      INSERT INTO clausulas (titulo, descricao, contrato_social_id)
      VALUES ('Cláusula 1', 'Definição do objeto social', 4)
      ''',
      '''
      INSERT INTO clausulas (titulo, descricao, contrato_social_id)
      VALUES ('Cláusula 2', 'Regras de administração', 4)
      ''',
    ],
    [
      // Contract 5
      '''
      INSERT INTO endereco (logradouro, numero, complemento, bairro, cidade, estado, cep)
      VALUES ('Avenida Central', '500', 'Bloco A', 'Asa Sul', 'Brasília', 'DF', '70350-000')
      ''',
      '''
      INSERT INTO empresa (nome_empresarial, cnpj, endereco_id, objeto_social, duracao_sociedade)
      VALUES ('Consultoria Nacional LTDA', '56.789.012/0001-55', 5, 'Consultoria empresarial', 'Indeterminada')
      ''',
      '''
      INSERT INTO capital_social (valor_total, forma_integralizacao, prazo_integralizacao)
      VALUES (150000.00, 'Dinheiro', '12 meses')
      ''',
      '''
      INSERT INTO administracao (tipo_administracao, regras)
      VALUES ('Diretoria', 'Decisões por maioria')
      ''',
      '''
      INSERT INTO duracao_exercicio_social (periodo, data_inicio, data_fim)
      VALUES ('Anual', '2025-01-01', '2025-12-31')
      ''',
      '''
      INSERT INTO contrato_social (data_upload, data_processamento, empresa_id, administracao_id, capital_social_id, duracao_exercicio_id)
      VALUES ('2025-10-05T18:00:00Z', '2025-10-06T18:00:00Z', 5, 5, 5, 5)
      ''',
      '''
      INSERT INTO socio (nome, documento, endereco_id, profissao, percentual, tipo, nacionalidade, estado_civil, contrato_social_id)
      VALUES ('Beatriz Oliveira', '444.555.666-77', 5, 'Consultora', 60.0, 'Administrador', 'Brasileiro', 'Solteiro', 5)
      ''',
      '''
      INSERT INTO socio (nome, documento, endereco_id, profissao, percentual, tipo, nacionalidade, estado_civil, contrato_social_id)
      VALUES ('Gustavo Pereira', '999.000.111-22', 5, 'Economista', 40.0, 'Investidor', 'Brasileiro', 'Casado', 5)
      ''',
      '''
      INSERT INTO clausulas (titulo, descricao, contrato_social_id)
      VALUES ('Cláusula 1', 'Definição do objeto social', 5)
      ''',
      '''
      INSERT INTO clausulas (titulo, descricao, contrato_social_id)
      VALUES ('Cláusula 2', 'Distribuição de lucros', 5)
      ''',
      '''
      INSERT INTO clausulas (titulo, descricao, contrato_social_id)
      VALUES ('Cláusula 3', 'Resolução de conflitos', 5)
      ''',
    ],
  ];
}
