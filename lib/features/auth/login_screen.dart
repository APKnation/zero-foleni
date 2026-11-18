import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/router/auth_provider.dart';
import '../../core/services/api_service.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;
  String? _errorMessage;

  Future<void> _handleLogin() async {
    final phone = _phoneController.text.trim();
    final password = _passwordController.text.trim();

    if (phone.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Tafadhali ingiza namba ya simu na nenosiri';
      });
      return;
    }

    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      final res = await ApiService.loginCitizen(phone: phone, password: password);
      if (mounted) {
        setState(() => _loading = false);

        if (res['success'] == true) {
          // Set Riverpod auth state so GoRouter allows navigation to /home
          ref.read(authProvider.notifier).login(phone, password);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(res['message'] ?? 'Umeingia kikamilifu!'),
              backgroundColor: Colors.green[700],
            ),
          );
          context.go('/home');
        } else {
          setState(() {
            _errorMessage = res['message'] ?? 'Kuingia kumeshindikana';
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
          _errorMessage = 'Hitilafu ya mtandao: $e';
        });
      }
    }
  }

  void _skipDemo() {
    ref.read(authProvider.notifier).login('demo', 'demo');
    context.go('/home');
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        leading: BackButton(onPressed: () => context.pop()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.lock_outline, size: 64, color: Colors.blueGrey),
            const SizedBox(height: 16),
            const Text(
              'Karibu ZeroFoleni',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Ingia ili kupata huduma bila kupanga foleni',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Namba ya Simu au Barua Pepe',
                hintText: 'Mfano: 0712345678',
                prefixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Nenosiri (Password)',
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(),
              ),
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade300),
                ),
                child: Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red[800], fontSize: 13),
                ),
              ),
            ],
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _loading ? null : _handleLogin,
              child: _loading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('Ingia (Login)'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => context.go('/register'),
              child: const Text('Fungua Akaunti Mpya (Register)'),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: _skipDemo,
              child: const Text('Ruka moja kwa moja (Skip / Demo)'),
            ),
          ],
        ),
      ),
    );
  }
}
