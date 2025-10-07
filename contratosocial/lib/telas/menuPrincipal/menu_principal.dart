import 'package:contratosocial/models/Usuario.dart';
import 'package:flutter/material.dart';
import 'package:contratosocial/configuracao/rotas.dart';

class MenuPrincipal extends StatelessWidget {
  final Usuario usuario;

  const MenuPrincipal({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    // Mock de dados (poderia vir de DAO/Provider)
    int contratosAnalisados = 12;
    int sociosCadastrados = 35;

    Map<String, dynamic> ultimoContrato = {
      "data_analise": "02/10/2025",
      "data_atualizacao": "05/10/2025",
      "empresa": {
        "nome_empresarial": "Tech Solutions LTDA",
        "cnpj": "12.345.678/0001-99",
      },
      "socios": [
        {"nome": "Maria Silva", "documento": "123.456.789-00"},
        {"nome": "João Santos", "documento": "987.654.321-00"},
      ]
    };

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 10,
        shadowColor: Colors.black,
        backgroundColor: const Color(0xFF0860DB),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Contrato Social - Dashboard  ",
          style: TextStyle(color: Colors.white),
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0860DB), Color(0xFF3A8DFF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              accountName: Text(
                usuario.nome,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              accountEmail: Text(usuario.email),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 40, color: Color(0xFF0860DB)),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ListTile(
                    leading: const Icon(Icons.description, color: Color(0xFF0860DB)),
                    title: const Text("Ler contrato social",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                    onTap: () {
                      Navigator.of(context).pushNamed(Rotas.lerContrato);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.people, color: Color(0xFF0860DB)),
                    title: const Text("Filtrar Sócios",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                    onTap: () {
                      Navigator.of(context).pushNamed(Rotas.filtro);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.book, color: Color(0xFF0860DB)),
                    title: const Text("Listar contratos salvos",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                    onTap: () {
                      Navigator.of(context).pushNamed(Rotas.ListarSalvos);
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: const Icon(Icons.logout, color: Colors.redAccent),
                title: const Text("Sair", style: TextStyle(fontWeight: FontWeight.w600)),
                onTap: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    Rotas.login,
                    (Route<dynamic> route) => false,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            

            // Linha com os 2 cards
            Row(
              children: [
                Expanded(
                  child: Card(
                    color: Color.fromARGB(255, 194, 213, 241),
                    elevation: 5,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Icon(Icons.description, color: Colors.blue, size: 40),
                          const SizedBox(height: 10),
                          const Text("Contratos analisados",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text("$contratosAnalisados",
                              style: const TextStyle(fontSize: 22, color: Colors.black87)),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Card(
                    color: Color.fromARGB(255, 194, 213, 241),
                    elevation: 5,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Icon(Icons.people, color: Colors.blue, size: 40),
                          const SizedBox(height: 10),
                          const Text("Sócios cadastrados",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text("$sociosCadastrados",
                              style: const TextStyle(fontSize: 22, color: Colors.black87)),
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
              color: Color.fromARGB(255, 194, 213, 241),
              elevation: 5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Empresa: ${ultimoContrato['empresa']['nome_empresarial']}",
                        style: const TextStyle(fontWeight: FontWeight.w500)),
                    Text("CNPJ: ${ultimoContrato['empresa']['cnpj']}"),
                    const SizedBox(height: 10),
                    Text("Data de análise: ${ultimoContrato['data_analise']}"),
                    Text("Última atualização: ${ultimoContrato['data_atualizacao']}"),
                    const SizedBox(height: 10),
                    const Text("Sócios:", style: TextStyle(fontWeight: FontWeight.bold)),
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
                          style: TextStyle(color: Colors.white)
                          ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showContractDialog(BuildContext context, Map<String, dynamic> contractData) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        insetPadding: const EdgeInsets.all(16),
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(20),
          constraints: const BoxConstraints(maxHeight: 600),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Detalhes do Contrato Social",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const Divider(),
                const Text("Empresa", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("Nome: ${contractData['empresa']['nome_empresarial']}"),
                Text("CNPJ: ${contractData['empresa']['cnpj']}"),
                const SizedBox(height: 12),
                const Text("Sócios", style: TextStyle(fontWeight: FontWeight.bold)),
                ...contractData['socios'].map<Widget>((socio) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Nome: ${socio['nome']}"),
                          Text("Documento: ${socio['documento']}"),
                        ],
                      ),
                    )),
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
                      child: const Text("Fechar", style: TextStyle(color: Colors.white)),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
