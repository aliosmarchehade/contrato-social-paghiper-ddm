import 'package:contratosocial/banco/sqlite/dao/endereco_dao.dart';
import 'package:contratosocial/banco/sqlite/dao/socio_dao.dart';
import 'package:contratosocial/components/app_drawer.dart';
import 'package:contratosocial/components/barra_pesquisa.dart';
import 'package:contratosocial/components/cartao_socio.dart';
import 'package:contratosocial/components/dialog_detalhes_socio.dart';
import 'package:contratosocial/configuracao/rotas.dart';
import 'package:contratosocial/models/endereco.dart';
import 'package:contratosocial/models/socio.dart';
import 'package:flutter/material.dart';

class ListarSociosSalvos extends StatefulWidget {
  const ListarSociosSalvos({super.key});

  @override
  State<ListarSociosSalvos> createState() => _ListarSociosSalvosState();
}

class _ListarSociosSalvosState extends State<ListarSociosSalvos> {
  List<Map<String, dynamic>> _allSocios = [];
  List<Map<String, dynamic>> _filteredSocios = [];
  bool _isLoading = true;
  String? _error;
  final TextEditingController _searchController = TextEditingController();
  String _sortBy = 'nome';

  @override
  void initState() {
    super.initState();
    _loadSocios();
  }

  Future<void> _loadSocios() async {
    try {
      final list = await _carregarSocios();
      setState(() {
        _allSocios = list;
        _filteredSocios = list;
        _sortSocios();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Erro ao carregar sócios: $e';
        _isLoading = false;
      });
    }
  }

  Future<List<Map<String, dynamic>>> _carregarSocios() async {
    final socios = await DAOSocio().buscarTodos();
    final List<Map<String, dynamic>> sociosComDetalhes = [];

    for (final socio in socios) {
      final endereco = await DAOEndereco().buscarPorId(socio.enderecoId);
      sociosComDetalhes.add({'socio': socio, 'endereco': endereco});
    }

    print('Total de sócios com detalhes: ${sociosComDetalhes.length}');
    return sociosComDetalhes;
  }

  void _sortSocios() {
    setState(() {
      if (_sortBy == 'nome') {
        _filteredSocios.sort((a, b) {
          final aNome = (a['socio'] as DTOSocio).nome.toLowerCase();
          final bNome = (b['socio'] as DTOSocio).nome.toLowerCase();
          return aNome.compareTo(bNome);
        });
      } else if (_sortBy == 'percentual') {
        _filteredSocios.sort((a, b) {
          final aPercentual = (a['socio'] as DTOSocio).percentual;
          final bPercentual = (b['socio'] as DTOSocio).percentual;
          return bPercentual.compareTo(aPercentual);
        });
      }
    });
  }

  Future<void> _excluirSocio(int socioId) async {
    try {
      await DAOSocio().excluir(socioId);
      await _loadSocios();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sócio excluído com sucesso!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao excluir sócio: $e')));
    }
  }

  void _filterSocios(String query) {
    List<Map<String, dynamic>> filteredSocios = List.from(_allSocios);

    if (query.isNotEmpty) {
      final lowerQuery = query.toLowerCase();
      filteredSocios =
          _allSocios.where((data) {
            final socio = data['socio'] as DTOSocio;
            return socio.nome.toLowerCase().contains(lowerQuery);
          }).toList();
    }

    if (_sortBy == 'nome') {
      filteredSocios.sort((a, b) {
        final aNome = (a['socio'] as DTOSocio).nome.toLowerCase();
        final bNome = (b['socio'] as DTOSocio).nome.toLowerCase();
        return aNome.compareTo(bNome);
      });
    } else if (_sortBy == 'percentual') {
      filteredSocios.sort((a, b) {
        final aPercentual = (a['socio'] as DTOSocio).percentual;
        final bPercentual = (b['socio'] as DTOSocio).percentual;
        return bPercentual.compareTo(aPercentual);
      });
    }

    setState(() {
      _filteredSocios = filteredSocios;
    });
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
          "Sócios - Salvos",
          style: TextStyle(color: Colors.white),
        ),
      ),
      drawer: const AppDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BarraPesquisa(
            controller: _searchController,
            labelText: 'Pesquisar por nome do sócio',
            onChanged: _filterSocios,
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
                        _sortBy == 'nome'
                            ? Colors.blueAccent
                            : Colors.grey[300],
                    foregroundColor:
                        _sortBy == 'nome' ? Colors.white : Colors.black,
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
                      _sortBy = 'nome';
                      _sortSocios();
                    });
                  },
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.sort_by_alpha, size: 18),
                      SizedBox(width: 4),
                      Text('Nome', style: TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _sortBy == 'percentual'
                            ? Colors.blueAccent
                            : Colors.grey[300],
                    foregroundColor:
                        _sortBy == 'percentual' ? Colors.white : Colors.black,
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
                      _sortBy = 'percentual';
                      _sortSocios();
                    });
                  },
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.percent, size: 18),
                      SizedBox(width: 4),
                      Text('Percentual', style: TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Sócios Salvos",
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
                    : _filteredSocios.isEmpty
                    ? const Center(
                      child: Text('Nenhum sócio salvo encontrado.'),
                    )
                    : SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _filteredSocios.length,
                        itemBuilder: (context, index) {
                          final data = _filteredSocios[index];
                          final DTOSocio socio = data['socio'];
                          final DTOEndereco? endereco = data['endereco'];

                          return CartaoSocio(
                            socio: socio,
                            endereco: endereco,
                            onVerDetalhes: () {
                              showDialog(
                                context: context,
                                builder:
                                    (context) => DialogDetalhesSocio(
                                      socio: socio,
                                      endereco: endereco,
                                    ),
                              );
                            },
                            onExcluir: () => _excluirSocio(socio.id!),
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
