import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/services/api_service.dart';
import '../../core/router/auth_provider.dart';

class CitizenRegisterScreen extends ConsumerStatefulWidget {
  const CitizenRegisterScreen({super.key});
  @override
  _CitizenRegisterState createState() => _CitizenRegisterState();
}

class _CitizenRegisterState extends ConsumerState<CitizenRegisterScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _nidController = TextEditingController();
  final _passController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Build mutation string properly
    final fullName = _nameController.text;
    final phone = _phoneController.text;
    final password = _passController.text;
    final mutation = 'mutation { registerCitizen(fullName: "$fullName", phone: "$phone", password: "$password") { citizen { id fullName phone email nationalId } success message } }';

    try {
      final res = await ApiService.query(mutation);
      
      final data = res['data']?['registerCitizen'] ?? {};
      final success = data['success'] as bool?;
      final message = data['message'] as String?;

      if (success == true) {
        // Login automatically after registration
        ref.read(authProvider.notifier).login(phone, password);
        if (context.mounted) {
          context.go('/login');
        }
      } else {
        setState(() {
          _errorMessage = message ?? 'Registration failed';
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
      appBar: AppBar(title: const Text('Citizen Registration'), leading: BackButton(onPressed: () => context.pop())),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text('Create Account', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              TextFormField(controller: _nameController, decoration: const InputDecoration(labelText: 'Full Name'), validator: (v) => v == null || v.isEmpty ? 'Required' : null),
              const SizedBox(height: 12),
              TextFormField(controller: _phoneController, decoration: const InputDecoration(labelText: 'Phone'), keyboardType: TextInputType.phone, validator: (v) => v == null || v.isEmpty ? 'Required' : null),
              const SizedBox(height: 12),
              TextFormField(controller: _emailController, decoration: const InputDecoration(labelText: 'Email'), keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 12),
              TextFormField(controller: _nidController, decoration: const InputDecoration(labelText: 'National ID')),
              const SizedBox(height: 12),
              TextFormField(controller: _passController, decoration: const InputDecoration(labelText: 'Password'), obscureText: true, validator: (v) => v == null || v.isEmpty ? 'Required' : null),
              const SizedBox(height: 20),
              if (_errorMessage != null) Text(_errorMessage!, style: TextStyle(color: Colors.red[700], fontSize: 14)),
              const SizedBox(height: 12),
              _isLoading ? const CircularProgressIndicator() : FilledButton(onPressed: _register, child: const Text('Register')),
              const SizedBox(height: 12),
              TextButton(onPressed: () => context.go('/login'), child: const Text('Already have an account? Login')),
            ],
          ),
        ),
      ),
    );
  }
}