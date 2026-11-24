import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/services/request_store.dart';
import '../../../core/theme/app_theme.dart';

class GovernmentRequestScreen extends StatefulWidget {
  final String govId;
  final String serviceId;
  final String providerId;
  const GovernmentRequestScreen({super.key, required this.govId, required this.serviceId, required this.providerId});

  @override
  State<GovernmentRequestScreen> createState() => _GovernmentRequestScreenState();
}

class _GovernmentRequestScreenState extends State<GovernmentRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _idController = TextEditingController();
  final _detailsController = TextEditingController();
  bool _isLoading = false;

  static const services = ['NIDA ID Application', 'Business Registration', 'Tax Filing', 'Birth Registration', 'Passport Application', 'Land Title Transfer'];

  String _serviceName(String id) {
    final idx = int.tryParse(id.replaceFirst('s', '')) ?? 0;
    if (idx >= 0 && idx < services.length) return services[idx];
    return 'Government Service';
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    final req = RequestStore.instance.submit(
      module: 'government',
      serviceName: _serviceName(widget.serviceId),
      providerName: 'Service Desk ${widget.providerId}',
      userName: _nameController.text.trim(),
      details: _detailsController.text.trim(),
    );
    if (mounted) {
      setState(() => _isLoading = false);
      context.go('/request-status/${req.id}');
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _idController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.go('/gov-providers/${widget.govId}/${widget.serviceId}')),
        title: const Text('Service Request Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Full Name'),
                validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _idController,
                decoration: const InputDecoration(labelText: 'National ID Number'),
                validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _detailsController,
                decoration: const InputDecoration(labelText: 'Request Details'),
                maxLines: 4,
                validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _isLoading ? null : _submit,
                  child: _isLoading
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.background))
                      : const Text('Submit Request'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
