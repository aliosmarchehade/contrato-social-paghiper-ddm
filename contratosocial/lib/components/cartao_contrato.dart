import 'package:contratosocial/models/contrato_social.dart';
import 'package:contratosocial/models/empresa.dart';
import 'package:contratosocial/models/socio.dart';
import 'package:flutter/material.dart';

class CartaoContrato extends StatefulWidget {
  final DTOContratoSocial contrato;
  final DTOEmpresa empresa;
  final List<DTOSocio> socios;
  final VoidCallback onVerDetalhes;
  final VoidCallback onExcluir;

  const CartaoContrato({
    super.key,
    required this.contrato,
    required this.empresa,
    required this.socios,
    required this.onVerDetalhes,
    required this.onExcluir,
  });

  @override
  State<CartaoContrato> createState() => _CartaoContratoState();
}

class _CartaoContratoState extends State<CartaoContrato> {
  bool _isFavorito = false; // Estado do favorito

  void _toggleFavorito() {
    setState(() {
      _isFavorito = !_isFavorito;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isFavorito
              ? 'Contrato adicionado aos favoritos!'
              : 'Contrato removido dos favoritos!',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(255, 194, 213, 241),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 16),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.business, color: Colors.blueAccent),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Empresa: ${widget.empresa.nomeEmpresarial}",
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.badge, color: Colors.blueAccent),
                    const SizedBox(width: 8),
                    Text("CNPJ: ${widget.empresa.cnpj}"),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.upload, color: Colors.blueAccent),
                    const SizedBox(width: 8),
                    Text(
                      "Data de Upload: ${widget.contrato.dataUpload.toIso8601String().split('T')[0]}",
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.event, color: Colors.blueAccent),
                    const SizedBox(width: 8),
                    Text(
                      "Data de Processamento: ${widget.contrato.dataProcessamento.toIso8601String().split('T')[0]}",
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.group, color: Colors.blueAccent),
                    const SizedBox(width: 8),
                    const Text(
                      "Sócios:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                ...widget.socios.map<Widget>(
                  (s) => Padding(
                    padding: const EdgeInsets.only(left: 24),
                    child: Text("- ${s.nome} (${s.documento})"),
                  ),
                ),
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
                      onPressed: widget.onVerDetalhes,
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
                          builder: (context) => AlertDialog(
                            backgroundColor: Colors.white,
                            title: const Text("Confirmar Exclusão"),
                            content: const Text(
                              "Deseja realmente excluir este contrato?",
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
                                  widget.onExcluir();
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

          // Ícone de estrela no canto superior direito
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              icon: Icon(
                _isFavorito ? Icons.star : Icons.star_border,
                color: const Color.fromARGB(255, 0, 0, 0),  
                size: 28,
              ),
              onPressed: _toggleFavorito,
            ),
          ),
        ],
      ),
    );
  }
}
