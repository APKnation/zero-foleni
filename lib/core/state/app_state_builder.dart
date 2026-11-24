import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Enum for different UI states
enum AppState { initial, loading, success, error, empty, permissionDenied, sessionExpired, noSearchResults }

/// Extension to build UI based on state
extension AppStateBuilder on AppState {
  Widget build(BuildContext context, {String? message, VoidCallback? onRetry, String? searchTerm, VoidCallback? onSearch, String? formMessage, VoidCallback? onContinue}) {
    switch (this) {
      case AppState.initial:
        return _initial();
      case AppState.loading:
        return _loading();
      case AppState.success:
        return _success(formMessage: formMessage, onContinue: onContinue);
      case AppState.error:
        return _error(message: message, onRetry: onRetry);
      case AppState.empty:
        return _empty(retryText: onRetry != null ? 'Retry' : null, onRetry: onRetry);
      case AppState.permissionDenied:
        return _permissionDenied();
      case AppState.sessionExpired:
        return _sessionExpired(onLoginAgain: onRetry);
      case AppState.noSearchResults:
        return _noSearchResults(searchTerm: searchTerm, doSearch: onSearch);
    }
  }

  Widget _initial() {
    return const Center(child: Text('Initial State'));
  }

  Widget _loading() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _error({String? message, VoidCallback? onRetry}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: AppTheme.accent, size: 60),
          const SizedBox(height: 16),
          Text(message ?? 'An error occurred', style: const TextStyle(fontSize: 18, color: AppTheme.accent)),
          const SizedBox(height: 24),
          ElevatedButton(onPressed: onRetry ?? () {}, child: const Text('Retry')),
        ],
      ),
    );
  }

  Widget _empty({String? retryText, VoidCallback? onRetry}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.remove, color: AppTheme.secondary, size: 60),
          const SizedBox(height: 16),
          const Text('No data available'),
          const SizedBox(height: 24),
          ElevatedButton(onPressed: onRetry ?? () {}, child: Text(retryText ?? 'Retry')),
        ],
      ),
    );
  }

  Widget _permissionDenied() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.lock_outline, color: AppTheme.accent, size: 60),
          const SizedBox(height: 16),
          const Text('Permission Denied'),
          const SizedBox(height: 24),
          ElevatedButton(onPressed: () {}, child: const Text('Request Permission')),
        ],
      ),
    );
  }

  Widget _sessionExpired({VoidCallback? onLoginAgain}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.remove, color: AppTheme.accent, size: 60),
          const SizedBox(height: 16),
          const Text('Session Expired'),
          const SizedBox(height: 24),
          ElevatedButton(onPressed: onLoginAgain ?? () {}, child: const Text('Login Again')),
        ],
      ),
    );
  }

  Widget _noSearchResults({required String? searchTerm, required VoidCallback? doSearch}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off, color: AppTheme.secondary, size: 60),
          const SizedBox(height: 16),
          const Text('No results found'),
          if (searchTerm != null) ...[
            const SizedBox(height: 8),
            Text('Searched for: "$searchTerm"'),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: doSearch, child: const Text('Search Again')),
          ],
        ],
      ),
    );
  }

  Widget _success({required String? formMessage, required VoidCallback? onContinue}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle, color: AppTheme.primary, size: 60),
          const SizedBox(height: 16),
          Text(formMessage ?? 'Success!', style: const TextStyle(fontSize: 18, color: AppTheme.primary)),
          const SizedBox(height: 24),
          if (onContinue != null) ...[
            ElevatedButton(onPressed: onContinue, child: const Text('Continue')),
          ],
        ],
      ),
    );
  }
}