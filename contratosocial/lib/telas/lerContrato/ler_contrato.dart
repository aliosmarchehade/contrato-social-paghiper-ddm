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
import 'package:contratosocial/mock/mock_data.dart';
import 'package:contratosocial/components/app_drawer.dart';
import 'package:pdfx/pdfx.dart';

class LerContrato extends StatefulWidget {
  const LerContrato({super.key});

  @override
  State<LerContrato> createState() => _LerContratoState();
}

class _LerContratoState extends State<LerContrato> {
  String? _fileName;
  Uint8List? _fileBytes;
  int? _contratoId; // To store the ID of the saved contract

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _fileName = result.files.single.name;
          _fileBytes = result.files.single.bytes;
        });

        // Save mock data and get contract ID
        final contratoId = await _inserirMockNoBanco();

        setState(() {
          _contratoId = contratoId; // Store the contract ID
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Contrato cadastrado com sucesso!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Nenhum arquivo selecionado.")),
        );
      }
    } catch (e) {
      print('Erro ao selecionar arquivo: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erro ao selecionar arquivo: $e")));
    }
  }

  Future<int> _inserirMockNoBanco() async {
    final db = await ConexaoSQLite.database;
    late int contratoId;
    await db.transaction((txn) async {
      try {
        // Save Endereço
        final enderecoId = await DAOEndereco().salvar(
          MockData.mockEndereco,
          db: txn,
        );

        // Save Empresa with updated enderecoId
        final empresa = DTOEmpresa(
          nomeEmpresarial: MockData.mockEmpresa.nomeEmpresarial,
          cnpj: MockData.mockEmpresa.cnpj,
          enderecoId: enderecoId,
          objetoSocial: MockData.mockEmpresa.objetoSocial,
          duracaoSociedade: MockData.mockEmpresa.duracaoSociedade,
        );
        final empresaId = await DAOEmpresa().salvar(empresa, db: txn);

        // Save Administração
        final administracaoId = await DAOAdministracao().salvar(
          MockData.mockAdministracao,
          db: txn,
        );

        // Save Capital Social
        final capitalId = await DAOCapitalSocial().salvar(
          MockData.mockCapital,
          db: txn,
        );

        // Save Duração Exercício
        final duracaoId = await DAODuracaoExercicioSocial().salvar(
          MockData.mockDuracao,
          db: txn,
        );

        final contrato = DTOContratoSocial(
          dataUpload: MockData.mockContrato.dataUpload,
          dataProcessamento: MockData.mockContrato.dataProcessamento,
          empresaId: empresaId,
          administracaoId: administracaoId,
          capitalSocialId: capitalId,
          duracaoExercicioId: duracaoId,
        );
        contratoId = await DAOContratoSocial().salvar(contrato, db: txn);

        for (var socio in MockData.mockSocios) {
          final newSocio = DTOSocio(
            nome: socio.nome,
            documento: socio.documento,
            enderecoId: enderecoId,
            profissao: socio.profissao,
            percentual: socio.percentual,
            tipo: socio.tipo,
            nacionalidade: socio.nacionalidade,
            estadoCivil: socio.estadoCivil,
            contratoSocialId: contratoId,
          );
          final socioId = await DAOSocio().salvar(newSocio, db: txn);
        }

        for (var clausula in MockData.mockClausulas) {
          final newClausula = DTOClausulas(
            titulo: clausula.titulo,
            descricao: clausula.descricao,
            contratoSocialId: contratoId,
          );
          final clausulaId = await DAOClausulas().salvar(newClausula, db: txn);
        }
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Erro ao inserir mock: $e")));
        rethrow; // Propagate the error to fail the transaction
      }
    });
    return contratoId;
  }

  Future<void> _showContractDetails() async {
    if (_contratoId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Nenhum contrato disponível para visualização."),
        ),
      );
      return;
    }

    try {
      final contrato = await DAOContratoSocial().buscarPorId(_contratoId!);
      if (contrato == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Contrato não encontrado.")),
        );
        return;
      }

      final empresa = await DAOEmpresa().buscarPorId(contrato.empresaId);
      final socios = await DAOSocio().buscarPorContratoSocial(_contratoId!);
      final clausulas = await DAOClausulas().buscarPorContratoSocial(
        _contratoId!,
      );

      if (empresa == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Empresa não encontrada.")),
        );
        return;
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
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0860DB),
        elevation: 2,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Ler Contrato Social",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
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
                elevation: 4,
                shadowColor: Colors.black12,
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
                        style: TextStyle(fontSize: 14, color: Colors.black54),
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
                        onPressed: _pickFile,
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
                          onPressed: _showContractDetails,
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
                  onPressed: () {
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
