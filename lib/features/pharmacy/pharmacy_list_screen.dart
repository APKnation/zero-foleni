import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';

class PharmacyListScreen extends StatefulWidget {
  const PharmacyListScreen({super.key});

  @override
  State<PharmacyListScreen> createState() => _PharmacyListScreenState();
}

class _PharmacyListScreenState extends State<PharmacyListScreen> {
  static const _locations = ['All Locations', 'Dar es Salaam', 'Arusha', 'Dodoma', 'Mwanza'];
  static const _pharmacies = [
    {'id': 'p1', 'name': 'City Pharmacy', 'location': 'Dar es Salaam', 'services': 'Prescription, Consultation'},
    {'id': 'p2', 'name': 'HealthPlus Pharmacy', 'location': 'Dar es Salaam', 'services': 'Prescription, Lab Tests'},
    {'id': 'p3', 'name': 'MediCare Pharmacy', 'location': 'Arusha', 'services': 'Prescription, Vaccination'},
    {'id': 'p4', 'name': 'Wellness Pharmacy', 'location': 'Dodoma', 'services': 'Prescription, Consultation'},
    {'id': 'p5', 'name': 'Lake Zone Pharmacy', 'location': 'Mwanza', 'services': 'Prescription, Delivery'},
  ];

  String _selectedLocation = 'All Locations';
  String _query = '';

  List<Map<String, String>> get _filtered {
    return _pharmacies.where((p) {
      final matchesLocation = _selectedLocation == 'All Locations' || p['location'] == _selectedLocation;
      final matchesQuery = _query.isEmpty || (p['name'] ?? '').toLowerCase().contains(_query.toLowerCase());
      return matchesLocation && matchesQuery;
    }).cast<Map<String, String>>().toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.go('/home')),
        title: const Text('Pharmacies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Location selector
            DropdownButtonFormField<String>(
              value: _selectedLocation,
              decoration: const InputDecoration(
                labelText: 'Select Location',
                prefixIcon: Icon(Icons.location_on),
                border: OutlineInputBorder(),
              ),
              items: _locations
                  .map((l) => DropdownMenuItem(value: l, child: Text(l)))
                  .toList(),
              onChanged: (v) => setState(() => _selectedLocation = v ?? 'All Locations'),
            ),
            const SizedBox(height: 12),
            // Search
            TextField(
              decoration: const InputDecoration(
                hintText: 'Search pharmacy',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
            const SizedBox(height: 16),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Available Pharmacies', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _filtered.isEmpty
                  ? const Center(child: Text('No pharmacies found for this location'))
                  : ListView.builder(
                      itemCount: _filtered.length,
                      itemBuilder: (_, i) {
                        final p = _filtered[i];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            leading: const CircleAvatar(
                              backgroundColor: AppTheme.primary,
                              child: Icon(Icons.local_pharmacy, color: AppTheme.background),
                            ),
                            title: Text(p['name'] ?? ''),
                            subtitle: Text('${p['location']} • ${p['services']}'),
                            trailing: const Icon(Icons.chevron_right, color: AppTheme.primary),
                            onTap: () => context.go('/booking/${p['id']}/pharmacy'),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
