<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);

require __DIR__ . '/../vendor/autoload.php';
use Smalot\PdfParser\Parser;

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header('Content-Type: application/json; charset=utf-8');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

if (!isset($_FILES['file']) || $_FILES['file']['error'] !== UPLOAD_ERR_OK) {
    http_response_code(400);
    echo json_encode(["erro" => "Envie um arquivo PDF valido."]);
    exit();
}

try {
    $parser = new Parser();
    $pdf = $parser->parseFile($_FILES['file']['tmp_name']);
    $textoExtraido = trim($pdf->getText());
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(["erro" => "Erro ao ler PDF", "detalhes" => $e->getMessage()]);
    exit();
}

$prompt = <<<PROMPT
Você é um assistente jurídico especializado em contratos sociais. 
Analise o texto abaixo e EXTRAIA apenas os dados solicitados, retornando SOMENTE um JSON válido (não inclua explicações, comentários ou texto adicional).

REGRAS IMPORTANTES:
1) Retorne estritamente o JSON na estrutura exata (mesmos nomes de campos e hierarquia). Se um campo não existir no texto, deixe-o como string vazia "".
2) Todas as datas obrigatoriamente no formato dd/mm/yyyy (dia e mês com dois dígitos). Ex.: 01/01/2025.
3) Nunca retorne datas placeholder como 0000-12-31, 1970-01-01, ou formatos ISO. Se não for possível extrair/derivar uma data legítima, retorne string vazia "" para esse campo.
4) Quando encontrar datas por extenso (ex.: '1 de janeiro de 2025', 'primeiro de janeiro de 2025', 'janeiro de 2025'), converta para dd/mm/yyyy corretamente:
   - '1 de janeiro de 2025' -> '01/01/2025'
   - 'janeiro de 2025' -> '01/01/2025'
   - '2025' -> '01/01/2025'
5) Se o texto indicar que o exercício social "coincidirá com o ano civil" e houver um ano explícito, use:
   - data_inicio = "01/01/AAAA"
   - data_fim = "31/12/AAAA"
6) Se não houver ano explícito, deixe data_inicio e data_fim como "".
7) Garanta que o JSON seja válido (use aspas duplas " para chaves e strings).

ESTRUTURA DO JSON (retorne EXATAMENTE assim):
{
  "endereco": {
    "logradouro": "",
    "numero": "",
    "complemento": "",
    "bairro": "",
    "cidade": "",
    "estado": "",
    "cep": ""
  },
  "empresa": {
    "nome_empresarial": "",
    "cnpj": "",
    "objeto_social": "",
    "duracao_sociedade": ""
  },
  "administracao": {
    "tipo_administracao": "",
    "regras": ""
  },
  "capital_social": {
    "valor_total": "",
    "forma_integralizacao": "",
    "prazo_integralizacao": ""
  },
  "duracao_exercicio": {
    "periodo": "",
    "data_inicio": "",
    "data_fim": ""
  },
  "contrato_social": {
    "data_upload": "",
    "data_processamento": ""
  },
  "socios": [
    {
      "nome": "",
      "documento": "",
      "profissao": "",
      "percentual": "",
      "tipo": "",
      "nacionalidade": "",
      "estado_civil": ""
    }
  ],
  "clausulas": [
    {
      "titulo": "",
      "descricao": ""
    }
  ]
}

Texto do contrato social:
"""$textoExtraido"""
PROMPT;



$apiKey = "teste";
$url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey";

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

$json = json_decode($response, true);
$textoResposta = $json['candidates'][0]['content']['parts'][0]['text'] ?? null;

if ($textoResposta) {
    $textoResposta = preg_replace('/^```json\s*|\s*```$/m', '', trim($textoResposta));
    $textoResposta = preg_replace('/^```\s*|\s*```$/m', '', $textoResposta);
    $textoResposta = str_replace("'", '"', $textoResposta);

    $dados = json_decode($textoResposta, true);

    if (json_last_error() === JSON_ERROR_NONE && is_array($dados)) {

        $toISO = function($date) {
            return preg_match('#^(\d{2})/(\d{2})/(\d{4})$#', trim($date), $m) 
                ? "$m[3]-$m[2]-$m[1]" 
                : $date;
        };

        $dados['duracao_exercicio']['data_inicio'] = $toISO($dados['duracao_exercicio']['data_inicio'] ?? '');
        $dados['duracao_exercicio']['data_fim'] = $toISO($dados['duracao_exercicio']['data_fim'] ?? '');
        $dados['contrato_social']['data_upload'] = date('Y-m-d');
        $dados['contrato_social']['data_processamento'] = date('Y-m-d H:i:s');

        echo json_encode($dados, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE);
        exit();
    } else {
        echo json_encode([
            "erro" => "JSON inválido após limpeza",
            "json_error" => json_last_error_msg(),
            "texto_limpo" => $textoResposta
        ], JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE);
        exit();
    }
}

echo json_encode([
    "erro" => "Resposta inválida do Gemini",
    "resposta_bruta" => $textoResposta
], JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE);
