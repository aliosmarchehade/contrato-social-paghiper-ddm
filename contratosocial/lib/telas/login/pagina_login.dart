import 'package:contratosocial/telas/lerContrato/ler_contrato.dart';
import 'package:contratosocial/telas/dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import '../cadastro/pagina_cadastro.dart';
import '../RecuperarSenha/pagina_recuperar.dart';
import '../../models/usuario.dart';
import '../../banco/database_helper_segundo_plano.dart';
import 'package:contratosocial/configuracao/rotas.dart';

class PaginaLogin extends StatefulWidget {
  const PaginaLogin({super.key});

  @override
  State<PaginaLogin> createState() => _LoginPageState();
}

class _LoginPageState extends State<PaginaLogin> {
  final _formKey = GlobalKey<FormState>();
  final _usuarioController = TextEditingController();
  final _senhaController = TextEditingController();

  void _fazerLogin() async {
    if (_formKey.currentState!.validate()) {
      final nome = _usuarioController.text.trim();
      final senha = _senhaController.text.trim();

      final usuario = await DatabaseHelper().autenticarUsuario(nome, senha);

      if (usuario != null) {
        Navigator.pushReplacementNamed(
          context,
          Rotas.dashboard,
          arguments: usuario,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Usuário ou senha inválidos!")),
        );
      }
    }
  }

  void _irParaCadastro() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PaginaCadastro()),
    );
  }

  void _irParaRecuperarSenha() {
  Navigator.push(
    context, 
    MaterialPageRoute(builder: (context) => const PaginaRecuperar()),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Card(
            color: Colors.white,
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
                      "Login",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0860DB),
                      ),
                    ),
                    const SizedBox(height: 28),
                    TextFormField(
                      controller: _usuarioController,
                      decoration: InputDecoration(
                        labelText: "Usuário",
                        prefixIcon: const Icon(Icons.person),
                        border: const OutlineInputBorder(),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFF0860DB),
                            width: 2.0,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 14,
                        ),
                        labelStyle: const TextStyle(color: Colors.grey),
                      ),
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? "Digite o usuário"
                                  : null,
                    ),
                    const SizedBox(height: 18),
                    TextFormField(
                      controller: _senhaController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Senha",
                        prefixIcon: const Icon(Icons.lock),
                        border: const OutlineInputBorder(),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFF0860DB),
                            width: 2.0,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 14,
                        ),
                        labelStyle: const TextStyle(color: Colors.grey),
                      ),
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? "Digite a senha"
                                  : null,
                    ),
                    const SizedBox(height: 22),
                    ElevatedButton.icon(
                      onPressed: _fazerLogin,
                      icon: const Icon(Icons.login, color: Colors.white),
                      label: const Text(
                        "Entrar",
                        style: TextStyle(fontSize: 18, color: Colors.white),
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
                    ElevatedButton.icon(
                      onPressed: _irParaCadastro,
                      icon: const Icon(Icons.person_add, color: Colors.white),
                      label: const Text(
                        "Cadastrar",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0860DB),
                        minimumSize: const Size.fromHeight(52),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        ),
                      ),
                    TextButton(
                      onPressed: _irParaRecuperarSenha,
                      child: const Text(
                        "Esqueci minha senha",
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
