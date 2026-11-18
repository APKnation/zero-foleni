import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UniversityListScreen extends StatelessWidget {
  const UniversityListScreen({super.key});
  static const unis = ['University of Dar es Salaam', 'Ardhi University', 'Mzumbe University', 'Sokoine University'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Universities')),
      body: ListView.builder(
        itemCount: unis.length,
        itemBuilder: (_, i) => ListTile(
          leading: const Icon(Icons.school),
          title: Text(unis[i]),
          subtitle: const Text('Tanzania'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.go('/uni-services/u$i'),
        ),
      ),
    );
  }
}
