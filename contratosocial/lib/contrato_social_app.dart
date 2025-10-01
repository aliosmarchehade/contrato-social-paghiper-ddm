import 'package:flutter/material.dart';
import 'package:contratosocial/configuracao/rotas.dart';


import 'package:contratosocial/telas/pagina_login.dart';



import 'package:contratosocial/telas/dashboard/dashboard_page.dart';

import 'package:contratosocial/telas/menuPrincipal/menu_principal.dart';




class ContratoSocialApp extends StatelessWidget {
  const ContratoSocialApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Processamento de Contrato Social',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: Rotas.menuPrincipal,
      routes: {
        Rotas.menuPrincipal: (context) => const MenuPrincipal(),
        Rotas.lerContrato: (context) => const DashboardPage(),
        Rotas.login: (context) => const PaginaLogin(),
        // Rotas.lerContrato: (context) => const DashboardPage(),
        // Rotas.lerContrato: (context) => const DashboardPage(),
        // Rotas.lerContrato: (context) => const DashboardPage(),
        // Rotas.lerContrato: (context) => const DashboardPage(),
        // Rotas.lerContrato: (context) => const DashboardPage(),
      },
    );
  }
}
