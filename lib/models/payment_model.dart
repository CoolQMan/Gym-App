// lib/models/payment_model.dart
class Payment {
  final String id;
  final String userId;
  final double amount;
  final String description;
  final DateTime date;
  final String status; // 'Paid' or 'Due'

  Payment({
    required this.id,
    required this.userId,
    required this.amount,
    required this.description,
    required this.date,
    required this.status,
  });
}
