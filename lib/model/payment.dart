enum PaymentMethod { cash, bankTransfer, khqr, other }

class Payment {
  final String id;
  final double amount;
  final DateTime date;
  final PaymentMethod method;

  Payment({
    required this.id,
    required this.amount,
    required this.date,
    required this.method,
  }) {
    if (amount <= 0) throw ArgumentError('Payment amount must be greater than zero.');
  }
}
