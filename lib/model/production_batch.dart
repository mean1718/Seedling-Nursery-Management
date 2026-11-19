import 'growth_record.dart';
import 'seedling_type.dart';

enum BatchStatus { growing, ready, completed, cancelled }

class ProductionBatch {
  final String id;
  final SeedlingType seedlingType;
  final DateTime sowingDate;
  final int quantity;
  int availableQuantity;
  BatchStatus status;
  final List<GrowthRecord> growthRecords;

  ProductionBatch({
    required this.id,
    required this.seedlingType,
    required this.sowingDate,
    required this.quantity,
    int? availableQuantity,
    this.status = BatchStatus.growing,
    List<GrowthRecord>? growthRecords,
  })  : availableQuantity = availableQuantity ?? quantity,
        growthRecords = List<GrowthRecord>.from(growthRecords ?? []) {
    if (quantity < 0) throw ArgumentError('Quantity cannot be negative.');
    if (this.availableQuantity < 0 || this.availableQuantity > quantity) {
      throw ArgumentError('Available quantity must be between 0 and total quantity.');
    }
  }

  DateTime get readyDate =>
      sowingDate.add(Duration(days: seedlingType.growingDays));

  bool get isReadyDateReached =>
      !DateTime.now().isBefore(readyDate);

  int get totalHealthy {
    if (growthRecords.isEmpty) return 0;
    return growthRecords.last.healthy;
  }

  void addGrowthRecord(GrowthRecord record) {
    if (record.date.isBefore(sowingDate)) {
      throw ArgumentError('A growth record cannot be before the sowing date.');
    }
    growthRecords.add(record);
  }

  void approveAsReady({int? approvedQuantity}) {
    final approved = approvedQuantity ?? availableQuantity;
    if (approved < 0 || approved > quantity) {
      throw ArgumentError('Approved quantity must be between 0 and batch quantity.');
    }
    availableQuantity = approved;
    status = BatchStatus.ready;
  }

  void reserve(int requestedQuantity) {
    if (status != BatchStatus.ready) {
      throw StateError('Only ready batches can be reserved.');
    }
    if (requestedQuantity <= 0 || requestedQuantity > availableQuantity) {
      throw ArgumentError('Requested quantity is not available.');
    }
    availableQuantity -= requestedQuantity;
    if (availableQuantity == 0) status = BatchStatus.completed;
  }
}
