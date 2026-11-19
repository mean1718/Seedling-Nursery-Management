class Customer {
  final String id;
  String name;
  String phone;
  String address;

  Customer({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
  });

  void updateContact({String? phone, String? address}) {
    if (phone != null) this.phone = phone;
    if (address != null) this.address = address;
  }

  @override
  String toString() => 'Customer($id, $name)';
}
