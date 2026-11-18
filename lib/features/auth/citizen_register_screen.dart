import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/services/api_service.dart';

class CitizenRegisterScreen extends StatefulWidget {
  const CitizenRegisterScreen({super.key});
  @override
  State<CitizenRegisterScreen> createState() => _CitizenRegisterScreenState();
}

class _CitizenRegisterScreenState extends State<CitizenRegisterScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _nid = TextEditingController();
  final _pass = TextEditingController();
  bool _loading = false;
  String? _msg;

  Future<void> _register() async {
    if (!_form.currentState!.validate()) return;
    setState(() { _loading = true; _msg = null; });
    final res = await ApiService.registerCitizen(
      fullName: _name.text, phone: _phone.text, password: _pass.text,
      email: _email.text, nationalId: _nid.text,
    );
    final data = res['data']?['registerCitizen'] ?? {};
    setState(() { _loading = false; _msg = data['message'] ?? ''; });
    if (data['success'] == true) {
      Future.delayed(const Duration(seconds: 1), () => context.go('/login'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Citizen Registration'), leading: BackButton(onPressed: () => context.pop())),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              const Text('Create Account', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              TextFormField(controller: _name, decoration: const InputDecoration(labelText: 'Full Name'), validator: (v) => v == null || v.isEmpty ? 'Required' : null),
              const SizedBox(height: 12),
              TextFormField(controller: _phone, decoration: const InputDecoration(labelText: 'Phone'), keyboardType: TextInputType.phone, validator: (v) => v == null || v.isEmpty ? 'Required' : null),
              const SizedBox(height: 12),
              TextFormField(controller: _email, decoration: const InputDecoration(labelText: 'Email'), keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 12),
              TextFormField(controller: _nid, decoration: const InputDecoration(labelText: 'National ID')),
              const SizedBox(height: 12),
              TextFormField(controller: _pass, decoration: const InputDecoration(labelText: 'Password'), obscureText: true, validator: (v) => v == null || v.isEmpty ? 'Required' : null),
              const SizedBox(height: 20),
              if (_msg != null) Text(_msg!, style: TextStyle(color: Colors.red[700], fontSize: 14)),
              const SizedBox(height: 12),
              FilledButton(onPressed: _loading ? null : _register, child: _loading ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Register')),
              const SizedBox(height: 12),
              TextButton(onPressed: () => context.go('/login'), child: const Text('Already have an account? Login')),
            ],
          ),
        ),
      ),
    );
  }
}
