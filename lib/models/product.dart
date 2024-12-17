class Product {
  final int id;
  final String photo;
  final String name;
  final String description;
  final int quantity;
  final double price;
  final String location;
  final String expiryDate;

  Product(
      {required this.id,
      required this.photo,
      required this.name,
      required this.description,
      required this.quantity,
      required this.price,
      required this.location,
      required this.expiryDate});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'photo': photo,
      'name': name,
      'description': description,
      'quantity': quantity,
      'price': price,
      'location': location,
      'expiryDate': expiryDate
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      photo: map['photo'] ?? '',
      name: map['name'],
      description: map['description'] ?? '',
      quantity: map['quantity'],
      price: map['price'],
      location: map['location'],
      expiryDate: map['expiryDate'],
    );
  }
}
