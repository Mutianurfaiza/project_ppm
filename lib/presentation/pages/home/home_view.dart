part of '../pages.dart';

class HomeView extends GetView<HomeController> {
  HomeView({super.key});

  final _authController = Get.put(AuthController());
  final CartService _cartService = Get.put(CartService());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: baseColor,
        appBar: AppBar(
          leading: Container(
            margin: const EdgeInsets.only(left: 16),
            child: Image.asset(
              "assets/img/icon_logo.png",
              fit: BoxFit.cover,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.shopping_cart,
                color: whitecolor,
              ),
              onPressed: () {
                // Navigate to detail page
                Get.toNamed(AppPages.ORDER_SCREEN);
              },
            ),
            IconButton(
              icon: const Icon(Icons.logout, color: whitecolor),
              onPressed: () {
                _authController.signOut();
              },
            ),
            const SizedBox()
          ],
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Makanan'),
              Tab(text: 'Minuman'),
            ],
            labelColor: Colors.yellow,
            unselectedLabelColor: Colors.white,
            indicatorColor: Colors.yellow,
          ),
          backgroundColor: Colors.black,
        ),
        body: TabBarView(
          children: [
            _buildMakananTab(),
            _buildMinumanTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildMakananTab() {
    return Center(
      child: ListView(
        children: [
          CardItem(
            image: "assets/img/bubur_ayam.jpg",
            title: "Bubur Ayam",
            price: 15000,
          ),
          CardItem(
            image: "assets/img/nasgor_spesial.jpg",
            title: "Nasi goreng spesial",
            price: 20000,
          ),
        ],
      ),
    );
  }

  Widget _buildMinumanTab() {
    return Center(
      child: ListView(
        children: [
          CardItem(
            image: "assets/img/es_teh.jpg",
            title: "Es Teh",
            price: 5000,
          ),
          CardItem(
            image: "assets/img/jus_alpukat.jpg",
            title: "Jus Mangga",
            price: 10000,
          ),
        ],
      ),
    );
  }
}
