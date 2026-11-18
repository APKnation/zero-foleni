import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/services/api_service.dart';

class GovernmentListScreen extends StatefulWidget {
  const GovernmentListScreen({super.key});

  @override
  State<GovernmentListScreen> createState() => _GovernmentListScreenState();
}

class _GovernmentListScreenState extends State<GovernmentListScreen> {
  static const _fallbackOffices = [
    {'id': '1', 'name': 'NIDA – National Identification Authority', 'location': 'Kivukoni, Dar es Salaam'},
    {'id': '2', 'name': 'BRELA – Business Registrations Agency', 'location': 'Lumumba St, Dar es Salaam'},
    {'id': '3', 'name': 'TRA – Tanzania Revenue Authority', 'location': 'Samora Avenue, Dar es Salaam'},
    {'id': '4', 'name': 'RITA – Registration Agency', 'location': 'Simu St, Dar es Salaam'},
    {'id': '5', 'name': 'Immigration Department', 'location': 'Kivukoni Front, Dar es Salaam'},
    {'id': '6', 'name': 'Local Government Ward Office', 'location': 'Local District'},
  ];

  List<Map<String, dynamic>> _offices = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadOffices();
  }

  Future<void> _loadOffices() async {
    setState(() => _loading = true);
    final data = await ApiService.getInstitutions(type: 'government');
    if (mounted) {
      setState(() {
        _offices = data.isNotEmpty ? data : List.from(_fallbackOffices);
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              context.go('/home');
            }
          },
        ),
        title: const Text('Government (Ofisi za Serikali)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: _loading ? null : _loadOffices,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _offices.length,
              itemBuilder: (_, i) {
                final o = _offices[i];
                final id = o['id']?.toString() ?? '1';
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.teal.shade50,
                    child: const Icon(Icons.account_balance, color: Colors.teal),
                  ),
                  title: Text(o['name'] ?? ''),
                  subtitle: Text(o['location'] ?? 'Tanzania'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.go('/gov-services/$id'),
                );
              },
            ),
    );
  }
}
