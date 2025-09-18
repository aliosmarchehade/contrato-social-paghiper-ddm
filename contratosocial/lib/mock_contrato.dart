
const Map<String, dynamic> mockContrato = {
  "id": 1,
  "empresa": {
    "nome_empresarial": "Tech Solutions LTDA",
    "cnpj": "12.345.678/0001-99",
    "endereco": {
      "logradouro": "Av. Manoel Ribas",
      "numero": "1234",
      "complemento": "esquinsa",
      "bairro": "centro",
      "cidade": "Paranavaí",
      "estado": "PR",
      "cep": "86.605-350"
    },
    "objeto_social": "Desenvolvimento de softwares e consultoria em TI",
    "duracao": "Prazo indeterminado",
    "capital_social": {
      "valor_total": "100000.00",
      "forma_integralizacao": "Dinheiro",
      "prazo_integralizacao": "Integralizado na constituição"
    }
  },
  "socios": [
    {
      "id": 1,
      "nome": "João Silva",
      "documento": "CPF: 111.222.333-44",
      "endereco": "Rua A, 123 - Paranavaí/PR",
      "profissao": "Engenheiro de Software",
      "percentual": "60%",
      "tipo": "Sócio administrador",
      "nacionalidade": "brasileiro",
      "estado_civil": "solteiro"
    },
    {
      "id": 2,
      "nome": "Maria Souza",
      "documento": "CPF: 555.666.777-88",
      "endereco": "Rua B, 456 - Maringá/PR",
      "profissao": "Advogada",
      "percentual": "40%",
      "tipo": "Sócia quotista",
      "nacionalidade": "brasileira",
      "estado_civil": "casada"
    }
  ],
  "administracao": {
    "id": 1,
    "socio_administrador": "João Silva",
    "tipoAdministracao": "Administrador único",
    "regras": "Decisões são tomadas pelo sócio administrador com poderes plenos."
  },
 "clausulas": [
    {
      "id": 1,
      "tipo": "Falecimento",
      "descricao":
          "Em caso de falecimento de sócio, suas quotas serão transmitidas aos herdeiros legais."
    },
    {
      "id": 2,
      "tipo": "Saída de Sócio",
      "descricao":
          "O sócio poderá se retirar da sociedade mediante aviso prévio de 60 dias."
    },
    {
      "id": 3,
      "tipo": "Dissolução",
      "descricao":
          "A sociedade poderá ser dissolvida por decisão unânime dos sócios."
    }
  ],
  "outros": {
    "foro": "Curitiba - PR",
    "assinatura": "João Silva / Maria Souza",
    "data": "01/09/2023"
  }
};
