import 'package:flutter/material.dart';
import 'package:contratosocial/configuracao/rotas.dart';

class MenuPrincipal extends StatelessWidget {
  const MenuPrincipal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, 
      appBar: AppBar(
        elevation: 10,
        backgroundColor: const Color(0xFF0860DB),
        iconTheme: const IconThemeData(
          color: Colors.white, 
        ),
        title: const Text(
          "Contrato Social",
          style: TextStyle(
            color: Colors.white,
          ),
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
              accountName: const Text(
                "Ali Osmar", //arrumar o nome aqui
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              accountEmail: const Text(""),
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
                    title: const Text(
                      "Ler contrato social",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    onTap: () {
                      Navigator.of(context).pushNamed(Rotas.lerContrato);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.people, color: Color(0xFF0860DB)),
                    title: const Text(
                      "Filtrar Sócios",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    onTap: () {
                      Navigator.of(context).pushNamed(Rotas.filtro);
                    },
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
                  Navigator.of(context).pop(); //arrumar aqui
                },
              ),
            ),
          ],
        ),
      ),
      body: const Center(
        child: Text(
          "Olá, seja bem-vindo",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
