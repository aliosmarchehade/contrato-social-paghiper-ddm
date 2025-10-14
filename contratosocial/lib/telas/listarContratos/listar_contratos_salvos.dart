import 'package:contratosocial/banco/sqlite/dao/clausulas_dao.dart';
import 'package:contratosocial/banco/sqlite/dao/contrato_social_dao.dart';
import 'package:contratosocial/banco/sqlite/dao/empresa_dao.dart';
import 'package:contratosocial/banco/sqlite/dao/socio_dao.dart';
import 'package:contratosocial/configuracao/rotas.dart';
import 'package:contratosocial/models/clausulas.dart';
import 'package:contratosocial/models/contrato_social.dart';
import 'package:contratosocial/models/empresa.dart';
import 'package:contratosocial/models/socio.dart';
import 'package:flutter/material.dart';

class ListarSalvos extends StatefulWidget {
  const ListarSalvos({super.key});

  @override
  State<ListarSalvos> createState() => _ListarSalvosState();
}

class _ListarSalvosState extends State<ListarSalvos> {
  late Future<List<Map<String, dynamic>>> _contratosFuture;

  @override
  void initState() {
    super.initState();
    _contratosFuture = _carregarContratos();
  }

  Future<List<Map<String, dynamic>>> _carregarContratos() async {
    final contratos = await DAOContratoSocial().buscarTodos();
    final List<Map<String, dynamic>> contratosComDetalhes = [];

    for (final contrato in contratos) {
      final empresa = await DAOEmpresa().buscarPorId(contrato.empresaId);
      final socios = await DAOSocio().buscarPorContratoSocial(contrato.id!);
      final clausulas = await DAOClausulas().buscarPorContratoSocial(
        contrato.id!,
      );

      if (empresa != null) {
        contratosComDetalhes.add({
          'contrato': contrato,
          'empresa': empresa,
          'socios': socios,
          'clausulas': clausulas,
        });
      } else {
        print('Empresa não encontrada para contrato ID: ${contrato.id}');
      }
    }

    print('Total de contratos com detalhes: ${contratosComDetalhes.length}');
    return contratosComDetalhes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 10,
        shadowColor: Colors.black,
        backgroundColor: const Color(0xFF0860DB),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Contratos Salvos",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _contratosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Erro ao carregar contratos: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Nenhum contrato salvo encontrado.'),
            );
          }

          final contratos = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Contratos Salvos",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Divider(),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: contratos.length,
                  itemBuilder: (context, index) {
                    final data = contratos[index];
                    final DTOContratoSocial contrato = data['contrato'];
                    final DTOEmpresa empresa = data['empresa'];
                    final List<DTOSocio> socios = data['socios'];

                    return Card(
                      color: Color.fromARGB(255, 194, 213, 241),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Empresa: ${empresa.nomeEmpresarial}",
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text("CNPJ: ${empresa.cnpj}"),
                            const SizedBox(height: 10),
                            Text(
                              "Data de Upload: ${contrato.dataUpload.toIso8601String().split('T')[0]}",
                            ),
                            Text(
                              "Data de Processamento: ${contrato.dataProcessamento.toIso8601String().split('T')[0]}",
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "Sócios:",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            ...socios.map<Widget>(
                              (s) => Text("- ${s.nome} (${s.documento})"),
                            ),
                            const SizedBox(height: 12),
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueAccent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: () {
                                  _showContractDialog(context, data);
                                },
                                child: const Text(
                                  "Ver detalhes",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showContractDialog(
    BuildContext context,
    Map<String, dynamic> contractData,
  ) {
    final DTOContratoSocial contrato = contractData['contrato'];
    final DTOEmpresa empresa = contractData['empresa'];
    final List<DTOSocio> socios = contractData['socios'];
    final List<DTOClausulas> clausulas = contractData['clausulas'];

    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            insetPadding: const EdgeInsets.all(16),
            child: Container(
              color: Colors.white,
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
                      ),
                    ),
                    const Divider(),
                    const Text(
                      "Empresa",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text("Nome: ${empresa.nomeEmpresarial}"),
                    Text("CNPJ: ${empresa.cnpj}"),
                    Text("Objeto Social: ${empresa.objetoSocial}"),
                    Text("Duração da Sociedade: ${empresa.duracaoSociedade}"),
                    const SizedBox(height: 12),
                    const Text(
                      "Sócios",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    ...socios.map<Widget>(
                      (socio) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Nome: ${socio.nome}"),
                            Text("Documento: ${socio.documento}"),
                            Text("Profissão: ${socio.profissao}"),
                            Text("Percentual: ${socio.percentual}%"),
                            Text("Tipo: ${socio.tipo}"),
                            Text("Nacionalidade: ${socio.nacionalidade}"),
                            Text("Estado Civil: ${socio.estadoCivil}"),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Cláusulas",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    ...clausulas.map<Widget>(
                      (clausula) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Título: ${clausula.titulo}"),
                            Text("Descrição: ${clausula.descricao}"),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            "Fechar",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
    );
  }
}
