import 'package:contratosocial/banco/sqlite/dao/socio_dao.dart';
import 'package:contratosocial/models/endereco.dart';
import 'package:contratosocial/models/socio.dart';
import 'package:flutter/material.dart';

class CartaoSocio extends StatelessWidget {
  final DTOSocio socio;
  final DTOEndereco? endereco;
  final VoidCallback onVerDetalhes;
  final VoidCallback onExcluir;

  const CartaoSocio({
    super.key,
    required this.socio,
    this.endereco,
    required this.onVerDetalhes,
    required this.onExcluir,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(255, 238, 242, 248),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.person, color: Colors.blueAccent),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Nome: ${socio.nome}",
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.badge, color: Colors.blueAccent),
                const SizedBox(width: 8),
                Text("Documento: ${socio.documento}"),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.work, color: Colors.blueAccent),
                const SizedBox(width: 8),
                Text("Profissão: ${socio.profissao}"),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.percent, color: Colors.blueAccent),
                const SizedBox(width: 8),
                Text("Percentual: ${socio.percentual}%"),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.category, color: Colors.blueAccent),
                const SizedBox(width: 8),
                Text("Tipo: ${socio.tipo}"),
              ],
            ),
            if (endereco != null) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.blueAccent),
                  const SizedBox(width: 8),
                  const Text(
                    "Endereço:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 24),
                child: Text(
                  "${endereco!.logradouro}, ${endereco!.numero} - ${endereco!.bairro}, ${endereco!.cidade} - ${endereco!.estado}",
                ),
              ),
            ],
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: onVerDetalhes,
                  icon: const Icon(Icons.visibility, color: Colors.white),
                  label: const Text(
                    "Ver detalhes",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder:
                          (context) => AlertDialog(
                            backgroundColor: Colors.white,
                            title: const Text("Confirmar Exclusão"),
                            content: const Text(
                              "Deseja realmente excluir este sócio?",
                            ),
                            actions: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueAccent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: () => Navigator.pop(context),
                                child: const Text(
                                  "Cancelar",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.redAccent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: () {
                                  onExcluir();
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  "Excluir",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                    );
                  },
                  icon: const Icon(Icons.delete, color: Colors.white),
                  label: const Text(
                    "Excluir",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
