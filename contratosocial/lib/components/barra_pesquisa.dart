import 'package:contratosocial/models/capital_social.dart';
import 'package:contratosocial/models/contrato_social.dart';
import 'package:contratosocial/models/empresa.dart';
import 'package:flutter/material.dart';

class BarraPesquisa extends StatelessWidget {
  final TextEditingController controller;
  final List<Map<String, dynamic>> allContratos;
  final ValueChanged<List<Map<String, dynamic>>> onFiltered;
  final String sortBy;

  const BarraPesquisa({
    super.key,
    required this.controller,
    required this.allContratos,
    required this.onFiltered,
    required this.sortBy,
  });

  void _filterContracts(String query) {
    List<Map<String, dynamic>> filteredContratos = List.from(allContratos);

    if (query.isNotEmpty) {
      final lowerQuery = query.toLowerCase();
      filteredContratos =
          allContratos.where((data) {
            final empresa = data['empresa'] as DTOEmpresa;
            return empresa.nomeEmpresarial.toLowerCase().contains(lowerQuery);
          }).toList();
    }

    // Aplicar ordenação após filtragem
    if (sortBy == 'dataUpload') {
      filteredContratos.sort((a, b) {
        final aDate = (a['contrato'] as DTOContratoSocial).dataUpload;
        final bDate = (b['contrato'] as DTOContratoSocial).dataUpload;
        return bDate.compareTo(aDate); // Mais recente primeiro
      });
    } else if (sortBy == 'capitalSocial') {
      filteredContratos.sort((a, b) {
        final aValue = (a['capitalSocial'] as DTOCapitalSocial).valorTotal;
        final bValue = (b['capitalSocial'] as DTOCapitalSocial).valorTotal;
        return bValue.compareTo(aValue); // Maior valor primeiro
      });
    }

    onFiltered(filteredContratos);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: controller,
        onChanged: _filterContracts,
        decoration: InputDecoration(
          labelText: 'Pesquisar por nome da empresa',
          prefixIcon: const Icon(Icons.search, color: Colors.blueAccent),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.blueAccent),
          ),
        ),
      ),
    );
  }
}
