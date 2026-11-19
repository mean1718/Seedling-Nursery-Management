
import '../model/customer.dart';
import '../model/customer_order.dart';
import '../model/growth_record.dart';
import '../model/order_detail.dart';
import '../model/payment.dart';
import '../model/production_batch.dart';
import '../model/seedling_type.dart';

// Manages the main business operation
class NurseryService {
  // Stores all nursery data
  final List<SeedlingType> seedlingTypes = [];
  final List<ProductionBatch> batches = [];
  final List<Customer> customers = [];
  final List<CustomerOrder> orders = [];

  // seedling tyoe operation

  // Adds a new seedling type
  void addSeedlingType(SeedlingType type) {
    if (findSeedlingTypeById(type.id) != null) {
      throw ArgumentError('Seedling type ID already exists.');
    }

    seedlingTypes.add(type);
  }

  // Finds a seedling type using its id
  SeedlingType? findSeedlingTypeById(String id) {
    for (final type in seedlingTypes) {
      if (type.id == id) {
        return type;
      }
    }

    return null;
  }

  // Prodution batch opeation

  // Adds a new production batch.
  void addBatch(ProductionBatch batch) {
    // Prevent duplicate batch IDs.
    if (findBatchById(batch.id) != null) {
      throw ArgumentError('Batch ID already exists.');
    }

    // Check whether the seedling type is registered
    final registeredType = findSeedlingTypeById(batch.seedlingType.id);

    if (registeredType == null ||!identical(registeredType, batch.seedlingType)) {
      throw ArgumentError('Seedling type does not exist in the nursery.');
    }

    // A production batch must contain at least one seedling
    if (batch.quantity <= 0) {
      throw ArgumentError('Batch quantity must be greater than zero.');
    }

    batches.add(batch);
  }

  // Finds a production batch using its id
  ProductionBatch? findBatchById(String id) {
    for (final batch in batches) {
      if (batch.id == id) {
        return batch;
      }
    }

    return null;
  }

  // Adds a growth record to an existing batch
  void addGrowthRecord(String batchId, GrowthRecord record) {
    final batch = findBatchById(batchId);

    if (batch == null) {
      throw ArgumentError('Production batch does not exist.');
    }

    // Do not add growth records to cancelled or completed batches.
    if (batch.status == BatchStatus.cancelled || batch.status == BatchStatus.completed) {
      throw StateError('Cannot add growth records to this batch.');
    }

    // Germinated seedlings cannot exceed the batch quantity
    if (record.germinated > batch.quantity) {
      throw ArgumentError('Germinated quantity exceeds batch quantity.');
    }

    // Growth records must be added in date order
    if (batch.growthRecords.isNotEmpty) {
      final lastRecord = batch.growthRecords.last;

      if (record.date.isBefore(lastRecord.date)) {
        throw ArgumentError(
          'Growth record date cannot be earlier than the previous record.',
        );
      }
    }

    batch.addGrowthRecord(record);
  }
  // Customer operation

  // Registers a new customer
  void addCustomer(Customer customer) {
    if (findCustomerById(customer.id) != null) {
      throw ArgumentError('Customer ID already exists.');
    }

    customers.add(customer);
  }

  // Finds a customer using their id
  Customer? findCustomerById(String id) {
    for (final customer in customers) {
      if (customer.id == id) {
        return customer;
      }
    }

    return null;
  }

  // customer order operation

  // Creates an order and reserves the requested seedlings.
  void addOrder(CustomerOrder order) {
    // Prevent duplicate order IDs.
    if (findOrderById(order.id) != null) {
      throw ArgumentError('Order ID already exists.');
    }

    // Check customer is registered
    final registeredCustomer = findCustomerById(order.customer.id);

    if (registeredCustomer == null ||
        !identical(registeredCustomer, order.customer)) {
      throw ArgumentError('Customer does not exist in the nursery.');
    }

    // An order must contain at least one item.
    if (order.details.isEmpty) {
      throw ArgumentError('Order must contain at least one item.');
    }

    // Store the total requested quantity for each batch
    final Map<String, int> requestedQuantities = {};

    // Validate every order detail before reserving stock
    for (final OrderDetail detail in order.details) {
      final batch = findBatchById(detail.batch.id);

      // Check batch exists
      if (batch == null || !identical(batch, detail.batch)) {
        throw ArgumentError('Production batch does not exist.');
      }

      // Only ready batches can be ordered
      if (batch.status != BatchStatus.ready) {
        throw StateError('Only ready batches can be ordered.');
      }

      // Check the requested quantity
      if (detail.quantity <= 0) {
        throw ArgumentError('Order quantity must be greater than zero.');
      }

      // Check the unit price
      if (detail.unitPrice < 0) {
        throw ArgumentError('Unit price cannot be negative.');
      }

      // Add the requested quantity to the batch total
      requestedQuantities[batch.id] = (requestedQuantities[batch.id] ?? 0) + detail.quantity;
    }

    // Check the total requested quantity against available stock
    for (final entry in requestedQuantities.entries) {
      final batch = findBatchById(entry.key);

      if (batch == null) {
        throw ArgumentError('Production batch does not exist.');
      }

      if (entry.value > batch.availableQuantity) {
        throw StateError(
          'Not enough seedlings available in batch ${batch.id}.',
        );
      }
    }

    // Reserve stock only after all items pass validation
    for (final entry in requestedQuantities.entries) {
      final batch = findBatchById(entry.key);

      if (batch != null) {
        batch.reserve(entry.value);
      }
    }

    // Save the order
    orders.add(order);
  }

  // Finds an order using its id
  CustomerOrder? findOrderById(String id) {
    for (final order in orders) {
      if (order.id == id) {
        return order;
      }
    }

    return null;
  }

  // payment operation

  // Adds a payment to an existing order
  void addPayment(String orderId, Payment payment) {
    final order = findOrderById(orderId);

    // Check whether the order exists
    if (order == null) {
      throw ArgumentError('Customer order does not exist.');
    }

    // Prevent the same payment id from being used twice
    for (final existingOrder in orders) {
      for (final existingPayment in existingOrder.payments) {
        if (existingPayment.id == payment.id) {
          throw ArgumentError('Payment ID already exists.');
        }
      }
    }

    // Add the payment to the order
    order.addPayment(payment);
  }
}
