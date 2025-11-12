import 'dart:convert';
import 'package:http/http.dart' as http;

class EmailHelper {
  static const _serviceId = ''; // 
  static const _templateId = ''; // 
  static const _publicKey = ''; // 

  static Future<bool> enviarCodigo(String emailDestino, String codigo) async {
    const url = 'https://api.emailjs.com/api/v1.0/email/send';

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'service_id': _serviceId,
        'template_id': _templateId,
        'user_id': _publicKey,
        'template_params': {
          'email': emailDestino,
          'to_name': emailDestino.split('@')[0],
          'codigo': codigo,
        }
      }),
    );

    if (response.statusCode == 200) {
      print('✅ Email enviado com sucesso!');
      return true;
    } else {
      print('❌ Erro ao enviar: ${response.body}');
      return false;
    }
  }
}
