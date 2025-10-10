import 'package:contratosocial/banco/contrato_social_dao_segundo_plano.dart';
import 'package:contratosocial/models/contrato_social.dart';
import 'package:flutter/material.dart';

class ListarSalvos extends StatefulWidget {
  const ListarSalvos({super.key});

  @override
  State<ListarSalvos> createState() => _ListarSalvosState();
}

class _ListarSalvosState extends State<ListarSalvos> {
  late Future<List<ContratoSocial>> _contratos;

  @override
  void initState() {
    super.initState();
    _carregarContratos();
  }

  void _carregarContratos() {
    setState(() {
      _contratos = ContratoSocialDao().getAllContratos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 10,
        shadowColor: Colors.black,
        title: const Text('Contratos Salvos'),
        backgroundColor: const Color(0xFF0860DB),
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<ContratoSocial>>(
        future: _contratos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 60, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    "Erro ao carregar contratos",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "${snapshot.error}",
                    style: TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.folder_open, size: 60, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    "Nenhum contrato salvo.",
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }

          final contratos = snapshot.data!;

          return RefreshIndicator(
            onRefresh: () async {
              _carregarContratos();
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: contratos.length,
              itemBuilder: (context, index) {
                final contrato = contratos[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFF0860DB),
                      child: Text(
                        contrato.id.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      contrato.empresa.nomeEmpresarial,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text("CNPJ: ${contrato.empresa.cnpj}"),
                        Text(
                          "Sócios: ${contrato.socios.length}",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      _showContractDetails(context, contrato);
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _showContractDetails(BuildContext context, ContratoSocial contrato) {
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Detalhes do Contrato",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const Divider(),
                    const SizedBox(height: 8),

                    // Empresa
                    _buildSectionTitle("Empresa"),
                    _buildInfoRow("Nome", contrato.empresa.nomeEmpresarial),
                    _buildInfoRow("CNPJ", contrato.empresa.cnpj),
                    _buildInfoRow(
                      "Endereço",
                      "${contrato.empresa.enderecoSede.logradouro}, "
                          "${contrato.empresa.enderecoSede.numero} - "
                          "${contrato.empresa.enderecoSede.cidade}/"
                          "${contrato.empresa.enderecoSede.estado}",
                    ),
                    _buildInfoRow(
                      "Objeto Social",
                      contrato.empresa.objetoSocial,
                    ),
                    const SizedBox(height: 12),

                    // Capital Social
                    _buildSectionTitle("Capital Social"),
                    _buildInfoRow(
                      "Valor Total",
                      "R\$ ${contrato.capitalSocial.valorTotal.toStringAsFixed(2)}",
                    ),
                    _buildInfoRow(
                      "Integralização",
                      contrato.capitalSocial.formaIntegralizacao,
                    ),
                    const SizedBox(height: 12),

                    // Sócios
                    _buildSectionTitle("Sócios"),
                    ...contrato.socios.map(
                      (socio) => Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        color: Colors.grey[50],
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildInfoRow("Nome", socio.nome),
                              _buildInfoRow("Documento", socio.documento),
                              _buildInfoRow(
                                "Percentual",
                                "${socio.percentual.toStringAsFixed(2)}%",
                              ),
                              _buildInfoRow("Profissão", socio.profissao),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Cláusulas
                    if (contrato.clausulas.isNotEmpty) ...[
                      _buildSectionTitle("Cláusulas"),
                      ...contrato.clausulas.map(
                        (clausula) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "• ${clausula.tipo}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                clausula.descricao,
                                style: const TextStyle(color: Colors.black87),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Color(0xFF0860DB),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black87),
          children: [
            TextSpan(
              text: "$label: ",
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}
