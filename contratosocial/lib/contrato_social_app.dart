import 'package:flutter/material.dart';
import 'package:contratosocial/configuracao/rotas.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:contratosocial/telas/pagina_login.dart';

import 'package:contratosocial/telas/dashboard/dashboard_page.dart';

import 'package:contratosocial/telas/filtroContrato/filtro_contrato.dart';

import 'package:contratosocial/telas/menuPrincipal/menu_principal.dart';

import 'package:contratosocial/telas/listas/ListarSalvos.dart';

class ContratoSocialApp extends StatelessWidget {
  const ContratoSocialApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Processamento de Contrato Social',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(textTheme: GoogleFonts.poppinsTextTheme()),
      initialRoute: Rotas.login,
      routes: {
        Rotas.login: (context) => const PaginaLogin(),
        Rotas.filtro: (context) => const FiltroContrato(),
        Rotas.lerContrato: (context) => const DashboardPage(),
        Rotas.ListarSalvos: (context) => const ListarSalvos(),
        //Rotas.menuPrincipal: (context) => const MenuPrincipal(usuario: usuario),
      },
    );
  }
}
