# Projeto: Processamento de Contrato Social com API IA (Gemini)

---

## 1. Métodos principais planejados

- Envio do contrato social (preferencialmente por upload) para a API do Gemini.
- Resposta da IA em JSON (inicialmente usaremos dados mockados).
- Armazenamento e exibição das informações extraídas do contrato social (montar entidade).
- Dashboard simples para visualização dos dados processados.

---

## 2. Partes fáceis (primeiro passo)

- Definir o formato do JSON de resposta.
- Criar entidades.
- Criar um mock do retorno da API para testes iniciais.
- Criar a interface para envio do contrato social.

---

## 3. Há dependências?

- Sim.
- Dependência da API da IA estar disponível e configurada (não usaremos agora).
- O dashboard depende do JSON padronizado para funcionar corretamente.

---

## 4. Como separar?

A ideia é dividir o projeto em módulos independentes, que possam ser desenvolvidos em paralelo:

### Frontend
- Upload de arquivos (PDF).
- Dashboard de exibição dos dados.

### Backend
- Receber o PDF.
- Fazer a chamada à IA (quando pronta).
- Disponibilizar o JSON padronizado via endpoint de consulta.
- Mock inicial (JSON fixo).
- Evolução: integração com a API de IA (não usaremos agora).
- Padronização do JSON (contrato de dados).

### Infraestrutura e Integração
- Banco de dados para armazenar PDF + JSON.

---

## 5. Como mitigar partes difíceis e dependências entre colegas?

- Iniciar com um JSON mockado para não travar o desenvolvimento.
- Realizar reuniões curtas semanais para alinhar andamento.

---

## 6. Divisão de trabalho na equipe

| Pessoa  | Responsabilidades                                                  |
|---------|--------------------------------------------------------------------|
| Pessoa A – Frontend (Flutter) | Tela de upload de contrato social.<br>Dashboard com dados do contrato.<br>Listagem dos dados (dados enviados, recebidos e datas). |
| Pessoa B – Backend/API         | Implementar persistência (armazenar documentos e JSON).<br>Tratar erros (documento inválido, PDF corrompido).               |
| Pessoa C – Processamento (IA) | Criar JSON mockado inicial para testes.<br>Definir contrato de dados (formato fixo do JSON).<br>Depois: integrar API da IA para extrair informações do contrato. |

---

## 7. Dados a extrair do Contrato Social

### Empresa
- Nome empresarial (razão social).
- CNPJ.
- Endereço da sede.
- Objeto social (ramo/atividade da empresa).
- Duração da sociedade (limitada ou prazo indeterminado).
- Capital social (valor total e forma de integralização).

### Sócios
- Nome.
- Documento.
- Endereço.
- Profissão.
- Percentual.
- Tipo.

### Administração
- Sócio administrador.
- Regras de decisão.

### Cláusulas
- Falecimento.
- Entrada/saída de sócio.
- Dissolução.

### Outros
- Foro.
- Assinatura.
- Data.

---

## 8. Estrutura básica do contrato social (dados a modelar)

1. **Identificação da Empresa**

2. **Quadro de Sócios**  
   (Nome Completo, Nacionalidade, Estado Civil, Profissão, CPF, RG, Endereço, Percentual de Quotas)

3. **Capital Social**  
   (Valor Total (R$), Forma de Integralização (dinheiro, bens, serviços), Prazo de Integralização)

4. **Distribuição de Quotas**

5. **Administração da Empresa**

6. **Duração e Exercício Social**

7. **Regras Gerais**

---

**Fim do documento**
