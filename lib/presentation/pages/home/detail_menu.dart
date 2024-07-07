part of '../pages.dart';

class DetailMenu extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> item = Get.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(item['title']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.asset(item['image']),
            SizedBox(height: 10),
            Text(
              item['title'],
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Rp ${item['price']}',
              style: TextStyle(fontSize: 20, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
