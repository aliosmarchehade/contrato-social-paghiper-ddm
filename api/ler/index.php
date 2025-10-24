<?php
// Permitir qualquer origem (teste local)
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

// Permite resposta em JSON
header('Content-Type: application/json; charset=utf-8');

// Responde para requisições OPTIONS (pré-flight do navegador)
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

// Simula atraso
sleep(1);

// Dados mock corrigidos conforme estrutura SQLite
$response = [
    "endereco" => [
        "logradouro" => "Rua Exemplo",
        "numero" => "123",
        "complemento" => "Apto 101",
        "bairro" => "Centro",
        "cidade" => "São Paulo",
        "estado" => "SP",
        "cep" => "01000-000"
    ],
    "empresa" => [
        "nome_empresarial" => "DANIELE AAAAAAAAAAAAAAAAAAAAA SOCORRO",
        "cnpj" => "12.345.678/0001-99",
        "objeto_social" => "Desenvolvimento de software",
        "duracao_sociedade" => "Indeterminado"
    ],
    "administracao" => [
        "tipo_administracao" => "Individual",
        "regras" => "Regras mock de administração"
    ],
    "capital_social" => [
        "valor_total" => 100000.0,
        "forma_integralizacao" => "Dinheiro",
        "prazo_integralizacao" => "Imediato"
    ],
    "duracao_exercicio" => [
        "periodo" => "Anual",
        "data_inicio" => "2023-01-01",
        "data_fim" => "2023-12-31"
    ],
    "contrato_social" => [
        "data_upload" => date('Y-m-d H:i:s'),
        "data_processamento" => date('Y-m-d H:i:s')
    ],
    "socios" => [
        [
            "nome" => "Sócio 1",
            "documento" => "123.456.789-00",
            "profissao" => "Engenheiro",
            "percentual" => 50.0,
            "tipo" => "Pessoa Física",
            "nacionalidade" => "Brasileira",
            "estado_civil" => "Casado"
        ],
        [
            "nome" => "Sócio 2",
            "documento" => "987.654.321-00",
            "profissao" => "Advogado",
            "percentual" => 50.0,
            "tipo" => "Pessoa Física",
            "nacionalidade" => "Brasileira",
            "estado_civil" => "Solteiro"
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

// Envia resposta JSON
echo json_encode($response, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE);
?>
