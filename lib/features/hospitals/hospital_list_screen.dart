import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/services/api_service.dart';

class HospitalListScreen extends StatefulWidget {
  const HospitalListScreen({super.key});

  @override
  State<HospitalListScreen> createState() => _HospitalListScreenState();
}

class _HospitalListScreenState extends State<HospitalListScreen> {
  static const _fallbackHospitals = [
    {'id': '1', 'name': 'Muhimbili National Hospital', 'location': 'Kalenga St, Upanga, Dar es Salaam'},
    {'id': '2', 'name': 'Aga Khan Hospital', 'location': 'Ocean Road, Dar es Salaam'},
    {'id': '3', 'name': 'Ocean Road Cancer Institute', 'location': 'Barack Obama Drive, Dar es Salaam'},
    {'id': '4', 'name': 'Amana Regional Hospital', 'location': 'Ilala, Dar es Salaam'},
  ];

  List<Map<String, dynamic>> _hospitals = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadHospitals();
  }

  Future<void> _loadHospitals() async {
    setState(() => _loading = true);
    final data = await ApiService.getInstitutions(type: 'hospital');
    if (mounted) {
      setState(() {
        _hospitals = data.isNotEmpty ? data : List.from(_fallbackHospitals);
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hospitals (Hospitali)'),
        leading: BackButton(
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              context.go('/home');
            }
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: _loading ? null : _loadHospitals,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _hospitals.length,
              itemBuilder: (_, i) {
                final h = _hospitals[i];
                final id = h['id']?.toString() ?? '1';
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.red.shade50,
                    child: const Icon(Icons.local_hospital, color: Colors.red),
                  ),
                  title: Text(h['name'] ?? ''),
                  subtitle: Text(h['location'] ?? 'Dar es Salaam'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.go('/services/$id'),
                );
              },
            ),
    );
  }
}
