import 'package:flutter/material.dart';

class TelaFavoritos extends StatelessWidget {
  const TelaFavoritos({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contratos Favoritos"),
        backgroundColor: const Color(0xFF0860DB),
      ),
      body: const Center(
        child: Text(
          "Nenhum contrato favoritado ainda.",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
