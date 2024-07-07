part of '../../pages.dart';

class TotalAmount extends GetView<CartService> {
  final int total;

  const TotalAmount({required this.total});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Total:',
          style: TextStyle(fontSize: 16, color: Colors.yellow),
        ),
        Text(
          'Rp. $total',
          style: TextStyle(fontSize: 16, color: Colors.yellow),
        ),
      ],
    );
  }
}
