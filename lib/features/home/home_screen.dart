import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ZeroFoleni'), leading: BackButton(onPressed: () => context.pop())),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('Choose a service category', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                children: [
                  _cat(context, 'Hospitals', Icons.local_hospital, '/hospitals'),
                  _cat(context, 'Universities', Icons.school, '/universities'),
                  _cat(context, 'Government', Icons.account_balance, '/government'),
                  _cat(context, 'Banks', Icons.account_balance_wallet, '/bank'),
                  _cat(context, 'History', Icons.history, '/history'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _cat(BuildContext c, String t, IconData i, String r) => Card(
    child: InkWell(
      onTap: () => c.go(r),
      child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(i, size: 48), Text(t)])),
    ),
  );
}