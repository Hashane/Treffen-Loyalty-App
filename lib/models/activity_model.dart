import 'package:flutter/material.dart';

class ActivityModel {
  final String id;
  final String type;
  final int amount;
  final String store;
  final DateTime timestamp;
  final String? description;

  ActivityModel({
    required this.id,
    required this.type,
    required this.amount,
    required this.store,
    required this.timestamp,
    this.description,
  });

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
      id: json['id']?.toString() ?? '',
      type: json['type'] ?? 'earned',
      amount: json['amount'] ?? 0,
      store: json['store'] ?? '',
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'amount': amount,
      'store': store,
      'timestamp': timestamp.toIso8601String(),
      'description': description,
    };
  }

  bool get isEarned => type.toLowerCase() == 'earned';

  IconData get icon {
    switch (type.toLowerCase()) {
      case 'earned':
        return Icons.trending_up;
      case 'redeemed':
        return Icons.card_giftcard;
      case 'bonus':
        return Icons.stars;
      default:
        return Icons.circle;
    }
  }

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
