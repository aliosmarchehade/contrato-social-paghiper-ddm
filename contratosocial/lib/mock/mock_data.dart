import 'package:contratosocial/models/administracao.dart';
import 'package:contratosocial/models/capital_social.dart';
import 'package:contratosocial/models/clausulas.dart';
import 'package:contratosocial/models/contrato_social.dart';
import 'package:contratosocial/models/duracao_exercicio_social.dart';
import 'package:contratosocial/models/empresa.dart';
import 'package:contratosocial/models/endereco.dart';
import 'package:contratosocial/models/socio.dart';

class MockData {
  static final DTOEndereco mockEndereco = DTOEndereco(
    logradouro: 'Rua Exemplo',
    numero: '123',
    bairro: 'Centro',
    cidade: 'São Paulo',
    estado: 'SP',
    cep: '01000-000',
  );

  static final DTOEmpresa mockEmpresa = DTOEmpresa(
    nomeEmpresarial: 'Empresa Mock teste PLease LTDAy',
    cnpj: '12.345.678/0001-991',
    enderecoId: 1, // Placeholder, will be updated with actual ID
    objetoSocial: 'Desenvolvimento de software',
    duracaoSociedade: 'Indeterminado',
  );

  static final DTOAdministracao mockAdministracao = DTOAdministracao(
    tipoAdministracao: 'Individual',
    regras: 'Regras mock',
  );

  static final DTOCapitalSocial mockCapital = DTOCapitalSocial(
    valorTotal: 100000.0,
    formaIntegralizacao: 'Dinheiro',
    prazoIntegralizacao: 'Imediato',
  );

  static final DTODuracaoExercicioSocial mockDuracao =
      DTODuracaoExercicioSocial(
        periodo: 'Anual',
        dataInicio: DateTime(2023, 1, 1),
        dataFim: DateTime(2023, 12, 31),
      );

  static final DTOContratoSocial mockContrato = DTOContratoSocial(
    dataUpload: DateTime.now(),
    dataProcessamento: DateTime.now(),
    empresaId: 1, // Placeholder, will be updated with actual ID
    administracaoId: 1, // Placeholder, will be updated with actual ID
    capitalSocialId: 1, // Placeholder, will be updated with actual ID
    duracaoExercicioId: 1, // Placeholder, will be updated with actual ID
  );

  static final List<DTOSocio> mockSocios = [
    DTOSocio(
      nome: 'Sócio 1',
      documento: '123.456.789-00',
      enderecoId: 1, // Placeholder, will be updated with actual ID
      profissao: 'Engenheiro',
      percentual: 50.0,
      tipo: 'Pessoa Física',
      nacionalidade: 'Brasileira',
      estadoCivil: 'Casado',
      contratoSocialId: 1, // Placeholder, will be updated with actual ID
    ),
    DTOSocio(
      nome: 'Sócio 2',
      documento: '987.654.321-00',
      enderecoId: 1, // Placeholder, will be updated with actual ID
      profissao: 'Advogado',
      percentual: 50.0,
      tipo: 'Pessoa Física',
      nacionalidade: 'Brasileira',
      estadoCivil: 'Solteiro',
      contratoSocialId: 1, // Placeholder, will be updated with actual ID
    ),
  ];

  static final List<DTOClausulas> mockClausulas = [
    DTOClausulas(
      titulo: 'Cláusula 1',
      descricao: 'Descrição mock 1',
      contratoSocialId: 1, // Placeholder, will be updated with actual ID
    ),
    DTOClausulas(
      titulo: 'Cláusula 2',
      descricao: 'Descrição mock 2',
      contratoSocialId: 1, // Placeholder, will be updated with actual ID
    ),
  ];
}
