// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:contratosocial/contrato_social_app.dart';
// import 'package:contratosocial/mock/mock_contrato.dart';

// class DashboardPage extends StatefulWidget {
//   const DashboardPage({super.key});

//   @override
//   State<DashboardPage> createState() => _DashboardPageState();
// }

// class _DashboardPageState extends State<DashboardPage> {
//   String? _fileName;
//   Uint8List? _fileBytes;

//   Future<void> _pickFile() async {
//     try {
//       final result = await FilePicker.platform.pickFiles(
//         type: FileType.custom,
//         allowedExtensions: ['pdf'],
//         withData: true,
//       );

//       if (result != null && result.files.isNotEmpty) {
//         setState(() {
//           _fileName = result.files.single.name;
//           _fileBytes = result.files.single.bytes;
//         });

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Arquivo selecionado: $_fileName")),
//         );

//         // Simulate API call and show dialog with contract data
//         _showContractDialog(mockContrato);
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Nenhum arquivo selecionado.")),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text("Erro ao selecionar arquivo: $e")));
//     }
//   }

//   void _showContractDialog(Map<String, dynamic> contractData) {
//     showDialog(
//       context: context,
//       builder:
//           (context) => AlertDialog(
//             title: const Text("Detalhes do Contrato Social"),
//             content: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Empresa Section
//                   const Text(
//                     "Empresa",
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   Text("Nome: ${contractData['empresa']['nome_empresarial']}"),
//                   Text("CNPJ: ${contractData['empresa']['cnpj']}"),
//                   Text(
//                     "Endereço: ${contractData['empresa']['endereco']['logradouro']}, "
//                     "${contractData['empresa']['endereco']['numero']}, "
//                     "${contractData['empresa']['endereco']['bairro']}, "
//                     "${contractData['empresa']['endereco']['cidade']}/"
//                     "${contractData['empresa']['endereco']['estado']} - "
//                     "${contractData['empresa']['endereco']['cep']}",
//                   ),
//                   Text(
//                     "Objeto Social: ${contractData['empresa']['objeto_social']}",
//                   ),
//                   Text("Duração: ${contractData['empresa']['duracao']}"),
//                   const SizedBox(height: 10),

//                   // Capital Social Section
//                   const Text(
//                     "Capital Social",
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   Text(
//                     "Valor Total: R\$${contractData['empresa']['capital_social']['valor_total']}",
//                   ),
//                   Text(
//                     "Forma de Integralização: ${contractData['empresa']['capital_social']['forma_integralizacao']}",
//                   ),
//                   Text(
//                     "Prazo de Integralização: ${contractData['empresa']['capital_social']['prazo_integralizacao']}",
//                   ),
//                   const SizedBox(height: 10),

//                   // Sócios Section
//                   const Text(
//                     "Sócios",
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   ...contractData['socios']
//                       .map<Widget>(
//                         (socio) => Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text("Nome: ${socio['nome']}"),
//                             Text("Documento: ${socio['documento']}"),
//                             Text("Endereço: ${socio['endereco']}"),
//                             Text("Profissão: ${socio['profissao']}"),
//                             Text("Percentual: ${socio['percentual']}"),
//                             Text("Tipo: ${socio['tipo']}"),
//                             Text("Nacionalidade: ${socio['nacionalidade']}"),
//                             Text("Estado Civil: ${socio['estado_civil']}"),
//                             const SizedBox(height: 5),
//                           ],
//                         ),
//                       )
//                       .toList(),
//                   const SizedBox(height: 10),

//                   // Administração Section
//                   const Text(
//                     "Administração",
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   Text(
//                     "Tipo: ${contractData['administracao']['tipoAdministracao']}",
//                   ),
//                   Text("Regras: ${contractData['administracao']['regras']}"),
//                   Text(
//                     "Administrador: ${contractData['administracao']['socio_administrador']}",
//                   ),
//                   const SizedBox(height: 10),

//                   // Cláusulas Section
//                   const Text(
//                     "Cláusulas",
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   ...contractData['clausulas']
//                       .map<Widget>(
//                         (clausula) => Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text("Tipo: ${clausula['tipo']}"),
//                             Text("Descrição: ${clausula['descricao']}"),
//                             const SizedBox(height: 5),
//                           ],
//                         ),
//                       )
//                       .toList(),
//                   const SizedBox(height: 10),

//                   // Outros Section
//                   const Text(
//                     "Outros",
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   Text("Foro: ${contractData['outros']['foro']}"),
//                   Text("Assinatura: ${contractData['outros']['assinatura']}"),
//                   Text("Data: ${contractData['outros']['data']}"),
//                 ],
//               ),
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.of(context).pop(),
//                 child: const Text("Fechar"),
//               ),
//             ],
//           ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Dashboard - Contrato Social")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             ElevatedButton.icon(
//               onPressed: _pickFile,
//               icon: const Icon(Icons.upload_file),
//               label: const Text("Enviar Contrato Social (PDF)"),
//             ),
//             const SizedBox(height: 20),
//             if (_fileName != null) ...[
//               Text("Arquivo selecionado: $_fileName"),
//               const SizedBox(height: 10),
//               Text(
//                 _fileBytes != null
//                     ? "Arquivo carregado com ${_fileBytes!.length} bytes."
//                     : "Falha ao ler conteúdo.",
//                 style: const TextStyle(color: Colors.grey),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
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

        _showContractDialog(mockContrato);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Nenhum arquivo selecionado.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao selecionar arquivo: $e")),
      );
    }
  }

  void _showContractDialog(Map<String, dynamic> contractData) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        insetPadding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          constraints: const BoxConstraints(maxHeight: 600),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Detalhes do Contrato Social",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                const Divider(),
                // Empresa
                const Text("Empresa", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("Nome: ${contractData['empresa']['nome_empresarial']}"),
                Text("CNPJ: ${contractData['empresa']['cnpj']}"),
                Text(
                  "Endereço: ${contractData['empresa']['endereco']['logradouro']}, "
                  "${contractData['empresa']['endereco']['numero']} - "
                  "${contractData['empresa']['endereco']['cidade']}/"
                  "${contractData['empresa']['endereco']['estado']}",
                ),
                const SizedBox(height: 12),

                // Sócios
                const Text("Sócios", style: TextStyle(fontWeight: FontWeight.bold)),
                ...contractData['socios'].map<Widget>(
                  (socio) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Nome: ${socio['nome']}"),
                        Text("Documento: ${socio['documento']}"),
                        Text("Percentual: ${socio['percentual'] ?? '-'}"),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Cláusulas
                const Text("Cláusulas", style: TextStyle(fontWeight: FontWeight.bold)),
                ...contractData['clausulas'].map<Widget>(
                  (c) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("• ${c['tipo']}", style: const TextStyle(fontWeight: FontWeight.w600)),
                        Text(c['descricao'], style: const TextStyle(color: Colors.black87)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Fechar", style: TextStyle(color: Colors.white)),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text("Dashboard - Contrato Social"),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.lightBlue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 6,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      const Icon(Icons.description, size: 60, color: Colors.blueAccent),
                      const SizedBox(height: 16),
                      const Text(
                        "Enviar Contrato Social (PDF)",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: _pickFile,
                        icon: const Icon(Icons.upload_file, color: Colors.white),
                        label: const Text("Selecionar Arquivo", style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              if (_fileName != null)
                Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Arquivo Selecionado",
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent)),
                        const SizedBox(height: 8),
                        Text(_fileName!),
                        Text(
                          _fileBytes != null
                              ? "Arquivo carregado com ${_fileBytes!.length} bytes."
                              : "Falha ao ler conteúdo.",
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
