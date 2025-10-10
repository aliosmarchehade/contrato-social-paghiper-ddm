// import 'dart:typed_data';
// import 'package:contratosocial/models/usuario.dart';
// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:contratosocial/mock/mock_contrato.dart';
// import 'package:contratosocial/banco/contrato_social_dao_segundo_plano.dart';

// class LerContrato extends StatefulWidget {
//   const LerContrato({super.key});

//   @override
//   State<LerContrato> createState() => _LerContratoState();
// }

// class _LerContratoState extends State<LerContrato> {
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
//           (context) => Dialog(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(16),
//             ),
//             insetPadding: const EdgeInsets.all(16),
//             child: Container(
//               color: Colors.white,
//               padding: const EdgeInsets.all(20),
//               constraints: const BoxConstraints(maxHeight: 600),
//               child: SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       "Detalhes do Contrato Social",
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black,
//                       ),
//                     ),
//                     const Divider(),
//                     // Empresa
//                     const Text(
//                       "Empresa",
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     Text(
//                       "Nome: ${contractData['empresa']['nome_empresarial']}",
//                     ),
//                     Text("CNPJ: ${contractData['empresa']['cnpj']}"),
//                     Text(
//                       "Endereço: ${contractData['empresa']['endereco']['logradouro']}, "
//                       "${contractData['empresa']['endereco']['numero']} - "
//                       "${contractData['empresa']['endereco']['cidade']}/"
//                       "${contractData['empresa']['endereco']['estado']}",
//                     ),
//                     const SizedBox(height: 12),

//                     // Sócios
//                     const Text(
//                       "Sócios",
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     ...contractData['socios'].map<Widget>(
//                       (socio) => Padding(
//                         padding: const EdgeInsets.only(bottom: 6),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text("Nome: ${socio['nome']}"),
//                             Text("Documento: ${socio['documento']}"),
//                             Text("Percentual: ${socio['percentual'] ?? '-'}"),
//                           ],
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 12),

//                     // Cláusulas
//                     const Text(
//                       "Cláusulas",
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     ...contractData['clausulas'].map<Widget>(
//                       (c) => Padding(
//                         padding: const EdgeInsets.only(bottom: 8),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               "• ${c['tipo']}",
//                               style: const TextStyle(
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                             Text(
//                               c['descricao'],
//                               style: const TextStyle(color: Colors.black87),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.green, // Cor para salvar
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                           ),
//                           onPressed: () async {
//                             try {
//                               await ContratoSocialDao().saveContrato(
//                                 contractData,
//                               );
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 const SnackBar(
//                                   content: Text("Contrato salvo com sucesso!"),
//                                 ),
//                               );
//                               Navigator.pop(context); // Fecha dialog
//                             } catch (e) {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 SnackBar(content: Text("Erro ao salvar: $e")),
//                               );
//                             }
//                           },
//                           child: const Text(
//                             "Salvar",
//                             style: TextStyle(color: Colors.white),
//                           ),
//                         ),
//                         const SizedBox(width: 8),
//                         ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.blueAccent,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                           ),
//                           onPressed: () => Navigator.pop(context),
//                           child: const Text(
//                             "Fechar",
//                             style: TextStyle(color: Colors.white),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         iconTheme: const IconThemeData(color: Colors.white),
//         title: const Text(
//           "Ler Contrato Social",
//           style: TextStyle(color: Colors.white),
//         ),
//         elevation: 10,
//         shadowColor: Colors.black,
//         backgroundColor: Color(0xFF0860DB),
//       ),
//       body: Center(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(24.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Card(
//                 color: Colors.white,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 elevation: 6,
//                 child: Padding(
//                   padding: const EdgeInsets.all(24.0),
//                   child: Column(
//                     children: [
//                       const Icon(
//                         Icons.description,
//                         size: 60,
//                         color: Color(0xFF0860DB),
//                       ),
//                       const SizedBox(height: 16),
//                       const Text(
//                         "Enviar Contrato Social (PDF)",
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       ElevatedButton.icon(
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Color(0xFF0860DB),
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 24,
//                             vertical: 14,
//                           ),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                         onPressed: _pickFile,
//                         icon: const Icon(
//                           Icons.upload_file,
//                           color: Colors.white,
//                         ),
//                         label: const Text(
//                           "Selecionar Arquivo",
//                           style: TextStyle(color: Colors.white),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               // const SizedBox(height: 24),
//               // if (_fileName != null)
//               //   Card(
//               //     color: Colors.white,
//               //     shape: RoundedRectangleBorder(
//               //       borderRadius: BorderRadius.circular(12),
//               //     ),
//               //     elevation: 3,
//               //     child: Padding(
//               //       padding: const EdgeInsets.all(16),
//               //       child: Column(
//               //         crossAxisAlignment: CrossAxisAlignment.start,
//               //         children: [
//               //           const Text(
//               //             "Arquivo Selecionado",
//               //             style: TextStyle(
//               //               fontWeight: FontWeight.bold,
//               //               color: Colors.blueAccent,
//               //             ),
//               //           ),
//               //           const SizedBox(height: 8),
//               //           Text(_fileName!),
//               //           Text(
//               //             _fileBytes != null
//               //                 ? "Arquivo carregado com ${_fileBytes!.length} bytes."
//               //                 : "Falha ao ler conteúdo.",
//               //             style: const TextStyle(color: Colors.grey),
//               //           ),
//               //         ],
//               //       ),
//               //     ),
//               //   ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:contratosocial/mock/mock_contrato.dart';
import 'package:contratosocial/banco/sqlite/dao/endereco_dao.dart';
import 'package:contratosocial/banco/sqlite/dao/empresa_dao.dart';
import 'package:contratosocial/banco/sqlite/dao/capital_social_dao.dart';
import 'package:contratosocial/banco/sqlite/dao/administracao_dao.dart';
import 'package:contratosocial/banco/sqlite/dao/duracao_exercicio_social_dao.dart';
import 'package:contratosocial/banco/sqlite/dao/socio_dao.dart';
import 'package:contratosocial/banco/sqlite/dao/clausulas_dao.dart';
import 'package:contratosocial/banco/sqlite/dao/contrato_social_dao.dart';

class LerContrato extends StatefulWidget {
  const LerContrato({super.key});

  @override
  State<LerContrato> createState() => _LerContratoState();
}

class _LerContratoState extends State<LerContrato> {
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

        // Aqui chamamos diretamente a função de inserir o mock no banco
        await _saveMockToDatabase();
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

  Future<void> _saveMockToDatabase() async {
    try {
      // Endereços
      for (var endereco in mockContratoBanco['endereco']!) {
        await DAOEndereco().salvar(endereco);
      }

      // Empresas
      for (var empresa in mockContratoBanco['empresa']!) {
        await DAOEmpresa().salvar(empresa);
      }

      // Capital Social
      for (var capital in mockContratoBanco['capital_social']!) {
        await DAOCapitalSocial().salvar(capital);
      }

      // Administração
      for (var adm in mockContratoBanco['administracao']!) {
        await DAOAdministracao().salvar(adm);
      }

      // Duração Exercício Social
      for (var duracao in mockContratoBanco['duracao_exercicio_social']!) {
        await DAODuracaoExercicioSocial().salvar(duracao);
      }

      // Contrato Social
      for (var contrato in mockContratoBanco['contrato_social']!) {
        await DAOContratoSocial().salvar(contrato);
      }

      // Sócios
      for (var socio in mockContratoBanco['socio']!) {
        await DAOSocio().salvar(socio);
      }

      // Cláusulas
      for (var clausula in mockContratoBanco['clausulas']!) {
        await DAOClausulas().salvar(clausula);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Mock inserido no banco com sucesso!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao inserir mock no banco: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Ler Contrato Social",
          style: TextStyle(color: Colors.white),
        ),
        elevation: 10,
        shadowColor: Colors.black,
        backgroundColor: const Color(0xFF0860DB),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 6,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.description,
                        size: 60,
                        color: Color(0xFF0860DB),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Enviar Contrato Social (PDF)",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0860DB),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _pickFile,
                        icon: const Icon(
                          Icons.upload_file,
                          color: Colors.white,
                        ),
                        label: const Text(
                          "Selecionar Arquivo",
                          style: TextStyle(color: Colors.white),
                        ),
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
