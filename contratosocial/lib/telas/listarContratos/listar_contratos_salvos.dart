import 'package:contratosocial/banco/sqlite/dao/clausulas_dao.dart';
import 'package:contratosocial/banco/sqlite/dao/contrato_social_dao.dart';
import 'package:contratosocial/banco/sqlite/dao/empresa_dao.dart';
import 'package:contratosocial/banco/sqlite/dao/socio_dao.dart';
import 'package:contratosocial/banco/sqlite/dao/capital_social_dao.dart';
import 'package:contratosocial/components/barra_pesquisa.dart';
import 'package:contratosocial/components/cartao_contrato.dart';
import 'package:contratosocial/components/dialog_detalhes_contrato.dart';
import 'package:contratosocial/configuracao/rotas.dart';
import 'package:contratosocial/models/clausulas.dart';
import 'package:contratosocial/models/contrato_social.dart';
import 'package:contratosocial/models/empresa.dart';
import 'package:contratosocial/models/socio.dart';
import 'package:contratosocial/models/capital_social.dart';
import 'package:flutter/material.dart';

class ListarSalvos extends StatefulWidget {
  const ListarSalvos({super.key});

  @override
  State<ListarSalvos> createState() => _ListarSalvosState();
}

class _ListarSalvosState extends State<ListarSalvos> {
  List<Map<String, dynamic>> _allContratos = [];
  List<Map<String, dynamic>> _filteredContratos = [];
  bool _isLoading = true;
  String? _error;
  final TextEditingController _searchController = TextEditingController();
  String _sortBy = 'dataUpload'; // Padrão: ordenar por data de upload

  @override
  void initState() {
    super.initState();
    _loadContracts();
  }

  Future<void> _loadContracts() async {
    try {
      final list = await _carregarContratos();
      setState(() {
        _allContratos = list;
        _filteredContratos = list;
        _sortContracts(); // Aplica a ordenação inicial
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Erro ao carregar contratos: $e';
        _isLoading = false;
      });
    }
  }

  Future<List<Map<String, dynamic>>> _carregarContratos() async {
    final contratos = await DAOContratoSocial().buscarTodos();
    final List<Map<String, dynamic>> contratosComDetalhes = [];

    for (final contrato in contratos) {
      final empresa = await DAOEmpresa().buscarPorId(contrato.empresaId);
      final socios = await DAOSocio().buscarPorContratoSocial(contrato.id!);
      final clausulas = await DAOClausulas().buscarPorContratoSocial(
        contrato.id!,
      );
      final capitalSocial = await DAOCapitalSocial().buscarPorId(
        contrato.capitalSocialId,
      );

      if (empresa != null && capitalSocial != null) {
        contratosComDetalhes.add({
          'contrato': contrato,
          'empresa': empresa,
          'socios': socios,
          'clausulas': clausulas,
          'capitalSocial': capitalSocial,
        });
      } else {
        print(
          'Empresa ou capital social não encontrado para contrato ID: ${contrato.id}',
        );
      }
    }

    print('Total de contratos com detalhes: ${contratosComDetalhes.length}');
    return contratosComDetalhes;
  }

  void _sortContracts() {
    setState(() {
      if (_sortBy == 'dataUpload') {
        _filteredContratos.sort((a, b) {
          final aDate = (a['contrato'] as DTOContratoSocial).dataUpload;
          final bDate = (b['contrato'] as DTOContratoSocial).dataUpload;
          return bDate.compareTo(aDate); // Mais recente primeiro
        });
      } else if (_sortBy == 'capitalSocial') {
        _filteredContratos.sort((a, b) {
          final aValue = (a['capitalSocial'] as DTOCapitalSocial).valorTotal;
          final bValue = (b['capitalSocial'] as DTOCapitalSocial).valorTotal;
          return bValue.compareTo(aValue); // Maior valor primeiro
        });
      }
    });
  }

  Future<void> _excluirContrato(int contratoId) async {
    try {
      await DAOContratoSocial().excluir(contratoId);
      await _loadContracts();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Contrato excluído com sucesso!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao excluir contrato: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 10,
        shadowColor: Colors.black,
        backgroundColor: const Color(0xFF0860DB),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Contratos Salvos",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BarraPesquisa(
            controller: _searchController,
            allContratos: _allContratos,
            onFiltered: (filtered) {
              setState(() {
                _filteredContratos = filtered;
              });
            },
            sortBy: _sortBy,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _sortBy == 'dataUpload'
                            ? Colors.blueAccent
                            : Colors.grey[300],
                    foregroundColor:
                        _sortBy == 'dataUpload' ? Colors.white : Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      _sortBy = 'dataUpload';
                      _sortContracts();
                    });
                  },
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.upload, size: 18),
                      SizedBox(width: 4),
                      Text('Data', style: TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _sortBy == 'capitalSocial'
                            ? Colors.blueAccent
                            : Colors.grey[300],
                    foregroundColor:
                        _sortBy == 'capitalSocial'
                            ? Colors.white
                            : Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      _sortBy = 'capitalSocial';
                      _sortContracts();
                    });
                  },
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.account_balance, size: 18),
                      SizedBox(width: 4),
                      Text('Capital', style: TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Contratos Salvos",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Divider(),
          ),
          Expanded(
            child:
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _error != null
                    ? Center(child: Text(_error!))
                    : _filteredContratos.isEmpty
                    ? const Center(
                      child: Text('Nenhum contrato salvo encontrado.'),
                    )
                    : SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _filteredContratos.length,
                        itemBuilder: (context, index) {
                          final data = _filteredContratos[index];
                          final DTOContratoSocial contrato = data['contrato'];
                          final DTOEmpresa empresa = data['empresa'];
                          final List<DTOSocio> socios = data['socios'];

                          return CartaoContrato(
                            contrato: contrato,
                            empresa: empresa,
                            socios: socios,
                            onVerDetalhes: () {
                              showDialog(
                                context: context,
                                builder:
                                    (context) => DialogDetalhesContrato(
                                      contrato: contrato,
                                      empresa: empresa,
                                      socios: socios,
                                      clausulas: data['clausulas'],
                                    ),
                              );
                            },
                            onExcluir: () => _excluirContrato(contrato.id!),
                          );
                        },
                      ),
                    ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
