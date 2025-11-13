import 'package:contratosocial/models/endereco.dart';
import 'package:contratosocial/models/socio.dart';
import 'package:flutter/material.dart';

class DialogDetalhesSocio extends StatelessWidget {
  final DTOSocio socio;
  final DTOEndereco? endereco;

  const DialogDetalhesSocio({super.key, required this.socio, this.endereco});

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
                  Icon(Icons.person, color: Colors.blueAccent),
                  SizedBox(width: 8),
                  Text(
                    "Detalhes do Sócio",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const Divider(),
              Row(
                children: [
                  const Icon(Icons.label, color: Colors.blueAccent),
                  const SizedBox(width: 8),
                  Expanded(child: Text("Nome: ${socio.nome}", softWrap: true)),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.badge, color: Colors.blueAccent),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Documento: ${socio.documento}",
                      softWrap: true,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.work, color: Colors.blueAccent),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Profissão: ${socio.profissao}",
                      softWrap: true,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.percent, color: Colors.blueAccent),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Percentual: ${socio.percentual}%",
                      softWrap: true,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.category, color: Colors.blueAccent),
                  const SizedBox(width: 8),
                  Expanded(child: Text("Tipo: ${socio.tipo}", softWrap: true)),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.flag, color: Colors.blueAccent),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Nacionalidade: ${socio.nacionalidade}",
                      softWrap: true,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.family_restroom, color: Colors.blueAccent),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Estado Civil: ${socio.estadoCivil}",
                      softWrap: true,
                    ),
                  ),
                ],
              ),
              if (endereco != null) ...[
                const SizedBox(height: 12),
                const Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.blueAccent),
                    SizedBox(width: 8),
                    Text(
                      "Endereço",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.streetview, color: Colors.blueAccent),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Logradouro: ${endereco!.logradouro}",
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.confirmation_number,
                      color: Colors.blueAccent,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Número: ${endereco!.numero}",
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.near_me, color: Colors.blueAccent),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Bairro: ${endereco!.bairro}",
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.location_city, color: Colors.blueAccent),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Cidade: ${endereco!.cidade}",
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.public, color: Colors.blueAccent),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Estado: ${endereco!.estado}",
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.markunread_mailbox,
                      color: Colors.blueAccent,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text("CEP: ${endereco!.cep}", softWrap: true),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.notes, color: Colors.blueAccent),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Complemento: ${endereco!.complemento}",
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
              ],
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
