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
import 'package:contratosocial/components/app_drawer.dart';

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
    for (var endereco in mockEnderecos) {
      await DAOEndereco().salvar(endereco);
    }

    // Empresas
    for (var empresa in mockEmpresas) {
      await DAOEmpresa().salvar(empresa);
    }

    // Capital Social
    for (var capital in mockCapitalSocial) {
      await DAOCapitalSocial().salvar(capital);
    }

    // Administração
    for (var adm in mockAdministracao) {
      await DAOAdministracao().salvar(adm);
    }

    // Duração Exercício Social
    for (var duracao in mockDuracaoExercicio) {
      await DAODuracaoExercicioSocial().salvar(duracao);
    }

    // Contrato Social
    for (var contrato in mockContratoSocial) {
      await DAOContratoSocial().salvar(contrato);
    }

    // Sócios
    for (var socio in mockSocios) {
      await DAOSocio().salvar(socio);
    }

    // Cláusulas
    for (var clausula in mockClausulas) {
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
