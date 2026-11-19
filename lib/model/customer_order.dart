import 'customer.dart';
import 'order_detail.dart';
import 'payment.dart';

enum PaymentStatus {
  unpaid,
  partiallyPaid,
  paid,
  overpaid,
}

class CustomerOrder {
  // Stores basic order of customer
  final String id;
  final Customer customer;
  final DateTime date;

  // Stores all items and payments
  final List<OrderDetail> details;
  final List<Payment> payments;

  // If details or payments are not provided, empty lists are created
  CustomerOrder({
    required this.id,
    required this.customer,
    required this.date,
    List<OrderDetail>? details,
    List<Payment>? payments,
  })  : details = List<OrderDetail>.from(details ?? []),
        payments = List<Payment>.from(payments ?? []);

  // The total price of all ordered items
  double get total {
    double sum = 0;

    for (final detail in details) {
      sum += detail.subtotal;
    }

    return sum;
  }

  // The total amount already paid
  double get paid {
    double sum = 0;

    for (final payment in payments) {
      sum += payment.amount;
    }

    return sum;
  }

  // Money that the customer still owes
  double get balance {
    return total - paid;
  }

  // store the current payment status
  PaymentStatus get paymentStatus {
    if (paid == 0) {
      return PaymentStatus.unpaid;
    } else if (paid < total) {
      return PaymentStatus.partiallyPaid;
    } else if (paid == total) {
      return PaymentStatus.paid;
    } else {
      return PaymentStatus.overpaid;
    }
  }

  // Adds a new item to the order
  void addDetail(OrderDetail detail) {
    details.add(detail);
  }

  // Adds a payment after checking that the amount is valid
  void addPayment(Payment payment) {
    if (payment.amount <= 0) {
      throw ArgumentError('Payment amount must be greater than zero.');
    }

    payments.add(payment);
  }
}
