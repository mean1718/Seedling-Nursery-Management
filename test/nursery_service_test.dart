import 'package:flutter_test/flutter_test.dart';

import 'package:seedling_nursery_management/model/customer.dart';
import 'package:seedling_nursery_management/model/customer_order.dart';
import 'package:seedling_nursery_management/model/growth_record.dart';
import 'package:seedling_nursery_management/model/order_detail.dart';
import 'package:seedling_nursery_management/model/payment.dart';
import 'package:seedling_nursery_management/model/production_batch.dart';
import 'package:seedling_nursery_management/model/seedling_type.dart';
import 'package:seedling_nursery_management/service/nursery_service.dart';

void main() {
  // Seedling type test

  group('Seedling Type Tests', () {
    test('Add and find a seedling type', () {
      final service = NurseryService();

      final type = SeedlingType(
        id: 'S001',
        name: 'Tomato',
        growingDays: 30,
        price: 1000,
        minimumStock: 10,
      );

      service.addSeedlingType(type);

      expect(service.findSeedlingTypeById('S001'), equals(type));
    });

    test('Reject duplicate seedling type ID', () {
      final service = NurseryService();

      final type1 = SeedlingType(
        id: 'S001',
        name: 'Tomato',
        growingDays: 30,
        price: 1000,
        minimumStock: 10,
      );

      final type2 = SeedlingType(
        id: 'S001',
        name: 'Mango',
        growingDays: 60,
        price: 2000,
        minimumStock: 5,
      );

      service.addSeedlingType(type1);

      expect(
        () => service.addSeedlingType(type2),
        throwsArgumentError,
      );
    });
  });

  // Production batch test

  group('Production Batch Tests', () {
    test('Add and find a production batch', () {
      final service = NurseryService();

      final type = SeedlingType(
        id: 'S001',
        name: 'Tomato',
        growingDays: 30,
        price: 1000,
        minimumStock: 10,
      );

      service.addSeedlingType(type);

      final batch = ProductionBatch(
        id: 'B001',
        seedlingType: type,
        sowingDate: DateTime(2026, 1, 1),
        quantity: 100,
      );

      service.addBatch(batch);

      expect(service.findBatchById('B001'), equals(batch));
    });

    test('Reject batch with an unregistered seedling type', () {
      final service = NurseryService();

      final type = SeedlingType(
        id: 'S001',
        name: 'Tomato',
        growingDays: 30,
        price: 1000,
        minimumStock: 10,
      );

      final batch = ProductionBatch(
        id: 'B001',
        seedlingType: type,
        sowingDate: DateTime(2026, 1, 1),
        quantity: 100,
      );

      expect(
        () => service.addBatch(batch),
        throwsArgumentError,
      );
    });

    test('Reject batch with zero quantity', () {
      final service = NurseryService();

      final type = SeedlingType(
        id: 'S001',
        name: 'Tomato',
        growingDays: 30,
        price: 1000,
        minimumStock: 10,
      );

      service.addSeedlingType(type);

      final batch = ProductionBatch(
        id: 'B001',
        seedlingType: type,
        sowingDate: DateTime(2026, 1, 1),
        quantity: 0,
      );

      expect(
        () => service.addBatch(batch),
        throwsArgumentError,
      );
    });
  });

  // growth record test

  group('Growth Record Tests', () {
    test('Add a growth record to an existing batch', () {
      final service = NurseryService();

      final type = SeedlingType(
        id: 'S001',
        name: 'Tomato',
        growingDays: 30,
        price: 1000,
        minimumStock: 10,
      );

      service.addSeedlingType(type);

      final batch = ProductionBatch(
        id: 'B001',
        seedlingType: type,
        sowingDate: DateTime(2026, 1, 1),
        quantity: 100,
      );

      service.addBatch(batch);

      final record = GrowthRecord(
        date: DateTime(2026, 1, 10),
        germinated: 80,
        healthy: 70,
        damaged: 5,
      );

      service.addGrowthRecord('B001', record);

      expect(batch.growthRecords.length, 1);
      expect(batch.growthRecords.first, equals(record));
    });

    test('Reject growth record exceeding batch quantity', () {
      final service = NurseryService();

      final type = SeedlingType(
        id: 'S001',
        name: 'Tomato',
        growingDays: 30,
        price: 1000,
        minimumStock: 10,
      );

      service.addSeedlingType(type);

      final batch = ProductionBatch(
        id: 'B001',
        seedlingType: type,
        sowingDate: DateTime(2026, 1, 1),
        quantity: 100,
      );

      service.addBatch(batch);

      final record = GrowthRecord(
        date: DateTime(2026, 1, 10),
        germinated: 120,
        healthy: 100,
        damaged: 10,
      );

      expect(
        () => service.addGrowthRecord('B001', record),
        throwsArgumentError,
      );
    });

    test('Reject growth record for a cancelled batch', () {
      final service = NurseryService();

      final type = SeedlingType(
        id: 'S001',
        name: 'Tomato',
        growingDays: 30,
        price: 1000,
        minimumStock: 10,
      );

      service.addSeedlingType(type);

      final batch = ProductionBatch(
        id: 'B001',
        seedlingType: type,
        sowingDate: DateTime(2026, 1, 1),
        quantity: 100,
        status: BatchStatus.cancelled,
      );

      service.addBatch(batch);

      final record = GrowthRecord(
        date: DateTime(2026, 1, 10),
        germinated: 80,
        healthy: 70,
        damaged: 5,
      );

      expect(
        () => service.addGrowthRecord('B001', record),
        throwsStateError,
      );
    });
  });

  // Customer test

  group('Customer Tests', () {
    test('Add and find a customer', () {
      final service = NurseryService();

      final customer = Customer(
        id: 'C001',
        name: 'Dara',
        phone: '012345678',
        address: 'Phnom Penh',
      );

      service.addCustomer(customer);

      expect(service.findCustomerById('C001'), equals(customer));
    });

    test('Reject duplicate customer ID', () {
      final service = NurseryService();

      final customer1 = Customer(
        id: 'C001',
        name: 'Dara',
        phone: '012345678',
        address: 'Phnom Penh',
      );

      final customer2 = Customer(
        id: 'C001',
        name: 'Sokha',
        phone: '098765432',
        address: 'Kandal',
      );

      service.addCustomer(customer1);

      expect(
        () => service.addCustomer(customer2),
        throwsArgumentError,
      );
    });
  });

  // Customer order test

  group('Customer Order Tests', () {
    test('Create an order and reserve available seedlings', () {
      final service = NurseryService();

      final type = SeedlingType(
        id: 'S001',
        name: 'Tomato',
        growingDays: 30,
        price: 1000,
        minimumStock: 10,
      );

      service.addSeedlingType(type);

      final batch = ProductionBatch(
        id: 'B001',
        seedlingType: type,
        sowingDate: DateTime(2026, 1, 1),
        quantity: 100,
      );

      batch.approveAsReady(approvedQuantity: 100);
      service.addBatch(batch);

      final customer = Customer(
        id: 'C001',
        name: 'Dara',
        phone: '012345678',
        address: 'Phnom Penh',
      );

      service.addCustomer(customer);

      final order = CustomerOrder(
        id: 'O001',
        customer: customer,
        date: DateTime(2026, 2, 1),
        details: [
          OrderDetail(
            batch: batch,
            quantity: 20,
            unitPrice: 1000,
          ),
        ],
      );

      service.addOrder(order);

      expect(service.findOrderById('O001'), equals(order));
      expect(batch.availableQuantity, 80);
    });

    test('Reject order when requested quantity exceeds available stock', () {
      final service = NurseryService();

      final type = SeedlingType(
        id: 'S001',
        name: 'Tomato',
        growingDays: 30,
        price: 1000,
        minimumStock: 10,
      );

      service.addSeedlingType(type);

      final batch = ProductionBatch(
        id: 'B001',
        seedlingType: type,
        sowingDate: DateTime(2026, 1, 1),
        quantity: 100,
      );

      batch.approveAsReady(approvedQuantity: 10);
      service.addBatch(batch);

      final customer = Customer(
        id: 'C001',
        name: 'Dara',
        phone: '012345678',
        address: 'Phnom Penh',
      );

      service.addCustomer(customer);

      final order = CustomerOrder(
        id: 'O001',
        customer: customer,
        date: DateTime(2026, 2, 1),
        details: [
          OrderDetail(
            batch: batch,
            quantity: 20,
            unitPrice: 1000,
          ),
        ],
      );

      expect(
        () => service.addOrder(order),
        throwsStateError,
      );

      // Stock should remain unchanged after a failed order
      expect(batch.availableQuantity, 10);
      expect(service.orders.isEmpty, true);
    });

    test('Reject an order from a batch that is not ready', () {
      final service = NurseryService();

      final type = SeedlingType(
        id: 'S001',
        name: 'Tomato',
        growingDays: 30,
        price: 1000,
        minimumStock: 10,
      );

      service.addSeedlingType(type);

      final batch = ProductionBatch(
        id: 'B001',
        seedlingType: type,
        sowingDate: DateTime(2026, 1, 1),
        quantity: 100,
      );

      service.addBatch(batch);

      final customer = Customer(
        id: 'C001',
        name: 'Dara',
        phone: '012345678',
        address: 'Phnom Penh',
      );

      service.addCustomer(customer);

      final order = CustomerOrder(
        id: 'O001',
        customer: customer,
        date: DateTime(2026, 2, 1),
        details: [
          OrderDetail(
            batch: batch,
            quantity: 10,
            unitPrice: 1000,
          ),
        ],
      );

      expect(
        () => service.addOrder(order),
        throwsStateError,
      );
    });
  });

  // payment test

  group('Payment Tests', () {
    test('Add a payment to an existing order', () {
      final service = NurseryService();

      final customer = Customer(
        id: 'C001',
        name: 'Dara',
        phone: '012345678',
        address: 'Phnom Penh',
      );

      service.addCustomer(customer);

      final type = SeedlingType(
        id: 'S001',
        name: 'Tomato',
        growingDays: 30,
        price: 1000,
        minimumStock: 10,
      );

      service.addSeedlingType(type);

      final batch = ProductionBatch(
        id: 'B001',
        seedlingType: type,
        sowingDate: DateTime(2026, 1, 1),
        quantity: 100,
      );

      batch.approveAsReady(approvedQuantity: 100);
      service.addBatch(batch);

      final order = CustomerOrder(
        id: 'O001',
        customer: customer,
        date: DateTime(2026, 2, 1),
        details: [
          OrderDetail(
            batch: batch,
            quantity: 10,
            unitPrice: 1000,
          ),
        ],
      );

      service.addOrder(order);

      final payment = Payment(
        id: 'P001',
        amount: 5000,
        date: DateTime(2026, 2, 2),
        method: PaymentMethod.cash,
      );

      service.addPayment('O001', payment);

      expect(order.payments.length, 1);
      expect(order.paid, 5000);
      expect(order.paymentStatus, PaymentStatus.partiallyPaid);
    });

    test('Reject payment for a non-existing order', () {
      final service = NurseryService();

      final payment = Payment(
        id: 'P001',
        amount: 5000,
        date: DateTime(2026, 2, 2),
        method: PaymentMethod.cash,
      );

      expect(
        () => service.addPayment('O999', payment),
        throwsArgumentError,
      );
    });
  });
}
