import 'package:contratosocial/telas/dashboard/dashboard.dart';
import 'package:contratosocial/telas/favoritos/tela_favoritos.dart';
import 'package:contratosocial/telas/listarContratos/listar_contratos_salvos.dart';
import 'package:contratosocial/telas/listarSocios/listar_socios_salvos.dart';
import 'package:flutter/material.dart';
import 'package:contratosocial/configuracao/rotas.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:contratosocial/telas/login/pagina_login.dart';
import 'package:contratosocial/telas/lerContrato/ler_contrato.dart';

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
        Rotas.lerContrato: (context) => const LerContrato(),
        Rotas.dashboard: (context) => const Dashboard(),
        Rotas.listarContratosSalvos: (context) => const ListarSalvos(),
        Rotas.favoritos: (context) => const TelaFavoritos(),
        Rotas.listarSociosSalvos: (context) => const ListarSociosSalvos(),
      },
    );
  }
}
