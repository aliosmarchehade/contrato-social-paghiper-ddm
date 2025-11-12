import 'package:flutter/material.dart';
import 'pagina_redefinir_senha.dart';

class PaginaVerificarCodigo extends StatefulWidget {
  final String email;
  final String codigoGerado;

  const PaginaVerificarCodigo({
    super.key,
    required this.email,
    required this.codigoGerado,
  });

  @override
  State<PaginaVerificarCodigo> createState() => _PaginaVerificarCodigoState();
}

class _PaginaVerificarCodigoState extends State<PaginaVerificarCodigo> {
  final _codigoController = TextEditingController();

  void _verificarCodigo() {
    if (_codigoController.text.trim() == widget.codigoGerado) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PaginaRedefinirSenha(email: widget.email),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Código incorreto!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verificação de Código"),
        backgroundColor: const Color(0xFF0860DB),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              "Digite o código enviado para ${widget.email}",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _codigoController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Código de verificação",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _verificarCodigo,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0860DB),
              ),
              child: const Text(
                "Verificar",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
