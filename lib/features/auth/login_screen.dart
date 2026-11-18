import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: const BackButton(), title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const TextField(decoration: InputDecoration(labelText: 'Phone or Email')),
            const SizedBox(height: 12),
            const TextField(decoration: InputDecoration(labelText: 'Password'), obscureText: true),
            const SizedBox(height: 24),
            FilledButton(onPressed: () => context.go('/home'), child: const Text('Login')),
            TextButton(onPressed: () => context.go('/home'), child: const Text('Skip (demo)')),
          ],
        ),
      ),
    );
  }
}
