part of '../../pages.dart';

class SuccessScreen extends StatefulWidget {
  @override
  _SuccessScreenState createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> arguments = Get.arguments;
    final List<CartItemModel> cartItems = arguments['cartItems'];
    final int totalAmount = arguments['totalAmount'];
    final String namaPemesan = arguments['namaPemesan'];
    final String nomorMeja = arguments['nomorMeja'];
    final String orderId = arguments['orderId'];
    final String imageUrl = arguments['imageUrl'];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Pembayaran berhasil'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Image.asset(
                      "assets/img/icon_logo.png",
                      width: 100,
                      height: 100,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Pembayaran Berhasil",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Pesanan anda akan diproses",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 20),
                    const Icon(Icons.check_circle,
                        size: 100, color: Colors.green),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              const Text(
                'Detail Pesanan anda',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              const SizedBox(height: 10),
              ...cartItems.map((item) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${item.quantity} x ${item.title}',
                        style: const TextStyle(color: Colors.white),
                      ),
                      Text(
                        'Rp. ${item.price}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                );
              }).toList(),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total:',
                    style: TextStyle(fontSize: 16, color: Colors.yellow),
                  ),
                  Text(
                    'Rp. $totalAmount',
                    style: const TextStyle(fontSize: 16, color: Colors.yellow),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Nama Pemesan : $namaPemesan',
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
              Text(
                'Nomor Meja : $nomorMeja',
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(10),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pesanan anda sedang dibuat',
                    ),
                    Text(
                      'Silahkan ditunggu, Terima kasih',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Bukti Pembayaran',
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
              const SizedBox(height: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (imageUrl != null) Image.network(imageUrl),
                  // Other UI elements
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.black,
    );
  }
}
