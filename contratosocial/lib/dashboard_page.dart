import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard - Contrato Social"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Simulação de upload
            ElevatedButton.icon(
              onPressed: () {
                // Futuramente: abrir seletor de arquivo PDF
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Upload de contrato social")),
                );
              },
              icon: const Icon(Icons.upload_file),
              label: const Text("Enviar Contrato Social"),
            ),
            const SizedBox(height: 20),

            // Área para exibição futura dos dados extraídos
            const Text(
              "Dados extraídos do contrato:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "Nenhum dado disponível.\n\n"
                  "Aqui exibiremos o JSON mockado do contrato social.",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
