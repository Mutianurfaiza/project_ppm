class CartItemModel {
  String id;
  String title;
  String image;
  int quantity;
  int price;

  CartItemModel({
    required this.id,
    required this.title,
    required this.image,
    required this.quantity,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'image': image,
      'quantity': quantity,
      'price': price,
    };
  }

  static CartItemModel fromMap(Map<String, dynamic> map) {
    return CartItemModel(
      id: map['id'],
      title: map['title'],
      image: map['image'],
      quantity: map['quantity'],
      price: map['price'],
    );
  }
}
