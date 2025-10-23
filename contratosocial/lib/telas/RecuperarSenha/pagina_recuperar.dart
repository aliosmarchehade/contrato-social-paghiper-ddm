import 'package:flutter/material.dart';
import '../../banco/database_helper_segundo_plano.dart';
import '../../models/usuario.dart';
import 'pagina_redefinir_senha.dart';


class PaginaRecuperar extends StatefulWidget {
  const PaginaRecuperar({super.key});

  @override
  State<PaginaRecuperar> createState() => _PaginaRecuperarState();
}

class _PaginaRecuperarState extends State<PaginaRecuperar> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  void _recuperarSenha() async {
  if (_formKey.currentState!.validate()) {
    final email = _emailController.text.trim();
    final usuario = await DatabaseHelper().buscarUsuarioPorEmail(email);

    if (usuario != null) {
      // Aqui poderia enviar um email real — por enquanto, só vou abrir a tela de redefinir
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaginaRedefinirSenha(email: email),
        ),
      );
    } else {
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
                      onPressed: _recuperarSenha,
                      icon: const Icon(Icons.refresh, color: Colors.white),
                      label: const Text(
                        "Recuperar",
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
