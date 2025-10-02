import 'package:contratosocial/telas/dashboard/dashboard_page.dart';
import 'package:flutter/material.dart';
import 'pagina_cadastro.dart';
import '../models/Usuario.dart';
import '../banco/database_helper.dart';

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
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardPage()),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      "Login",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 99, 16, 110),
                      ),
                    ),
                    const SizedBox(height: 28),
                    TextFormField(
                      controller: _usuarioController,
                      decoration: const InputDecoration(
                        labelText: "Usuário",
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 14,
                        ),
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
                      decoration: const InputDecoration(
                        labelText: "Senha",
                        prefixIcon: Icon(Icons.lock),
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 14,
                        ),
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
                      icon: const Icon(Icons.login),
                      label: const Text(
                        "Entrar",
                        style: TextStyle(fontSize: 18),
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(52),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _irParaCadastro,
                      icon: const Icon(Icons.person_add),
                      label: const Text(
                        "Cadastrar",
                        style: TextStyle(fontSize: 18),
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(52),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
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
