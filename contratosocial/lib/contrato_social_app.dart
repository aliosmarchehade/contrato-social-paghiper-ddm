import 'package:contratosocial/telas/pagina_login.dart';
import 'package:flutter/material.dart';
import 'dashboard/dashboard_page.dart';

class ContratoSocialApp extends StatelessWidget {
  const ContratoSocialApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Processamento de Contrato Social',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const PaginaLogin(),
      //home: const DashboardPage(),
    );
  }
}
