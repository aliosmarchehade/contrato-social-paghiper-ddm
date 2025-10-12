import 'package:contratosocial/models/usuario.dart';
import 'package:contratosocial/telas/dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:contratosocial/configuracao/rotas.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:contratosocial/telas/pagina_login.dart';

import 'package:contratosocial/telas/lerContrato/ler_contrato.dart';
import 'package:contratosocial/telas/filtroContrato/filtro_contrato.dart';
//import 'package:contratosocial/telas/dashboard/dashboard.dart';
import 'package:contratosocial/telas/listarContratos/listar_contratos_salvos.dart';

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
        //Rotas.filtrarContrato: (context) => const FiltroContrato(),
        Rotas.lerContrato: (context) => const LerContrato(),
        Rotas.listarContratosSalvos: (context) => const ListarSalvos(),

        Rotas.dashboard: (context) {
          final args = ModalRoute.of(context)!.settings.arguments;
          if (args == null) {
            // Se não veio nada, redireciona para login
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacementNamed(context, Rotas.login);
            });
            return const SizedBox.shrink(); // retorna algo temporário
          }

          final usuario = args as Usuario;
          return Dashboard(usuario: usuario);
        },

        // Rotas.dashboard: (context) {
        //     final usuario = ModalRoute.of(context)!.settings.arguments as Usuario;
        //     return Dashboard(usuario: usuario);
        //   },
        //antes estava assim, só que nao tem uma condicional para caso o usuário nao esteja sendo persistido
      },
    );
  }
}

//import 'package:contratosocial/models/Usuario.dart';
// import 'package:contratosocial/telas/dashboard/dashboard.dart';
// import 'package:flutter/material.dart';
// import 'package:contratosocial/configuracao/rotas.dart';
// import 'package:google_fonts/google_fonts.dart';

// import 'package:contratosocial/telas/pagina_login.dart';
// import 'package:contratosocial/telas/lerContrato/ler_contrato.dart';
// import 'package:contratosocial/telas/filtroContrato/filtro_contrato.dart';
// import 'package:contratosocial/telas/listarContratos/listar_contratos_salvos.dart';

// class ContratoSocialApp extends StatelessWidget {
//   const ContratoSocialApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Processamento de Contrato Social',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(textTheme: GoogleFonts.poppinsTextTheme()),
//       initialRoute: Rotas.login,
//       routes: {
//         Rotas.login: (context) => const PaginaLogin(),
//         Rotas.filtrarContrato: (context) => const FiltroContrato(),
//         Rotas.lerContrato: (context) => const LerContrato(),
//         Rotas.listarContratosSalvos: (context) => const ListarSalvos(),
//         Rotas.dashboard: (context) {
//           final usuario = ModalRoute.of(context)!.settings.arguments as Usuario;
//           return Dashboard(usuario: usuario);
//         },
//       },
//     );
//   }
// }
