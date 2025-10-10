// import 'package:flutter/material.dart';
// import 'package:contratosocial/mock/mock_contrato.dart';

// class FiltroContrato extends StatefulWidget {
//   const FiltroContrato({super.key});

//   @override
//   State<FiltroContrato> createState() => _FiltroContratoState();
// }

// class _FiltroContratoState extends State<FiltroContrato> {
//   final TextEditingController _nomeController = TextEditingController();

//   // pega sócios do contrato mockado
//   final List<dynamic> socios = mockContrato["socios"];

//   List<Map<String, dynamic>> _resultados = [];

//   void _buscarPorNome() {
//     final query = _nomeController.text.trim().toLowerCase();
//     setState(() {
//       _resultados = socios
//           .where((s) => s["nome"].toLowerCase().contains(query))
//           .map((s) => Map<String, dynamic>.from(s))
//           .toList();
//     });
//   }

//   void _limparFiltro() {
//     setState(() {
//       _resultados.clear();
//       _nomeController.clear();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         elevation: 10,
//         shadowColor: Colors.black,
//         backgroundColor: const Color(0xFF0860DB),
//         iconTheme: const IconThemeData(color: Colors.white),
//         title: const Text(
//           "Filtrar Contrato Social",
//           style: TextStyle(color: Colors.white),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             // Campo de busca por nome
//             TextField(
//               controller: _nomeController,
//               decoration: InputDecoration(
//                 labelText: "Buscar sócio por nome",
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 suffixIcon: IconButton(
//                   icon: const Icon(Icons.search),
//                   onPressed: _buscarPorNome,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),

//             // Botão limpar filtro
//             Align(
//               alignment: Alignment.centerRight,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.grey,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 onPressed: _limparFiltro,
//                 child: const Text(
//                   "Limpar",
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),

//             // Lista de resultados
//             Expanded(
//               child: _resultados.isEmpty
//                   ? const Center(
//                       child: Text(
//                         "Nenhum resultado encontrado",
//                         style: TextStyle(color: Colors.grey),
//                       ),
//                     )
//                   : ListView.builder(
//                       itemCount: _resultados.length,
//                       itemBuilder: (context, index) {
//                         final socio = _resultados[index];
//                         return Card(
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           elevation: 4,
//                           margin: const EdgeInsets.symmetric(vertical: 6),
//                           child: ListTile(
//                             leading: Icon(
//                               socio["tipo"]?.toString().toLowerCase().contains("administrador") == true
//                                   ? Icons.star
//                                   : Icons.person,
//                               color: socio["tipo"]?.toString().toLowerCase().contains("administrador") == true
//                                   ? Colors.orange
//                                   : Colors.blue,
//                             ),
//                             title: Text(socio["nome"]),
//                             subtitle: Text(
//                               socio["tipo"] ?? "Sócio",
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
