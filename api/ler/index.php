<?php


// Configuração de CORS e JSON
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header('Content-Type: application/json; charset=utf-8');

// Resposta imediata a pré-flight
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

// Lê corpo da requisição (texto extraído do PDF)
$input = json_decode(file_get_contents("php://input"), true);
if (!$input || !isset($input['texto'])) {
    http_response_code(400);
    echo json_encode(["erro" => "Texto não enviado. Envie no formato: { 'texto': 'conteúdo extraído do PDF' }"]);
    exit();
}

$textoExtraido = $input['texto'];

// 🔹 Seu prompt para o Gemini:
$prompt = "
Você é um assistente jurídico especializado em contratos sociais. 
Com base no texto abaixo, extraia as informações e devolva **somente** um JSON na seguinte estrutura:

{
  'endereco': {
    'logradouro': '',
    'numero': '',
    'complemento': '',
    'bairro': '',
    'cidade': '',
    'estado': '',
    'cep': ''
  },
  'empresa': {
    'nome_empresarial': '',
    'cnpj': '',
    'objeto_social': '',
    'duracao_sociedade': ''
  },
  'administracao': {
    'tipo_administracao': '',
    'regras': ''
  },
  'capital_social': {
    'valor_total': '',
    'forma_integralizacao': '',
    'prazo_integralizacao': ''
  },
  'duracao_exercicio': {
    'periodo': '',
    'data_inicio': '',
    'data_fim': ''
  },
  'contrato_social': {
    'data_upload': '',
    'data_processamento': ''
  },
  'socios': [
    {
      'nome': '',
      'documento': '',
      'profissao': '',
      'percentual': '',
      'tipo': '',
      'nacionalidade': '',
      'estado_civil': ''
    }
  ],
  'clausulas': [
    {
      'titulo': '',
      'descricao': ''
    }
  ]
}

Texto do contrato social:
\"\"\"$textoExtraido\"\"\"
";

// 🔑 Chave da API (MANTER SOMENTE NO SERVIDOR)
$apiKey = "AIzaSyBi26Ta8NgQRejdvKoiTONmPFrO8JbbdxI";

// 🔹 Requisição ao Gemini
$url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey";

$data = [
    "contents" => [
        [
            "parts" => [
                ["text" => $prompt]
            ]
        ]
    ]
];

$options = [
    "http" => [
        "header"  => "Content-Type: application/json",
        "method"  => "POST",
        "content" => json_encode($data)
    ]
];

$context  = stream_context_create($options);
$response = file_get_contents($url, false, $context);

if ($response === FALSE) {
    http_response_code(500);
    echo json_encode(["erro" => "Falha ao se conectar com o Gemini API"]);
    exit();
}

// 🔹 Interpreta a resposta do Gemini
$json = json_decode($response, true);
$textoResposta = $json['candidates'][0]['content']['parts'][0]['text'] ?? null;

// 🔹 Tenta converter o texto retornado em JSON
if ($textoResposta) {
    $dados = json_decode($textoResposta, true);
    if ($dados) {
        echo json_encode($dados, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE);
        exit();
    }
}

// 🔹 Caso o Gemini não retorne JSON válido
echo json_encode([
    "erro" => "Resposta inválida do Gemini",
    "resposta_bruta" => $textoResposta
], JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE);
?>
