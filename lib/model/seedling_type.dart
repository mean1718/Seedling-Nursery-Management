class SeedlingType {
  final String id;
  String name;
  int growingDays;
  double price;
  int minimumStock;

  SeedlingType({
    required this.id,
    required this.name,
    required this.growingDays,
    required this.price,
    required this.minimumStock,
  }) {
    if (growingDays < 0) {
      throw ArgumentError.value(growingDays, 'growingDays', 'Cannot be negative.');
    }
    if (price < 0) {
      throw ArgumentError.value(price, 'price', 'Cannot be negative.');
    }
    if (minimumStock < 0) {
      throw ArgumentError.value(minimumStock, 'minimumStock', 'Cannot be negative.');
    }
  }

  void updatePrice(double newPrice) {
    if (newPrice < 0) throw ArgumentError('Price cannot be negative.');
    price = newPrice;
  }

  @override
  String toString() => 'SeedlingType($id, $name)';
}
