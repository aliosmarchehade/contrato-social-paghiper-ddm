import 'package:flutter/material.dart';
import 'package:contratosocial/configuracao/rotas.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
            accountName: const Text(
              "Danizoca",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            accountEmail: const Text("danizoca@gmail.com"),
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
                  leading: const Icon(Icons.home, color: Color(0xFF0860DB)),
                  title: const Text(
                    "Dashboard",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  onTap: () => Navigator.of(context).pushNamed(Rotas.dashboard),
                ),
                ListTile(
                  leading: const Icon(Icons.description, color: Color(0xFF0860DB)),
                  title: const Text(
                    "Ler contrato social",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  onTap: () => Navigator.of(context).pushNamed(Rotas.lerContrato),
                ),
                ListTile(
                  leading: const Icon(Icons.people, color: Color(0xFF0860DB)),
                  title: const Text(
                    "Filtrar Sócios",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  onTap: () => Navigator.of(context).pushNamed(Rotas.filtrarContrato),
                ),
                ListTile(
                  leading: const Icon(Icons.book, color: Color(0xFF0860DB)),
                  title: const Text(
                    "Listar contratos salvos",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  onTap: () => Navigator.of(context).pushNamed(Rotas.listarContratosSalvos),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: const Text(
                "Sair",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              onTap: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  Rotas.login,
                  (route) => false,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
