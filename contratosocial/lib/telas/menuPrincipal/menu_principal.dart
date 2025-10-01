
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
        backgroundColor: Colors.blueAccent,
        iconTheme: const IconThemeData(
          color: Colors.white, // deixa o ícone do menu branco
        ),
        title: const Text(
          "Contrato Social",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blueAccent,
              ),
              child: Text(
                "Menu",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.description),
              title: const Text("Ler contrato social"),
              onTap: () {
                Navigator.of(context).pushNamed(Rotas.lerContrato);
              },
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text("Filtrar Sócios"),
              onTap: () {
                Navigator.of(context).pushNamed(Rotas.filtro);
              },
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
