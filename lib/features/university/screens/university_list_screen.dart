import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/services/api_service.dart';

class UniversityListScreen extends StatefulWidget {
  const UniversityListScreen({super.key});

  @override
  State<UniversityListScreen> createState() => _UniversityListScreenState();
}

class _UniversityListScreenState extends State<UniversityListScreen> {
  static const _fallbackUnis = [
    {'id': '1', 'name': 'University of Dar es Salaam (UDSM)', 'location': 'Mlimani Campus'},
    {'id': '2', 'name': 'Ardhi University (ARU)', 'location': 'Observation Hill, Dar es Salaam'},
    {'id': '3', 'name': 'Mzumbe University', 'location': 'Morogoro Campus'},
    {'id': '4', 'name': 'Sokoine University of Agriculture (SUA)', 'location': 'Morogoro'},
  ];

  List<Map<String, dynamic>> _unis = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadUniversities();
  }

  Future<void> _loadUniversities() async {
    setState(() => _loading = true);
    final data = await ApiService.getInstitutions(type: 'university');
    if (mounted) {
      setState(() {
        _unis = data.isNotEmpty ? data : List.from(_fallbackUnis);
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
        title: const Text('Universities (Vyuo Vikuu)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: _loading ? null : _loadUniversities,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _unis.length,
              itemBuilder: (_, i) {
                final u = _unis[i];
                final id = u['id']?.toString() ?? '1';
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.shade50,
                    child: const Icon(Icons.school, color: Colors.blue),
                  ),
                  title: Text(u['name'] ?? ''),
                  subtitle: Text(u['location'] ?? 'Tanzania'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.go('/uni-services/$id'),
                );
              },
            ),
    );
  }
}
