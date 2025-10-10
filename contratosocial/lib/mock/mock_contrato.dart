// mock_contrato.dart
import '../models/endereco.dart';
import '../models/empresa.dart';
import '../models/capital_social.dart';
import '../models/administracao.dart';
import '../models/duracao_exercicio_social.dart';
import '../models/socio.dart';
import '../models/clausulas.dart';
import '../models/contrato_social.dart';

final List<DTOEndereco> mockEnderecos = [
  DTOEndereco(id: 1, logradouro: "Av. Manoel Ribas", numero: "1234", complemento: "esquina", bairro: "Centro", cidade: "Paranavaí", estado: "PR", cep: "86.605-350"),
  DTOEndereco(id: 2, logradouro: "Rua A", numero: "123", bairro: "Centro", cidade: "Paranavaí", estado: "PR", cep: "86605-000"),
  DTOEndereco(id: 3, logradouro: "Rua B", numero: "456", bairro: "Centro", cidade: "Maringá", estado: "PR", cep: "87000-000"),
];

final List<DTOEmpresa> mockEmpresas = [
  DTOEmpresa(id: 1, nomeEmpresarial: "Tech Solutions LTDA", cnpj: "12.345.678/0001-99", enderecoId: 1, objetoSocial: "Desenvolvimento de softwares e consultoria em TI", duracaoSociedade: "Prazo indeterminado"),
];

final List<DTOCapitalSocial> mockCapitalSocial = [
  DTOCapitalSocial(id: 1, valorTotal: 100000.0, formaIntegralizacao: "Dinheiro", prazoIntegralizacao: "Integralizado na constituição"),
];

final List<DTOAdministracao> mockAdministracao = [
  DTOAdministracao(id: 1, tipoAdministracao: "Administrador único", regras: "Decisões são tomadas pelo sócio administrador com poderes plenos."),
];

final List<DTODuracaoExercicioSocial> mockDuracaoExercicio = [
  DTODuracaoExercicioSocial(id: 1, periodo: "Anual", dataInicio: DateTime.parse("2023-01-01"), dataFim: DateTime.parse("2023-12-31")),
];

final List<DTOContratoSocial> mockContratoSocial = [
  DTOContratoSocial(
    id: 1,
    dataUpload: DateTime.parse("2025-10-10T12:00:00"),
    dataProcessamento: DateTime.parse("2025-10-10T12:05:00"),
    empresaId: 1,
    administracaoId: 1,
    capitalSocialId: 1,
    duracaoExercicioId: 1,
  ),
];

final List<DTOSocio> mockSocios = [
  DTOSocio(id: 1, nome: "João Silva", documento: "CPF: 111.222.333-44", enderecoId: 2, profissao: "Engenheiro de Software", percentual: 60.0, tipo: "Sócio administrador", nacionalidade: "brasileiro", estadoCivil: "solteiro", contratoSocialId: 1),
  DTOSocio(id: 2, nome: "Maria Souza", documento: "CPF: 555.666.777-88", enderecoId: 3, profissao: "Advogada", percentual: 40.0, tipo: "Sócia quotista", nacionalidade: "brasileira", estadoCivil: "casada", contratoSocialId: 1),
];

final List<DTOClausulas> mockClausulas = [
  DTOClausulas(id: 1, tipo: "Falecimento", descricao: "Em caso de falecimento de sócio, suas quotas serão transmitidas aos herdeiros legais.", contratoSocialId: 1),
  DTOClausulas(id: 2, tipo: "Saída de Sócio", descricao: "O sócio poderá se retirar da sociedade mediante aviso prévio de 60 dias.", contratoSocialId: 1),
  DTOClausulas(id: 3, tipo: "Dissolução", descricao: "A sociedade poderá ser dissolvida por decisão unânime dos sócios.", contratoSocialId: 1),
];
