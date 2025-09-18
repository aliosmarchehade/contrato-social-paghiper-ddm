import 'dart:typed_data'; // <-- necessário para Uint8List
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String? _fileName;
  Uint8List? _fileBytes; // armazenar conteúdo do arquivo

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        withData: true, // necessário na Web para pegar bytes
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _fileName = result.files.single.name;
          _fileBytes = result.files.single.bytes; // PDF em memória
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Arquivo selecionado: $_fileName")),
        );
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
