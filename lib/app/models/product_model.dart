class Supplier {
  final String name;
  final String address;
  final String phone;
  final String email;

  Supplier({
    required this.name,
    required this.address,
    required this.phone,
    required this.email,
  });
}

class Product {
  final String id;
  final String name;
  final String subtitle;
  final String imageUrl;
  final double price;
  final int quantity;
  final String status;
  final String description;
  final String sku;
  final Supplier supplier;

  Product({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.imageUrl,
    required this.price,
    required this.quantity,
    required this.status,
    required this.description,
    required this.sku,
    required this.supplier,
  });
}
