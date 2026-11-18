import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HospitalListScreen extends StatelessWidget {
  const HospitalListScreen({super.key});
  static const hospitals = ['Muhimbili National Hospital', 'Aga Khan Hospital', 'Ocean Road Cancer Institute', 'Amana Regional Hospital'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hospitals')),
      body: ListView.builder(
        itemCount: hospitals.length,
        itemBuilder: (_, i) => ListTile(
          leading: const Icon(Icons.local_hospital),
          title: Text(hospitals[i]),
          subtitle: const Text('Dar es Salaam'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.go('/services/h$i'),
        ),
      ),
    );
  }
}
