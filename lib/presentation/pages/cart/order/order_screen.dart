part of '../../pages.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CartService cartService = Get.put(CartService());
    final TextEditingController _namaPemesan = TextEditingController();
    final TextEditingController _nomorMeja = TextEditingController();

    Future<void> orderNow({required int totalAmount}) async {
      if (_namaPemesan.text.isEmpty || _nomorMeja.text.isEmpty) {
        Get.snackbar("Error", "Pastikan untuk mengisi semua input dengan benar",
            backgroundColor: failcolor);
      } else {
        try {
          User? currentUser = FirebaseAuth.instance.currentUser;
          if (currentUser != null) {
            String userId = currentUser.uid;
            CollectionReference orderCollection = FirebaseFirestore.instance
                .collection('users')
                .doc(userId)
                .collection('order');

            QuerySnapshot orderSnapshot = await orderCollection.get();

// Menghapus setiap dokumen yang ada dalam subcollection
            List<Future<void>> deleteFutures = [];
            orderSnapshot.docs.forEach((doc) {
              deleteFutures.add(doc.reference.delete());
            });

// Menunggu semua operasi penghapusan selesai
            await Future.wait(deleteFutures);
            DocumentReference orderRef = await orderCollection.add({
              'nomorMeja': _nomorMeja.text,
              'namaPemesan': _namaPemesan.text,
              'uploadPembayaran': '',
              'totalAmount': totalAmount,
              'createdAt': FieldValue.serverTimestamp(),
            });

            String orderId = orderRef.id;

            // Navigasi ke halaman pembayaran dengan menyertakan orderId
            Get.toNamed(AppPages.PAYMENT_SCREEN, arguments: {
              'cartItems': cartService.cartItems,
              'totalAmount': totalAmount,
              'namaPemesan': _namaPemesan.text,
              'nomorMeja': _nomorMeja.text,
              'orderId': orderId,
              'userId': userId,
            });
          } else {
            Get.snackbar("Error", "User tidak terautentikasi");
          }
        } catch (e) {
          print('Error creating order: $e');
          Get.snackbar("Error", "Gagal membuat pesanan: $e");
        }
      }
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('TechTaste'),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {},
          ),
        ],
      ),
      body: Obx(() {
        if (cartService.cartItems.isEmpty) {
          return Center(
            child: Text(
              'No items in cart',
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        int totalAmount = cartService.cartItems
            .fold(0, (sum, item) => sum + item.price * item.quantity);

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'List Pesanan Anda',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView(
                  children: cartService.cartItems.map((item) {
                    return ListTile(
                      leading: Image.asset(item.image,
                          width: 50, height: 50, fit: BoxFit.cover),
                      title: Text(item.title,
                          style: TextStyle(color: Colors.white)),
                      subtitle: Text('${item.quantity} x Rp. ${item.price}',
                          style: TextStyle(color: Colors.yellow)),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          cartService.removeItemFromCart(item.id);
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),
              const Divider(color: Colors.white),
              const SizedBox(height: 10),
              TotalAmount(total: totalAmount),
              const SizedBox(height: 20),
              TextField(
                controller: _namaPemesan,
                decoration: const InputDecoration(
                  labelText: 'Nama Pemesan',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _nomorMeja,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Nomor Meja',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                  ),
                  onPressed: () => orderNow(totalAmount: totalAmount),
                  child: const Text(
                    'Pesan sekarang',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                  ),
                  onPressed: () {
                    cartService.clearCart();
                  },
                  child: const Text(
                    'Clear All',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
