import 'dart:math';
import 'package:flutter/material.dart';
import '../../banco/database_helper_segundo_plano.dart';
import '../../util/email_helper.dart'; // novo helper para envio de e-mails
import 'pagina_verificar_codigo.dart'; // nova tela de verificação de código

class PaginaRecuperar extends StatefulWidget {
  const PaginaRecuperar({super.key});

  @override
  State<PaginaRecuperar> createState() => _PaginaRecuperarState();
}

class _PaginaRecuperarState extends State<PaginaRecuperar> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  bool _enviando = false; // mostra carregamento

  void _recuperarSenha() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _enviando = true);

      final email = _emailController.text.trim();
      final usuario = await DatabaseHelper().buscarUsuarioPorEmail(email);

      if (usuario != null) {
        // Gera código de 6 dígitos aleatório
        final codigo = (100000 + Random().nextInt(899999)).toString();

        // Envia o e-mail com o código
        final enviado = await EmailHelper.enviarCodigo(email, codigo);

        setState(() => _enviando = false);

        if (enviado) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Código enviado para o e-mail informado!"),
            ),
          );

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PaginaVerificarCodigo(
                email: email,
                codigoGerado: codigo,
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Erro ao enviar o e-mail.")),
          );
        }
      } else {
        setState(() => _enviando = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Email não encontrado!")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Recuperar Senha"),
        backgroundColor: const Color(0xFF0860DB),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      "Recuperar Senha",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0860DB),
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: "Email cadastrado",
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Digite seu email";
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return "Digite um email válido";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 22),
                    ElevatedButton.icon(
                      onPressed: _enviando ? null : _recuperarSenha,
                      icon: _enviando
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(Icons.refresh, color: Colors.white),
                      label: Text(
                        _enviando ? "Enviando..." : "Enviar código",
                        style: const TextStyle(
                            fontSize: 18, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0860DB),
                        minimumSize: const Size.fromHeight(52),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        "Voltar para Login",
                        style: TextStyle(
                          color: Color(0xFF0860DB),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
