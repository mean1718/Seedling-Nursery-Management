import 'production_batch.dart';

class OrderDetail {
  final ProductionBatch batch;
  int quantity;
  double unitPrice;

  OrderDetail({
    required this.batch,
    required this.quantity,
    required this.unitPrice,
  }) {
    if (quantity <= 0) throw ArgumentError('Order quantity must be greater than zero.');
    if (unitPrice < 0) throw ArgumentError('Unit price cannot be negative.');
  }

  double get subtotal => quantity * unitPrice;
}
