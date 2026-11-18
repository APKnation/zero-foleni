import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final items = [
      ('Hospitals', Icons.local_hospital, '/hospitals'),
      ('My Queue', Icons.confirmation_number, '/tracking'),
      ('History', Icons.history, '/history'),
      ('Profile', Icons.person, '/profile'),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('ZeroFoleni')),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        children: items.map((e) => Card(
          child: InkWell(
            onTap: () => context.go(e.$3),
            child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(e.$2, size: 48), Text(e.$1)])),
          ),
        )).toList(),
      ),
    );
  }
}
