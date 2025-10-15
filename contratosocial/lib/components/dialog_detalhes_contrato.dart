import 'package:contratosocial/models/clausulas.dart';
import 'package:contratosocial/models/contrato_social.dart';
import 'package:contratosocial/models/empresa.dart';
import 'package:contratosocial/models/socio.dart';
import 'package:flutter/material.dart';

class DialogDetalhesContrato extends StatelessWidget {
  final DTOContratoSocial contrato;
  final DTOEmpresa empresa;
  final List<DTOSocio> socios;
  final List<DTOClausulas> clausulas;

  const DialogDetalhesContrato({
    super.key,
    required this.contrato,
    required this.empresa,
    required this.socios,
    required this.clausulas,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.all(16),
      backgroundColor: Colors.white,
      child: Container(
        padding: const EdgeInsets.all(20),
        constraints: const BoxConstraints(maxHeight: 600),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.description, color: Colors.blueAccent),
                  SizedBox(width: 8),
                  Text(
                    "Detalhes do Contrato Social",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const Divider(),
              const Row(
                children: [
                  Icon(Icons.business, color: Colors.blueAccent),
                  SizedBox(width: 8),
                  Text(
                    "Empresa",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.label, color: Colors.blueAccent),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Nome: ${empresa.nomeEmpresarial}",
                      softWrap: true,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.badge, color: Colors.blueAccent),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text("CNPJ: ${empresa.cnpj}", softWrap: true),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.work, color: Colors.blueAccent),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Objeto Social: ${empresa.objetoSocial}",
                      softWrap: true,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.calendar_today, color: Colors.blueAccent),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Duração da Sociedade: ${empresa.duracaoSociedade}",
                      softWrap: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Row(
                children: [
                  Icon(Icons.group, color: Colors.blueAccent),
                  SizedBox(width: 8),
                  Text("Sócios", style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              ...socios.asMap().entries.map<Widget>((entry) {
                final index = entry.key;
                final socio = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 6, left: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.person, color: Colors.blueAccent),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "Sócio ${index + 1}",
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Nome: ${socio.nome}"),
                            Text("Documento: ${socio.documento}"),
                            Text("Profissão: ${socio.profissao}"),
                            Text("Percentual: ${socio.percentual}%"),
                            Text("Tipo: ${socio.tipo}"),
                            Text("Nacionalidade: ${socio.nacionalidade}"),
                            Text("Estado Civil: ${socio.estadoCivil}"),
                          ],
                        ),
                      ),
                      if (index < socios.length - 1) const Divider(),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 12),
              const Row(
                children: [
                  Icon(Icons.article, color: Colors.blueAccent),
                  SizedBox(width: 8),
                  Text(
                    "Cláusulas",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              ...clausulas.map<Widget>(
                (clausula) => Padding(
                  padding: const EdgeInsets.only(bottom: 6, left: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.title, color: Colors.blueAccent),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "Título: ${clausula.titulo}",
                              softWrap: true,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.description,
                            color: Colors.blueAccent,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "Descrição: ${clausula.descricao}",
                              softWrap: true,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "Fechar",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
