part of '../../pages.dart';

class OrderItem extends GetView<CartService> {
  final String imageUrl;
  final String itemName;
  final int quantity;
  final int price;

  const OrderItem({
    required this.imageUrl,
    required this.itemName,
    required this.quantity,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Image.asset(imageUrl, width: 50, height: 50),
          const SizedBox(width: 10),
          Text(
            '$quantity x $itemName',
            style: TextStyle(color: Colors.white),
          ),
          Spacer(),
          Text(
            'Rp. $price',
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
