import 'package:contratosocial/banco/contrato_social_dao.dart';
import 'package:flutter/material.dart';

class ListarSalvos extends StatefulWidget {
  const ListarSalvos({super.key});

  @override
  State<ListarSalvos> createState() => _ListarSalvosState();
}

class _ListarSalvosState extends State<ListarSalvos> {
  late Future<List<Map<String, dynamic>>> _contratos;

  @override
  void initState() {
    super.initState();
    _carregarContratos();
  }

  void _carregarContratos() {
    setState(() {
      _contratos = ContratoSocialDao().getAllContratos().then(
        (contratos) => contratos.map((contrato) => contrato.toMap()).toList(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _contratos,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text("Erro: ${snapshot.error}"));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("Nenhum contrato salvo."));
        }

        final contratos = snapshot.data!;

        return ListView.builder(
          itemCount: contratos.length,
          itemBuilder: (context, index) {
            final contrato = contratos[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              elevation: 3,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue.shade700,
                  child: Text(
                    contrato['id'].toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(
                  contrato['nome_empresa'] ?? "Empresa sem nome",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
