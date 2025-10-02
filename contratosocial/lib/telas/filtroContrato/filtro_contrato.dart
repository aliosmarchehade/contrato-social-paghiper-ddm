// import 'package:flutter/material.dart';

// class FiltroContrato extends StatefulWidget {
//   const FiltroContrato({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         iconTheme: const IconThemeData(
//           color: Colors.white,
//         ),
//         title: const Text(
//           "Ler Contrato Social",
//           style: TextStyle(
//             color: Colors.white,
//           ),
//         ),
//         elevation: 10,
//         backgroundColor: Color(0xFF0860DB),
//       ),
//       body: Center(
//         child: Text(
//           "Olá, seja bem-vindo",
//           style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
//         ),
//       )
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:contratosocial/configuracao/rotas.dart';

class FiltroContrato extends StatelessWidget {
  const FiltroContrato({super.key});

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
          "Filtrar Contrato Social",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: const Center(
        child: Text(
          "Filtro",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
