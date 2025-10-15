import 'package:flutter/material.dart';
import '../../banco/database_helper_segundo_plano.dart';

class PaginaRedefinirSenha extends StatefulWidget {
  final String email;

  const PaginaRedefinirSenha({super.key, required this.email});

  @override
  State<PaginaRedefinirSenha> createState() => _PaginaRedefinirSenhaState();
}

class _PaginaRedefinirSenhaState extends State<PaginaRedefinirSenha> {
  final _formKey = GlobalKey<FormState>();
  final _novaSenhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();

  void _atualizarSenha() async {
    if (_formKey.currentState!.validate()) {
      if (_novaSenhaController.text != _confirmarSenhaController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("As senhas não coincidem!")),
        );
        return;
      }

      final novaSenha = _novaSenhaController.text.trim();
      await DatabaseHelper().atualizarSenha(widget.email, novaSenha);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Senha redefinida com sucesso!")),
      );

      Navigator.popUntil(context, (route) => route.isFirst); // volta para login
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Redefinir Senha"),
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
                      "Redefinir Senha",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0860DB),
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _novaSenhaController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: "Nova Senha",
                        prefixIcon: Icon(Icons.lock),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value == null || value.isEmpty
                              ? "Digite a nova senha"
                              : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _confirmarSenhaController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: "Confirmar Senha",
                        prefixIcon: Icon(Icons.lock_outline),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value == null || value.isEmpty
                              ? "Confirme a nova senha"
                              : null,
                    ),
                    const SizedBox(height: 22),
                    ElevatedButton.icon(
                      onPressed: _atualizarSenha,
                      icon: const Icon(Icons.check, color: Colors.white),
                      label: const Text(
                        "Salvar nova senha",
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
