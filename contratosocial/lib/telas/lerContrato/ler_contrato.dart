import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:contratosocial/banco/sqlite/conexao_sqlite.dart';
import 'package:contratosocial/banco/sqlite/dao/administracao_dao.dart';
import 'package:contratosocial/banco/sqlite/dao/capital_social_dao.dart';
import 'package:contratosocial/banco/sqlite/dao/clausulas_dao.dart';
import 'package:contratosocial/banco/sqlite/dao/contrato_social_dao.dart';
import 'package:contratosocial/banco/sqlite/dao/duracao_exercicio_social_dao.dart';
import 'package:contratosocial/banco/sqlite/dao/empresa_dao.dart';
import 'package:contratosocial/banco/sqlite/dao/endereco_dao.dart';
import 'package:contratosocial/banco/sqlite/dao/socio_dao.dart';
import 'package:contratosocial/configuracao/rotas.dart';
import 'package:contratosocial/models/administracao.dart';
import 'package:contratosocial/models/capital_social.dart';
import 'package:contratosocial/models/clausulas.dart';
import 'package:contratosocial/models/contrato_social.dart';
import 'package:contratosocial/models/duracao_exercicio_social.dart';
import 'package:contratosocial/models/empresa.dart';
import 'package:contratosocial/models/endereco.dart';
import 'package:contratosocial/models/socio.dart';
import 'package:contratosocial/components/dialog_detalhes_contrato.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:contratosocial/components/app_drawer.dart';
import 'package:pdfx/pdfx.dart';
import 'package:http/http.dart' as http;

class LerContrato extends StatefulWidget {
  const LerContrato({super.key});

  @override
  State<LerContrato> createState() => _LerContratoState();
}

class _LerContratoState extends State<LerContrato> {
  String? _fileName;
  Uint8List? _fileBytes;
  int? _contratoId;
  bool _isLoading = false;
  double _progress = 0.0;
  Timer? _progressTimer;

  @override
  void dispose() {
    _progressTimer?.cancel();
    super.dispose();
  }

  // Simula progresso de 0% a 90% durante a operação
  void _startProgressSimulation() {
    _progress = 0.0;
    _progressTimer?.cancel();
    _progressTimer = Timer.periodic(const Duration(milliseconds: 80), (timer) {
      setState(() {
        if (_progress < 0.9) {
          _progress += 0.03; // Aumenta gradualmente
        } else {
          _progress = 0.9; // Não passa de 90% até a resposta real
          timer.cancel();
        }
      });
    });
  }

  // Completa o progresso até 100% e espera 1 segundo
  Future<void> _completeProgressWithDelay() async {
    _progressTimer?.cancel();
    setState(() {
      _progress = 1.0; // Completa 100%
    });
    // Aguarda 2 segundo para o usuário ver o 100%
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() {
        _isLoading = false;
        _progress = 0.0;
      });
    }
  }

  // Mensagem dinâmica baseada no progresso
  String _getProgressMessage() {
    if (_progress < 0.6) return "Lendo PDF...";
    if (_progress < 1.2) return "Extraindo dados...";
    if (_progress < 1.8) return "Processando com IA...";
    return "Finalizando...";
  }

  Future<void> _pickFile() async {
    if (_isLoading) return;
    // 1. PRIMEIRO seleciona o arquivo (SEM LOADING)
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: true,
    );
    if (result == null || result.files.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nenhum arquivo selecionado.")),
      );
      return;
    }
    // 2. SÓ AGORA ativa o loading e mostra barra de progresso
    setState(() {
      _isLoading = true;
      _fileName = result.files.single.name;
      _fileBytes = result.files.single.bytes;
    });
    _startProgressSimulation();
    try {
      final contratoId = await _enviarPdfParaApi(_fileBytes!, _fileName!);
      setState(() {
        _contratoId = contratoId;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Contrato cadastrado com sucesso!")),
      );
    } catch (e) {
      print('Erro ao processar: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erro ao processar contrato: $e")));
    } finally {
      await _completeProgressWithDelay();
    }
  }

  Future<int> _enviarPdfParaApi(Uint8List fileBytes, String fileName) async {
    // Sempre dar "php -S 0.0.0.0:8000 -t ." na pasta /api e utilizar o Ip da sua maquina para acessar
    final uri = Uri.parse('http://192.168.251.27:8000/ler');
    //172.20.20.252

    final request = http.MultipartRequest('POST', uri);
    request.files.add(
      http.MultipartFile.fromBytes('file', fileBytes, filename: fileName),
    );

    final response = await request.send();

    final responseBody = await response.stream.bytesToString();
    print('Resposta completa do servidor: $responseBody');

    if (response.statusCode != 200) {
      throw Exception('Erro ao processar o PDF: ${response.statusCode}');
    }

    final data = jsonDecode(responseBody);

    // Salvar no banco usando os dados da API
    final contratoId = await _inserirDadosNoBanco(data);
    return contratoId;
  }

  Future<int> _inserirDadosNoBanco(Map<String, dynamic> data) async {
    final db = await ConexaoSQLite.database;
    late int contratoId;

    await db.transaction((txn) async {
      try {
        // Função auxiliar para garantir strings seguras
        String s(value) => value?.toString() ?? '';
        double d(value) => (value is num) ? value.toDouble() : 0.0;

        // Endereço
        final enderecoJson = data['endereco'] ?? {};
        final endereco = DTOEndereco(
          logradouro: s(enderecoJson['logradouro']),
          numero: s(enderecoJson['numero']),
          bairro: s(enderecoJson['bairro']),
          cidade: s(enderecoJson['cidade']),
          estado: s(enderecoJson['estado']),
          cep: s(enderecoJson['cep']),
          complemento: s(enderecoJson['complemento']),
        );
        final enderecoId = await DAOEndereco().salvar(endereco, db: txn);

        // Empresa
        final empresaJson = data['empresa'] ?? {};
        final empresa = DTOEmpresa(
          nomeEmpresarial: s(empresaJson['nome_empresarial']),
          cnpj: s(empresaJson['cnpj']),
          enderecoId: enderecoId,
          objetoSocial: s(empresaJson['objeto_social']),
          duracaoSociedade: s(empresaJson['duracao_sociedade']),
        );
        final empresaId = await DAOEmpresa().salvar(empresa, db: txn);

        // Administração
        final administracaoJson = data['administracao'] ?? {};
        final administracao = DTOAdministracao(
          tipoAdministracao: s(administracaoJson['tipo_administracao']),
          regras: s(administracaoJson['regras']),
        );
        final administracaoId = await DAOAdministracao().salvar(
          administracao,
          db: txn,
        );

        // Capital Social
        final capitalJson = data['capital_social'] ?? {};
        final capital = DTOCapitalSocial(
          valorTotal: d(capitalJson['valor_total']),
          formaIntegralizacao: s(capitalJson['forma_integralizacao']),
          prazoIntegralizacao: s(capitalJson['prazo_integralizacao']),
        );
        final capitalId = await DAOCapitalSocial().salvar(capital, db: txn);

        // Duração do Exercício Social
        final duracaoJson = data['duracao_exercicio'] ?? {};
        final periodo = s(duracaoJson['periodo']);
        final dataInicio = s(duracaoJson['data_inicio']);
        final dataFim = s(duracaoJson['data_fim']);

        final duracao = DTODuracaoExercicioSocial(
          periodo: periodo,
          dataInicio: dataInicio,
          dataFim: dataFim,
        );
        final duracaoId = await DAODuracaoExercicioSocial().salvar(
          duracao,
          db: txn,
        );

        // Contrato Social
        final contratoJson = data['contrato_social'] ?? {};
        final contrato = DTOContratoSocial(
          dataUpload:
              contratoJson['data_upload'] != null
                  ? DateTime.parse(s(contratoJson['data_upload']))
                  : DateTime.now(),
          dataProcessamento:
              contratoJson['data_processamento'] != null
                  ? DateTime.parse(s(contratoJson['data_processamento']))
                  : DateTime.now(),
          empresaId: empresaId,
          administracaoId: administracaoId,
          capitalSocialId: capitalId,
          duracaoExercicioId: duracaoId,
        );
        contratoId = await DAOContratoSocial().salvar(contrato, db: txn);

        // Sócios
        final sociosJson = data['socios'] as List<dynamic>? ?? [];
        for (var socioJson in sociosJson) {
          final socio = DTOSocio(
            nome: s(socioJson['nome']),
            documento: s(socioJson['documento']),
            enderecoId: enderecoId,
            profissao: s(socioJson['profissao']),
            percentual: d(socioJson['percentual']),
            tipo: s(socioJson['tipo']),
            nacionalidade: s(socioJson['nacionalidade']),
            estadoCivil: s(socioJson['estado_civil']),
            contratoSocialId: contratoId,
          );
          await DAOSocio().salvar(socio, db: txn);
        }

        // Cláusulas
        final clausulasJson = data['clausulas'] as List<dynamic>? ?? [];
        for (var clausulaJson in clausulasJson) {
          final clausula = DTOClausulas(
            titulo: s(clausulaJson['titulo']),
            descricao: s(clausulaJson['descricao']),
            contratoSocialId: contratoId,
          );
          await DAOClausulas().salvar(clausula, db: txn);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro ao inserir dados da API: $e")),
        );
        rethrow;
      }
    });

    return contratoId;
  }

  Future<void> _showContractDetails() async {
    if (_contratoId == null || _isLoading) return;
    setState(() {
      _isLoading = true;
    });
    _startProgressSimulation();
    try {
      final contrato = await DAOContratoSocial().buscarPorId(_contratoId!);
      if (contrato == null) {
        throw Exception("Contrato não encontrado");
      }
      final empresa = await DAOEmpresa().buscarPorId(contrato.empresaId);
      final socios = await DAOSocio().buscarPorContratoSocial(_contratoId!);
      final clausulas = await DAOClausulas().buscarPorContratoSocial(
        _contratoId!,
      );
      if (empresa == null) {
        throw Exception("Empresa não encontrada");
      }
      showDialog(
        context: context,
        builder:
            (context) => DialogDetalhesContrato(
              contrato: contrato,
              empresa: empresa,
              socios: socios,
              clausulas: clausulas,
            ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao carregar detalhes do contrato: $e")),
      );
    } finally {
      await _completeProgressWithDelay();
    }
  }

  void _viewPdf() {
    if (_fileBytes != null && _fileName != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) =>
                  PdfViewerScreen(fileBytes: _fileBytes!, fileName: _fileName!),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Nenhum arquivo PDF disponível para visualização."),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 10,
            shadowColor: Colors.black,
            backgroundColor: const Color(0xFF0860DB),
            iconTheme: const IconThemeData(color: Colors.white),
            title: const Text(
              "Contrato Social - Leitura",
              style: TextStyle(color: Colors.white),
            ),
          ),
          drawer: const AppDrawer(),
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    elevation: 10,
                    shadowColor: Colors.black,
                    child: Padding(
                      padding: const EdgeInsets.all(28.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8F0FE),
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(20),
                            child: const Icon(
                              Icons.description_outlined,
                              size: 56,
                              color: Color(0xFF0860DB),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            "Enviar Contrato Social (PDF)",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1A1A1A),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            "Selecione o arquivo PDF do contrato social para continuar o processo.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 24),
                          FilledButton.icon(
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFF0860DB),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 2,
                            ),
                            onPressed: _isLoading ? null : _pickFile,
                            icon: const Icon(
                              Icons.upload_file,
                              color: Colors.white,
                            ),
                            label: const Text(
                              "Selecionar Arquivo",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          if (_fileName != null) ...[
                            const SizedBox(height: 20),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF2F6FC),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.picture_as_pdf,
                                    color: Color(0xFF0860DB),
                                  ),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: Text(
                                      _fileName!,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF1A1A1A),
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.visibility,
                                      color: Color(0xFF0860DB),
                                    ),
                                    onPressed: _viewPdf,
                                    tooltip: 'Visualizar PDF',
                                  ),
                                ],
                              ),
                            ),
                          ],
                          if (_contratoId != null) ...[
                            const SizedBox(height: 20),
                            FilledButton.icon(
                              style: FilledButton.styleFrom(
                                backgroundColor: const Color(0xFF0860DB),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 2,
                              ),
                              onPressed:
                                  _isLoading ? null : _showContractDetails,
                              icon: const Icon(
                                Icons.info_outline,
                                color: Colors.white,
                              ),
                              label: const Text(
                                "Ver Detalhes do Contrato",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  if (_contratoId != null) ...[
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed:
                          _isLoading
                              ? null
                              : () {
                                Navigator.of(
                                  context,
                                ).pushNamed(Rotas.listarContratosSalvos);
                              },
                      child: const Text(
                        "Ir para Contratos Salvos",
                        style: TextStyle(
                          color: Color(0xFF0860DB),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
        // BARRA DE PROGRESSO (APENAS DEPOIS DE SELECIONAR ARQUIVO)
        if (_isLoading)
          Container(
            color: Colors.black.withOpacity(0.6),
            child: Center(
              child: Container(
                width: 300,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.hourglass_empty,
                      size: 48,
                      color: Color(0xFF0860DB),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _getProgressMessage(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: _progress,
                        minHeight: 12,
                        backgroundColor: Colors.grey[300],
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color.fromARGB(255, 10, 85, 170),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "${(_progress * 100).toInt()}%",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class PdfViewerScreen extends StatelessWidget {
  final Uint8List fileBytes;
  final String fileName;

  const PdfViewerScreen({
    super.key,
    required this.fileBytes,
    required this.fileName,
  });

  @override
  Widget build(BuildContext context) {
    final pdfController = PdfController(
      document: PdfDocument.openData(fileBytes),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0860DB),
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          fileName,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: PdfView(
        controller: pdfController,
        scrollDirection: Axis.vertical,
        pageSnapping: true,
        physics: const BouncingScrollPhysics(),
      ),
    );
  }
}
