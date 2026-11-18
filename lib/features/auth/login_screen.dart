import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/router/auth_provider.dart';
import '../../core/services/api_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Call GraphQL login mutation via ApiService
      final res = await ApiService.query('''
        mutation { 
          loginCitizen(phone: "$(_phoneController.text)", password: "$(_passwordController.text)") {
            citizen { id fullName phone email nationalId }
            success message
            token
          }
        }
      ''');
      
      final data = res['data']?['loginCitizen'] ?? {};
      final success = data['success'] as bool?;
      final message = data['message'] as String?;
      final token = data['token'] as String?;

      if (success == true && token != null) {
        // Store auth in Riverpod + Secure Storage
        ref.read(authProvider.notifier).login(
          _phoneController.text, 
          _passwordController.text,
        );
        // Also store token securely
        final storage = const FlutterSecureStorage();
        await storage.write(key: 'auth_token', value: token);
        
        if (context.mounted) {
          context.go('/home');
        }
      } else {
        setState(() {
          _errorMessage = message ?? 'Login failed';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Connection error: $e';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = watch(authProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Login'), leading: BackButton(onPressed: () => context.pop())),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text('Welcome Back', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone or Email'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 20),
              if (_errorMessage != null)
                Text(_errorMessage!, style: TextStyle(color: Colors.red[700])),
              const SizedBox(height: 12),
              _isLoading
                  ? const CircularProgressIndicator()
                  : FilledButton(onPressed: _login, child: const Text('Login')),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => context.go('/register'),
                child: const Text('Create new account'),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => context.go('/home'),
                child: const Text('Skip (demo)'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}