import 'dart:async';
import 'package:flutter/foundation.dart';

enum RequestStatus { submitted, waiting, approved, rejected }

class ServiceRequest {
  final String id;
  final String module; // university, government, bank, hospital
  final String serviceName;
  final String providerName;
  final String userName;
  final String details;
  RequestStatus status;
  String? ticketNumber;
  DateTime? scheduledTime;
  final DateTime createdAt;

  ServiceRequest({
    required this.id,
    required this.module,
    required this.serviceName,
    required this.providerName,
    required this.userName,
    required this.details,
    this.status = RequestStatus.submitted,
    this.ticketNumber,
    this.scheduledTime,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  String get statusLabel {
    switch (status) {
      case RequestStatus.submitted:
        return 'Submitted';
      case RequestStatus.waiting:
        return 'Waiting for approval';
      case RequestStatus.approved:
        return 'Approved';
      case RequestStatus.rejected:
        return 'Rejected';
    }
  }
}

class RequestStore extends ChangeNotifier {
  RequestStore._();
  static final RequestStore instance = RequestStore._();

  final List<ServiceRequest> _requests = [];
  List<ServiceRequest> get requests => List.unmodifiable(_requests);

  ServiceRequest submit({
    required String module,
    required String serviceName,
    required String providerName,
    required String userName,
    required String details,
  }) {
    final req = ServiceRequest(
      id: 'REQ-${DateTime.now().millisecondsSinceEpoch}',
      module: module,
      serviceName: serviceName,
      providerName: providerName,
      userName: userName,
      details: details,
      status: RequestStatus.submitted,
    );
    _requests.insert(0, req);
    notifyListeners();
    // Move to waiting after a short delay to reflect review stage.
    Timer(const Duration(seconds: 2), () {
      if (req.status == RequestStatus.submitted) {
        req.status = RequestStatus.waiting;
        notifyListeners();
      }
    });
    return req;
  }

  void approve(String id) {
    final req = _requests.firstWhere((r) => r.id == id, orElse: () => throw Exception('Request not found'));
    final approvedCount = _requests.where((r) => r.status == RequestStatus.approved).length;
    req.status = RequestStatus.approved;
    req.ticketNumber = 'TKT-${1000 + _requests.indexOf(req) + approvedCount + 1}';
    // Next available visitor slot: 5 minutes from now, staggered by approved count.
    req.scheduledTime = DateTime.now().add(Duration(minutes: 5 + approvedCount * 5));
    notifyListeners();
  }

  void reject(String id) {
    final req = _requests.firstWhere((r) => r.id == id, orElse: () => throw Exception('Request not found'));
    req.status = RequestStatus.rejected;
    notifyListeners();
  }

  ServiceRequest? find(String id) {
    try {
      return _requests.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }
}
