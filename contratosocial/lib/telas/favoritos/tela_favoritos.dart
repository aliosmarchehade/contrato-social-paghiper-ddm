import 'package:contratosocial/banco/sqlite/dao/clausulas_dao.dart';
import 'package:contratosocial/components/dialog_detalhes_contrato.dart';
import 'package:flutter/material.dart';
import 'package:contratosocial/banco/sqlite/dao/contrato_social_dao.dart';
import 'package:contratosocial/banco/sqlite/dao/empresa_dao.dart';
import 'package:contratosocial/banco/sqlite/dao/socio_dao.dart';
import 'package:contratosocial/models/contrato_social.dart';
import 'package:contratosocial/models/empresa.dart';
import 'package:contratosocial/models/socio.dart';
import 'package:contratosocial/components/cartao_contrato.dart';

class TelaFavoritos extends StatefulWidget {
  const TelaFavoritos({super.key});
  

  @override
  State<TelaFavoritos> createState() => _TelaFavoritosState();
}

class _TelaFavoritosState extends State<TelaFavoritos> {
  final DAOContratoSocial _daoContrato = DAOContratoSocial();
  final DAOEmpresa _daoEmpresa = DAOEmpresa();
  final DAOSocio _daoSocio = DAOSocio();

  List<Map<String, dynamic>> _favoritosCompletos = [];

  @override
  void initState() {
    super.initState();
    _carregarFavoritos();
  }

  Future<void> _carregarFavoritos() async {
    final contratos = await _daoContrato.buscarFavoritos();

    List<Map<String, dynamic>> completos = [];
    for (var c in contratos) {
      final empresa = await _daoEmpresa.buscarPorId(c.empresaId);
      final socios = await _daoSocio.buscarPorContratoSocial(c.id!); 
      completos.add({
        'contrato': c,
        'empresa': empresa,
        'socios': socios,
      });
    }

    setState(() {
      _favoritosCompletos = completos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contratos Favoritos",
        style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)  )
        ),    
        backgroundColor: const Color(0xFF0860DB),
      ),
      body: _favoritosCompletos.isEmpty
          ? const Center(
              child: Text(
                "Nenhum contrato favoritado ainda.",
                style: TextStyle(fontSize: 18),
              ),
            )
          : RefreshIndicator(
              onRefresh: _carregarFavoritos, 
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _favoritosCompletos.length,
                itemBuilder: (context, index) {
                  final item = _favoritosCompletos[index];
                  final contrato = item['contrato'] as DTOContratoSocial;
                  final empresa = item['empresa'] as DTOEmpresa;
                  final socios = item['socios'] as List<DTOSocio>;

                  return CartaoContrato(
                    contrato: contrato,
                    empresa: empresa,
                    socios: socios,
                    onVerDetalhes: () async {
                      // Buscar cláusulas do contrato do banco (ou passar lista já carregada)
                      final clausulas = await DAOClausulas().buscarPorContratoSocial(contrato.id!);

                      showDialog(
                        context: context,
                        builder: (context) => DialogDetalhesContrato(
                          contrato: contrato,
                          empresa: empresa,
                          socios: socios,
                          clausulas: clausulas,
                        ),
                      );
                    },
                    onExcluir: () async {
                      await _daoContrato.excluir(contrato.id!);
                      _carregarFavoritos(); // atualiza a lista
                    },
                  );
                },
              ),
            ),
    );
  }
}
