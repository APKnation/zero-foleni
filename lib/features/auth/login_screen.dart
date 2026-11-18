import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/services/api_service.dart';
import '../../core/router/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});
  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
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

    // Build mutation string without problematic $() interpolation in multiline
    final phone = _phoneController.text;
    final password = _passwordController.text;
    final mutation = 'mutation { loginCitizen(phone: "$phone", password: "$password") { citizen { id fullName phone email nationalId } success message token } }';

    try {
      final res = await ApiService.query(mutation);
      
      final data = res['data']?['loginCitizen'] ?? {};
      final success = data['success'] as bool?;
      final message = data['message'] as String?;
      final token = data['token'] as String?;

      if (success == true && token != null) {
        ref.read(authProvider.notifier).login(phone, password);
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
    final auth = ref.watch(authProvider);
    return Scaffold(
      // Apply the new color scheme
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        title: const Text('Login'),
        leading: BackButton(onPressed: () => context.pop()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 40),
              // Use foleni.jpg as the app logo
              Image.asset(
                'images/foleni.jpg',
                width: 120,
                height: 120,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 24),
              const Text('Welcome Back', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1A2D42))),
              const SizedBox(height: 8),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone or Email',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary),
                  ),
                ),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary),
                  ),
                  obscureText: true,
                ),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 20),
              if (_errorMessage != null)
                Text(_errorMessage!, style: TextStyle(color: Colors.red[700])),
              const SizedBox(height: 12),
              _isLoading
                  ? const CircularProgressIndicator()
                  : FilledButton(
                    onPressed: _login,
                    child: const Text('Login'),
                  ),
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