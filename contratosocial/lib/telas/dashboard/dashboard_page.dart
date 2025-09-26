import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:contratosocial/contrato_social_app.dart';
import 'package:contratosocial/mock/mock_contrato.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String? _fileName;
  Uint8List? _fileBytes;

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

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Arquivo selecionado: $_fileName")),
        );

        // Simulate API call and show dialog with contract data
        _showContractDialog(mockContrato);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Nenhum arquivo selecionado.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erro ao selecionar arquivo: $e")));
    }
  }

  void _showContractDialog(Map<String, dynamic> contractData) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Detalhes do Contrato Social"),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Empresa Section
                  const Text(
                    "Empresa",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text("Nome: ${contractData['empresa']['nome_empresarial']}"),
                  Text("CNPJ: ${contractData['empresa']['cnpj']}"),
                  Text(
                    "Endereço: ${contractData['empresa']['endereco']['logradouro']}, "
                    "${contractData['empresa']['endereco']['numero']}, "
                    "${contractData['empresa']['endereco']['bairro']}, "
                    "${contractData['empresa']['endereco']['cidade']}/"
                    "${contractData['empresa']['endereco']['estado']} - "
                    "${contractData['empresa']['endereco']['cep']}",
                  ),
                  Text(
                    "Objeto Social: ${contractData['empresa']['objeto_social']}",
                  ),
                  Text("Duração: ${contractData['empresa']['duracao']}"),
                  const SizedBox(height: 10),

                  // Capital Social Section
                  const Text(
                    "Capital Social",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Valor Total: R\$${contractData['empresa']['capital_social']['valor_total']}",
                  ),
                  Text(
                    "Forma de Integralização: ${contractData['empresa']['capital_social']['forma_integralizacao']}",
                  ),
                  Text(
                    "Prazo de Integralização: ${contractData['empresa']['capital_social']['prazo_integralizacao']}",
                  ),
                  const SizedBox(height: 10),

                  // Sócios Section
                  const Text(
                    "Sócios",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ...contractData['socios']
                      .map<Widget>(
                        (socio) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Nome: ${socio['nome']}"),
                            Text("Documento: ${socio['documento']}"),
                            Text("Endereço: ${socio['endereco']}"),
                            Text("Profissão: ${socio['profissao']}"),
                            Text("Percentual: ${socio['percentual']}"),
                            Text("Tipo: ${socio['tipo']}"),
                            Text("Nacionalidade: ${socio['nacionalidade']}"),
                            Text("Estado Civil: ${socio['estado_civil']}"),
                            const SizedBox(height: 5),
                          ],
                        ),
                      )
                      .toList(),
                  const SizedBox(height: 10),

                  // Administração Section
                  const Text(
                    "Administração",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Tipo: ${contractData['administracao']['tipoAdministracao']}",
                  ),
                  Text("Regras: ${contractData['administracao']['regras']}"),
                  Text(
                    "Administrador: ${contractData['administracao']['socio_administrador']}",
                  ),
                  const SizedBox(height: 10),

                  // Cláusulas Section
                  const Text(
                    "Cláusulas",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ...contractData['clausulas']
                      .map<Widget>(
                        (clausula) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Tipo: ${clausula['tipo']}"),
                            Text("Descrição: ${clausula['descricao']}"),
                            const SizedBox(height: 5),
                          ],
                        ),
                      )
                      .toList(),
                  const SizedBox(height: 10),

                  // Outros Section
                  const Text(
                    "Outros",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text("Foro: ${contractData['outros']['foro']}"),
                  Text("Assinatura: ${contractData['outros']['assinatura']}"),
                  Text("Data: ${contractData['outros']['data']}"),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Fechar"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard - Contrato Social")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              onPressed: _pickFile,
              icon: const Icon(Icons.upload_file),
              label: const Text("Enviar Contrato Social (PDF)"),
            ),
            const SizedBox(height: 20),
            if (_fileName != null) ...[
              Text("Arquivo selecionado: $_fileName"),
              const SizedBox(height: 10),
              Text(
                _fileBytes != null
                    ? "Arquivo carregado com ${_fileBytes!.length} bytes."
                    : "Falha ao ler conteúdo.",
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
