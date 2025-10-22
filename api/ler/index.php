<?php
// Define que o retorno será em JSON
header('Content-Type: application/json; charset=utf-8');

// Simula um pequeno atraso (como se estivesse processando)
sleep(1);

// JSON de exemplo que simula a resposta da IA
$response = [
    "endereco" => [
        "logradouro" => "Rua Exemplo",
        "numero" => "123",
        "bairro" => "Centro",
        "cidade" => "São Paulo",
        "estado" => "SP",
        "cep" => "01000-000"
    ],
    "empresa" => [
        "nomeEmpresarial" => "Empresa Mock teste PLease LTDAy",
        "cnpj" => "12.345.678/0001-991",
        "objetoSocial" => "Desenvolvimento de software",
        "duracaoSociedade" => "Indeterminado"
    ],
    "administracao" => [
        "tipoAdministracao" => "Individual",
        "regras" => "Regras mock"
    ],
    "capitalSocial" => [
        "valorTotal" => 100000.0,
        "formaIntegralizacao" => "Dinheiro",
        "prazoIntegralizacao" => "Imediato"
    ],
    "duracaoExercicioSocial" => [
        "periodo" => "Anual",
        "dataInicio" => "2023-01-01",
        "dataFim" => "2023-12-31"
    ],
    "contratoSocial" => [
        "dataUpload" => date('Y-m-d H:i:s'),
        "dataProcessamento" => date('Y-m-d H:i:s')
    ],
    "socios" => [
        [
            "nome" => "Sócio 1",
            "documento" => "123.456.789-00",
            "profissao" => "Engenheiro",
            "percentual" => 50.0,
            "tipo" => "Pessoa Física",
            "nacionalidade" => "Brasileira",
            "estadoCivil" => "Casado"
        ],
        [
            "nome" => "Sócio 2",
            "documento" => "987.654.321-00",
            "profissao" => "Advogado",
            "percentual" => 50.0,
            "tipo" => "Pessoa Física",
            "nacionalidade" => "Brasileira",
            "estadoCivil" => "Solteiro"
        ]
    ],
    "clausulas" => [
        [
            "titulo" => "Cláusula 1",
            "descricao" => "Descrição mock 1"
        ],
        [
            "titulo" => "Cláusula 2",
            "descricao" => "Descrição mock 2"
        ]
    ]
];

// Retorna o JSON simulando a resposta da IA
echo json_encode($response, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE);
