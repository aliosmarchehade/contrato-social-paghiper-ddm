import 'package:contratosocial/banco/sqlite/dao/contrato_social_dao.dart';
import 'package:contratosocial/banco/sqlite/dao/empresa_dao.dart';
import 'package:contratosocial/banco/sqlite/dao/socio_dao.dart';
import 'package:contratosocial/configuracao/rotas.dart';
import 'package:contratosocial/components/app_drawer.dart';
import 'package:contratosocial/models/contrato_social.dart';
import 'package:contratosocial/models/empresa.dart';
import 'package:contratosocial/models/socio.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late Future<Map<String, dynamic>> _dashboardDataFuture;

  @override
  void initState() {
    super.initState();
    _dashboardDataFuture = _carregarDadosDashboard();
  }

  Future<Map<String, dynamic>> _carregarDadosDashboard() async {
    final contratoDao = DAOContratoSocial();
    final socioDao = DAOSocio();
    final empresaDao = DAOEmpresa();

    // Fetch total number of contracts
    final contratos = await contratoDao.buscarTodos();
    final contratosAnalisados = contratos.length;

    // Fetch total number of partners
    final socios = await socioDao.buscarTodos();
    final sociosCadastrados = socios.length;

    // Fetch the most recent contract
    Map<String, dynamic> ultimoContrato = {};
    if (contratos.isNotEmpty) {
      // Sort contracts by data_upload in descending order to get the most recent
      contratos.sort((a, b) => b.dataUpload.compareTo(a.dataUpload));
      final contrato = contratos.first;
      final empresa = await empresaDao.buscarPorId(contrato.empresaId);
      final sociosContrato = await socioDao.buscarPorContratoSocial(
        contrato.id!,
      );

      if (empresa != null) {
        ultimoContrato = {
          'data_analise':
              contrato.dataProcessamento.toIso8601String().split('T')[0],
          'data_atualizacao':
              contrato.dataUpload.toIso8601String().split('T')[0],
          'empresa': {
            'nome_empresarial': empresa.nomeEmpresarial,
            'cnpj': empresa.cnpj,
          },
          'socios':
              sociosContrato
                  .map((s) => {'nome': s.nome, 'documento': s.documento})
                  .toList(),
        };
      }
    }

    return {
      'contratosAnalisados': contratosAnalisados,
      'sociosCadastrados': sociosCadastrados,
      'ultimoContrato': ultimoContrato,
    };
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
          "Contrato Social - Dashboard",
          style: TextStyle(color: Colors.white),
        ),
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _dashboardDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Erro ao carregar dados: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData ||
              snapshot.data!['ultimoContrato'].isEmpty) {
            return const Center(
              child: Text('Nenhum contrato salvo encontrado.'),
            );
          }

          final data = snapshot.data!;
          final contratosAnalisados = data['contratosAnalisados'] as int;
          final sociosCadastrados = data['sociosCadastrados'] as int;
          final ultimoContrato = data['ultimoContrato'] as Map<String, dynamic>;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Linha com os 2 cards
                Row(
                  children: [
                    Expanded(
                      child: Card(
                        color: const Color.fromARGB(255, 194, 213, 241),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.description,
                                color: Colors.blue,
                                size: 40,
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                "Contratos analisados",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "$contratosAnalisados",
                                style: const TextStyle(
                                  fontSize: 22,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Card(
                        color: const Color.fromARGB(255, 194, 213, 241),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.people,
                                color: Colors.blue,
                                size: 40,
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                "Sócios cadastrados",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "$sociosCadastrados",
                                style: const TextStyle(
                                  fontSize: 22,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                // Resumo último contrato
                const Text(
                  "Último contrato analisado",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Divider(),
                Card(
                  color: const Color.fromARGB(255, 194, 213, 241),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Empresa: ${ultimoContrato['empresa']['nome_empresarial']}",
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Text("CNPJ: ${ultimoContrato['empresa']['cnpj']}"),
                        const SizedBox(height: 10),
                        Text(
                          "Data de análise: ${ultimoContrato['data_analise']}",
                        ),
                        Text(
                          "Última atualização: ${ultimoContrato['data_atualizacao']}",
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Sócios:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        ...ultimoContrato['socios'].map<Widget>(
                          (s) => Text("- ${s['nome']} (${s['documento']})"),
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
                              _showContractDialog(context, ultimoContrato);
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
                    Text(
                      "Nome: ${contractData['empresa']['nome_empresarial']}",
                    ),
                    Text("CNPJ: ${contractData['empresa']['cnpj']}"),
                    const SizedBox(height: 12),
                    const Text(
                      "Sócios",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    ...contractData['socios'].map<Widget>(
                      (socio) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Nome: ${socio['nome']}"),
                            Text("Documento: ${socio['documento']}"),
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
