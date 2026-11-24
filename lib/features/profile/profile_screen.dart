import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/router/auth_provider.dart';
import '../../core/theme/app_theme.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);

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
        title: const Text('Citizen Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundColor: AppTheme.accent,
              child: Icon(Icons.person, size: 50, color: AppTheme.background),
            ),
            const SizedBox(height: 16),
            Text(
              auth.fullName ?? 'Mwananchi (Citizen)',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              auth.phone ?? 'Namba ya Simu: --',
              style: const TextStyle(color: AppTheme.secondary),
            ),
            const SizedBox(height: 24),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.verified_user, color: AppTheme.primary),
                    title: const Text('Hali ya Akaunti'),
                    subtitle: Text(auth.isLoggedIn ? 'Akaunti Imethibitishwa' : 'Hujaingia'),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.security, color: AppTheme.accent),
                    title: const Text('Usalama wa Data'),
                    subtitle: const Text('eGA Data Protection Compliant'),
                  ),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.logout, color: AppTheme.accent),
                label: const Text('Ondoka (Logout)', style: TextStyle(color: AppTheme.accent)),
                onPressed: () {
                  ref.read(authProvider.notifier).logout();
                  context.go('/login');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
