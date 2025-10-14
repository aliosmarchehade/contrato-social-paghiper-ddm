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
      final clausulas = await DAOClausulas().buscarPorContratoSocial(contrato.id!);

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

  Future<void> _excluirContrato(int contratoId) async {
    try {
      // Excluir apenas o contrato, já que ON DELETE CASCADE cuida das dependências
      await DAOContratoSocial().excluir(contratoId);

      // Recarregar a lista de contratos
      setState(() {
        _contratosFuture = _carregarContratos();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Contrato excluído com sucesso!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao excluir contrato: $e')),
      );
    }
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
                      color: const Color.fromARGB(255, 194, 213, 241),
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
                            Row(
                              children: [
                                const Icon(Icons.business, color: Colors.blueAccent),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    "Empresa: ${empresa.nomeEmpresarial}",
                                    style: const TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(Icons.badge, color: Colors.blueAccent),
                                const SizedBox(width: 8),
                                Text("CNPJ: ${empresa.cnpj}"),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Icon(Icons.upload, color: Colors.blueAccent),
                                const SizedBox(width: 8),
                                Text(
                                  "Data de Upload: ${contrato.dataUpload.toIso8601String().split('T')[0]}",
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(Icons.event, color: Colors.blueAccent),
                                const SizedBox(width: 8),
                                Text(
                                  "Data de Processamento: ${contrato.dataProcessamento.toIso8601String().split('T')[0]}",
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Icon(Icons.group, color: Colors.blueAccent),
                                const SizedBox(width: 8),
                                const Text(
                                  "Sócios:",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            ...socios.map<Widget>(
                              (s) => Padding(
                                padding: const EdgeInsets.only(left: 24),
                                child: Text("- ${s.nome} (${s.documento})"),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blueAccent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () {
                                    _showContractDialog(context, data);
                                  },
                                  icon: const Icon(Icons.visibility, color: Colors.white),
                                  label: const Text(
                                    "Ver detalhes",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.redAccent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        backgroundColor: Colors.white, // Fundo branco para o AlertDialog
                                        title: const Text("Confirmar Exclusão"),
                                        content: const Text("Deseja realmente excluir este contrato?"),
                                        actions: [
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.blueAccent,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                            ),
                                            onPressed: () => Navigator.pop(context),
                                            child: const Text(
                                              "Cancelar",
                                              style: TextStyle(color: Colors.white),
                                            ),
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.redAccent,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                            ),
                                            onPressed: () {
                                              _excluirContrato(contrato.id!);
                                              Navigator.pop(context);
                                            },
                                            child: const Text(
                                              "Excluir",
                                              style: TextStyle(color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.delete, color: Colors.white),
                                  label: const Text(
                                    "Excluir",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
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

  void _showContractDialog(BuildContext context, Map<String, dynamic> contractData) {
    final DTOContratoSocial contrato = contractData['contrato'];
    final DTOEmpresa empresa = contractData['empresa'];
    final List<DTOSocio> socios = contractData['socios'];
    final List<DTOClausulas> clausulas = contractData['clausulas'];

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        insetPadding: const EdgeInsets.all(16),
        backgroundColor: Colors.white, // Fundo branco para o Dialog
        child: Container(
          padding: const EdgeInsets.all(20),
          constraints: const BoxConstraints(maxHeight: 600),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.description, color: Colors.blueAccent),
                    SizedBox(width: 8),
                    Text(
                      "Detalhes do Contrato Social",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const Divider(),
                const Row(
                  children: [
                    Icon(Icons.business, color: Colors.blueAccent),
                    SizedBox(width: 8),
                    Text(
                      "Empresa",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.label, color: Colors.blueAccent),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Nome: ${empresa.nomeEmpresarial}",
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.badge, color: Colors.blueAccent),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "CNPJ: ${empresa.cnpj}",
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.work, color: Colors.blueAccent),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Objeto Social: ${empresa.objetoSocial}",
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.calendar_today, color: Colors.blueAccent),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Duração da Sociedade: ${empresa.duracaoSociedade}",
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Row(
                  children: [
                    Icon(Icons.group, color: Colors.blueAccent),
                    SizedBox(width: 8),
                    Text(
                      "Sócios",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                ...socios.asMap().entries.map<Widget>(
                  (entry) {
                    final index = entry.key;
                    final socio = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 6, left: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.person, color: Colors.blueAccent),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  "Sócio ${index + 1}",
                                  style: const TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 24),
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
                          if (index < socios.length - 1) const Divider(), // Adiciona separador entre sócios
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                const Row(
                  children: [
                    Icon(Icons.article, color: Colors.blueAccent),
                    SizedBox(width: 8),
                    Text(
                      "Cláusulas",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                ...clausulas.map<Widget>(
                  (clausula) => Padding(
                    padding: const EdgeInsets.only(bottom: 6, left: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.title, color: Colors.blueAccent),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "Título: ${clausula.titulo}",
                                softWrap: true,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.description, color: Colors.blueAccent),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "Descrição: ${clausula.descricao}",
                                softWrap: true

,
                              ),
                            ),
                          ],
                        ),
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
                        backgroundColor: Colors.redAccent, // Botão "Fechar" em vermelho
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