import 'package:flutter/material.dart';
import '../auth_service.dart';


class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => AuthService().signInWithGoogle(),
              child: const Text('Sign in with Google'),
            ),
          ],
        ),
      ),
    );
  }
}
