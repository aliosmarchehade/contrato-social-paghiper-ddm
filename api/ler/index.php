<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);

require __DIR__ . '/../vendor/autoload.php';
use Smalot\PdfParser\Parser;


// 🔹 Configuração de CORS e cabeçalhos
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header('Content-Type: application/json; charset=utf-8');

// 🔹 Requisição OPTIONS (pré-flight do navegador)
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

// 🔹 Verifica se veio o arquivo PDF
if (!isset($_FILES['file']) || $_FILES['file']['error'] !== UPLOAD_ERR_OK) {
    http_response_code(400);
    echo json_encode(["erro" => "Envie um arquivo PDF válido."]);
    exit();
}

try {
    // 🔹 Lê o PDF
    $parser = new Parser();
    $pdf = $parser->parseFile($_FILES['file']['tmp_name']);
    $textoExtraido = trim($pdf->getText());
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(["erro" => "Erro ao ler PDF", "detalhes" => $e->getMessage()]);
    exit();
}

// 🔹 Monta o prompt para o Gemini
$prompt = "
Você é um assistente jurídico especializado em contratos sociais.
Com base no texto abaixo, extraia as informações e devolva SOMENTE um JSON na seguinte estrutura:

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
\"\"\"$textoExtraido\"\"\"";

// 🔑 Chave da API Gemini (só no servidor)
$apiKey = "SUA_CHAVE_GEMINI_AQUI";

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

$response = @file_get_contents($url, false, stream_context_create($options));

if ($response === FALSE) {
    http_response_code(500);
    echo json_encode(["erro" => "Falha ao conectar à API Gemini"]);
    exit();
}

// 🔹 Interpreta a resposta do Gemini
$json = json_decode($response, true);
$textoResposta = $json['candidates'][0]['content']['parts'][0]['text'] ?? null;

// 🔹 Tenta converter o texto retornado em JSON
if ($textoResposta) {
    $textoResposta = str_replace("'", '"', $textoResposta);
    $dados = json_decode($textoResposta, true);
    if ($dados) {
        echo json_encode($dados, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE);
        exit();
    }
}

// 🔹 Se não for JSON válido
echo json_encode([
    "erro" => "Resposta inválida do Gemini",
    "resposta_bruta" => $textoResposta
], JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE);
