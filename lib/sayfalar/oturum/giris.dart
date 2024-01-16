import 'package:flutter/material.dart';
import 'package:dts/sayfalar/AnaSayfa.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _performLogin() {
    final username = _usernameController.text;
    final password = _passwordController.text;

    if (username.isNotEmpty && password.isNotEmpty) {
      // Burada kullanıcı kimlik doğrulaması başarılıysa bir sonraki sayfaya yönlendirme yapabilirsiniz.

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => AnaSayfa(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Giriş başarısız oldu. Lütfen bütün boşlukları doldurun.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'İsim'),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Şifre'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed:
                  _performLogin, // Call _performLogin when the button is pressed
              child: Text('Giriş Yap'),
            ),
          ],
        ),
      ),
    );
  }
}
