import 'package:flutter/material.dart';
import 'dashboard_page.dart';

class ContratoSocialApp extends StatelessWidget {
  const ContratoSocialApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Processamento de Contrato Social',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const DashboardPage(),
    );
  }
}
