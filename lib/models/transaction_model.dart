import 'package:cloud_firestore/cloud_firestore.dart';

class Transaction {
  final String id;
  final double amount;
  final String type; 
  final String status; 
  final DateTime timestamp;

  Transaction({
    required this.id,
    required this.amount,
    required this.type,
    required this.status,
    required this.timestamp,
  });

  factory Transaction.fromMap(Map<String, dynamic> data, String id) {
    return Transaction(
      id: id,
      amount: data['amount']?.toDouble() ?? 0.0,
      type: data['type'] ?? 'unknown',
      status: data['status'] ?? 'pending',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }

  
  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'type': type,
      'status': status,
      'timestamp': timestamp,
    };
  }
}
