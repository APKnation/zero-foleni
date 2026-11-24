import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// State status enum
enum StateStatus {
  initial,
  loading,
  success,
  error,
  empty,
  permissionDenied,
  sessionExpired,
  noSearchResults,
}

/// State model for UI states
class StateModel {
  final StateStatus status;
  final dynamic data;
  final String? message;
  final dynamic error;

  StateModel({
    this.status = StateStatus.initial,
    this.data,
    this.message,
    this.error,
  });

  factory StateModel.initial() => StateModel(status: StateStatus.initial);
  factory StateModel.loading() => StateModel(status: StateStatus.loading);
  factory StateModel.success(dynamic data) => StateModel(status: StateStatus.success, data: data);
  factory StateModel.empty() => StateModel(status: StateStatus.empty);
  factory StateModel.error(String message, [dynamic error]) => StateModel(status: StateStatus.error, message: message, error: error);
  factory StateModel.permissionDenied() => StateModel(status: StateStatus.permissionDenied);
  factory StateModel.sessionExpired() => StateModel(status: StateStatus.sessionExpired);
  factory StateModel.noSearchResults() => StateModel(status: StateStatus.noSearchResults);
  factory StateModel.formSuccess() => StateModel(status: StateStatus.success);
}

/// Reusable stateful widget that builds UI based on state
class StateWidget extends StatefulWidget {
  final StateModel initialState;
  final Function(StateModel) onStateChanged;
  final Widget Function(StateModel) builder;

  const StateWidget({
    required this.initialState,
    required this.onStateChanged,
    required this.builder,
    Key? key,
  }) : super(key: key);

  @override
  State<StateWidget> createState() => _StateWidgetState();
}

class _StateWidgetState extends State<StateWidget> {
  late StateModel _state;

  @override
  void initState() {
    super.initState();
    _state = widget.initialState;
    _loadState();
  }

  Future<void> _loadState() async {
    // TODO: Implement state loading logic
    // This would typically fetch data from API or shared prefs
    await Future.delayed(const Duration(seconds: 1));
    // For now, stay in initial state
  }

  void _updateState(StateModel newState) {
    setState(() {
      _state = newState;
      widget.onStateChanged(newState);
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(_state);
  }
}

/// Builds a loading indicator
Widget _buildLoading(BuildContext context) {
  return const Center(
    child: CircularProgressIndicator(),
  );
}

/// Builds an error widget
Widget _buildError(BuildContext context, String message, {String? actionText, VoidCallback? onAction}) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.error_outline, color: AppTheme.accent, size: 60),
        const SizedBox(height: 16),
        Text(
          message,
          style: const TextStyle(fontSize: 18, color: AppTheme.accent),
          textAlign: TextAlign.center,
        ),
        if (actionText != null) ...[
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onAction,
            child: Text(actionText),
          ),
        ],
      ],
    ),
  );
}

/// Builds empty state widget
Widget _buildEmpty(BuildContext context, {String? retryText, VoidCallback? onRetry}) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.remove, color: AppTheme.secondary, size: 60),
        const SizedBox(height: 16),
        const Text(
          'No data available',
          style: TextStyle(fontSize: 18, color: AppTheme.secondary),
          textAlign: TextAlign.center,
        ),
        if (retryText != null) ...[
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRetry,
            child: Text(retryText),
          ),
        ],
      ],
    ),
  );
}

/// Builds permission denied widget
Widget _buildPermissionDenied(BuildContext context) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.lock_outline, color: AppTheme.accent, size: 60),
        const SizedBox(height: 16),
        const Text(
          'Permission Denied',
          style: TextStyle(fontSize: 18, color: AppTheme.accent),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            // TODO: Handle permission request
          },
          child: const Text('Request Permission'),
        ),
      ],
    ),
  );
}

/// Builds session expired widget
Widget _buildSessionExpired(BuildContext context, {VoidCallback? onLoginAgain}) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.remove, color: AppTheme.accent, size: 60),
        const SizedBox(height: 16),
        const Text(
          'Session Expired',
          style: TextStyle(fontSize: 18, color: AppTheme.accent),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: onLoginAgain,
          child: const Text('Login Again'),
        ),
      ],
    ),
  );
}

/// Builds no search results widget
Widget _buildNoSearchResults(BuildContext context, {String? searchTerm, VoidCallback? doNewSearch}) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.search_off, color: AppTheme.secondary, size: 60),
        const SizedBox(height: 16),
        const Text(
          'No results found',
          style: TextStyle(fontSize: 18, color: AppTheme.secondary),
          textAlign: TextAlign.center,
        ),
        if (searchTerm != null) ...[
          const SizedBox(height: 16),
          Text('Searched for: "$searchTerm"'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: doNewSearch,
            child: const Text('Search Again'),
          ),
        ],
      ],
    ),
  );
}

/// Builds form validation success state
Widget _buildFormSuccess(BuildContext context, {String? successMessage, VoidCallback? onContinue}) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.check_circle, color: AppTheme.primary, size: 60),
        const SizedBox(height: 16),
        Text(
          onContinue != null ? 'Success!' : 'Form Submitted Successfully',
          style: const TextStyle(fontSize: 18, color: AppTheme.primary),
          textAlign: TextAlign.center,
        ),
        if (successMessage != null) ...[
          const SizedBox(height: 8),
          Text(successMessage),
        ],
        if (onContinue != null) ...[
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: onContinue,
            child: const Text('Continue'),
          ),
        ],
      ],
    ),
  );
}

