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
    return Scaffold(
      // Apply the new color scheme
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        title: const Text('Citizen Registration'),
        leading: BackButton(onPressed: () => context.pop()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 20),
              // Use foleni.jpg as the logo
              Image.asset(
                'images/foleni.jpg',
                width: 120,
                height: 120,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 20),
              const Text('Create Account', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1A2D42))),
              const SizedBox(height: 20),
              TextFormField(controller: _nameController, decoration: InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary),
                ),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              )),
              const SizedBox(height: 12),
              TextFormField(controller: _phoneController, decoration: InputDecoration(
                labelText: 'Phone',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary),
                ),
                keyboardType: TextInputType.phone,
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              )),
              const SizedBox(height: 12),
              TextFormField(controller: _emailController, decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary),
                ),
                keyboardType: TextInputType.emailAddress,
              )),
              const SizedBox(height: 12),
              TextFormField(controller: _nidController, decoration: InputDecoration(
                labelText: 'National ID',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary),
                ),
              )),
              const SizedBox(height: 12),
              TextFormField(controller: _passController, decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary),
                ),
                obscureText: true,
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              )),
              const SizedBox(height: 20),
              if (_errorMessage != null)
                Text(_errorMessage!, style: TextStyle(color: Colors.red[700])),
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