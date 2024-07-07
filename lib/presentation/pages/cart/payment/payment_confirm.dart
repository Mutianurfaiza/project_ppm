part of '../../pages.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  File? _image;
  bool _uploading = false; // State untuk menunjukkan sedang upload
  bool _loadingProgress = false; // State untuk menunjukkan sedang loading
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
        }
      });
    } catch (e) {
      print('Image picker error: $e');
      Get.snackbar("Error", "Failed to pick image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> arguments = Get.arguments;
    final List<CartItemModel> cartItems = arguments['cartItems'];
    final int totalAmount = arguments['totalAmount'];
    final String namaPemesan = arguments['namaPemesan'];
    final String nomorMeja = arguments['nomorMeja'];
    final String orderId = arguments['orderId'];
    final String userId = arguments['userId'];

    int _calculateTotalItems(List<CartItemModel> cartItems) {
      int totalItems = 0;
      for (var item in cartItems) {
        totalItems += item.quantity;
      }
      return totalItems;
    }

    Future<void> _uploadPayment(String orderId, String userId) async {
      if (_image != null) {
        setState(() {
          _loadingProgress = true; // Mulai progress loading
        });

        try {
          String fileName =
              'payment_${DateTime.now().millisecondsSinceEpoch}.jpg';
          Reference storageRef =
              FirebaseStorage.instance.ref().child('payments').child(fileName);
          UploadTask uploadTask = storageRef.putFile(_image!);
          TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
          String imageUrl = await storageRef.getDownloadURL();
          print("ini gambar: " + imageUrl);

          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .collection('order')
              .doc(orderId)
              .update({
            'uploadPembayaran': imageUrl,
          });

          int totalItems = _calculateTotalItems(cartItems);
          String formattedDate =
              DateFormat('yyyy-MM-ddTHH:mm:ss.SSS').format(DateTime.now());
          print('ini sekarang' + formattedDate);

          await FirebaseFirestore.instance.collection('purchase_logs').add({
            'purchase_date': formattedDate,
            'total_items': totalItems,
            'total_payment': totalAmount,
            'user_id': userId,
          });

          // Navigasi ke halaman sukses
          Get.toNamed(AppPages.SUCCESS_SCREEN, arguments: {
            'cartItems': cartItems,
            'totalAmount': totalAmount,
            'namaPemesan': namaPemesan,
            'nomorMeja': nomorMeja,
            'orderId': orderId,
            'imageUrl': imageUrl,
            'userId': userId,
          });
        } catch (e) {
          print('Upload error: $e');
          Get.snackbar("Error", "Failed to upload payment: $e");
        } finally {
          setState(() {
            _loadingProgress =
                false; // Berhenti loading progress setelah selesai
          });
        }
      } else {
        Get.snackbar("Error", "Please select an image first.");
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Pesanan Berhasil dibuat'),
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
                    Text(
                      "Pesanan Berhasil dibuat",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "menunggu pembayaran",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 20),
                    const Icon(
                      Icons.access_time,
                      size: 50,
                      color: Colors.grey,
                    ),
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
                decoration: BoxDecoration(
                  color: Colors.yellow,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Silahkan melakukan pembayaran melalui berikut:',
                      style: TextStyle(color: Colors.black),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'BNI    18918222    a.n Admin Kulbal',
                      style: TextStyle(color: Colors.black),
                    ),
                    Text(
                      'BRI    18918222    a.n Admin Kulbal',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Upload Bukti Pembayaran',
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _image == null ? 'no image' : 'image selected',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const Icon(Icons.upload_file, color: Colors.white),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_uploading || _loadingProgress) {
                      // Jika sedang upload atau loading progress, tidak melakukan apa-apa
                      return;
                    }

                    if (_image != null) {
                      print('Uploading image: ${_image!.path}');

                      setState(() {
                        _loadingProgress = true; // Mulai progress loading
                      });

                      _uploadPayment(orderId, userId);
                    } else {
                      Get.snackbar("Error", "Please select an image first.",
                          backgroundColor: Colors.red);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                  ),
                  child: _loadingProgress
                      ? CircularProgressIndicator() // Tampilkan indicator saat loading progress true
                      : Text(
                          _uploading ? 'Loading...' : 'Kirim Bukti Pembayaran',
                          style: TextStyle(color: Colors.black),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.black,
    );
  }
}
