import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kulbal/app/common/app_styles.dart';
import 'package:kulbal/app/routes/app_pages.dart';
import 'package:kulbal/domain/model/cart_item_model.dart';
import 'package:kulbal/presentation/controllers/cart/cart_controller.dart';

class CardItem extends StatelessWidget {
  final String image;
  final String title;
  final int price;

  const CardItem({
    required this.image,
    required this.title,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    final CartService cartService = Get.find<CartService>();

    return Card(
      child: ListTile(
        leading: Image.asset(image),
        title: Text(title),
        subtitle: Text('Rp $price'),
        trailing: IconButton(
          icon: const Icon(Icons.add_shopping_cart),
          onPressed: () async {
            int? quantity = await showDialog<int>(
              context: context,
              builder: (context) {
                int tempQuantity = 1;
                return AlertDialog(
                  title: Text('Jumlah Pesanan'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Masukkan jumlah pesanan untuk $title'),
                      TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(hintText: '0'),
                        onChanged: (value) {
                          tempQuantity = int.tryParse(value) ?? 1;
                        },
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, tempQuantity),
                      child: Text('Add'),
                    ),
                  ],
                );
              },
            );

            if (quantity != null && quantity > 0) {
              CartItemModel item = CartItemModel(
                id: title,
                title: title,
                image: image,
                quantity: quantity,
                price: price,
              );
              await cartService.addItemToCart(item);
            }
          },
        ),
        onTap: () {
          Get.toNamed(AppPages.DETAIL_MENU, arguments: {
            'image': image,
            'title': title,
            'price': price,
          });
        },
      ),
    );
  }
}
