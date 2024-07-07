import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:kulbal/app/common/app_styles.dart';
import 'package:kulbal/app/routes/app_pages.dart';
import 'package:kulbal/domain/model/cart_item_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartService extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var cartItems = <CartItemModel>[].obs;

  User? get currentUser => _auth.currentUser;

  CollectionReference _getUserCartCollection() {
    final userId = currentUser?.uid;
    if (userId == null) {
      throw Exception("User not authenticated");
    }
    return _firestore.collection('users').doc(userId).collection('cart');
  }

  CollectionReference _getOrderCartCollection() {
    final userId = currentUser?.uid;
    if (userId == null) {
      throw Exception("User not authenticated");
    }
    return _firestore.collection('users').doc(userId).collection('order');
  }

  @override
  void onInit() {
    super.onInit();
    fetchCartItems();
  }

  Future<void> fetchCartItems() async {
    if (currentUser == null) {
      Get.snackbar("Error", "User not authenticated");
      return;
    }
    try {
      final cartCollection = _getUserCartCollection();
      QuerySnapshot snapshot = await cartCollection.get();
      cartItems.value = snapshot.docs.map((doc) {
        return CartItemModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    } on FirebaseException catch (e) {
      Get.snackbar("Error", e.message ?? "Unknown Firebase error");
      print("FirebaseException: ${e.message}");
    } catch (e) {
      Get.snackbar("Error", "An unexpected error occurred.");
      print("Exception: $e");
    }
  }

  Future<void> addItemToCart(CartItemModel item) async {
    if (currentUser == null) {
      Get.snackbar("Error", "User not authenticated");
      return;
    }
    try {
      final cartCollection = _getUserCartCollection();
      QuerySnapshot querySnapshot =
          await cartCollection.where('id', isEqualTo: item.id).get();

      if (querySnapshot.docs.isEmpty) {
        await cartCollection.add(item.toMap());
        fetchCartItems();
        Get.snackbar("Sukses!!", "Item telah berhasil ditambahkan",
            backgroundColor: successcolor);
        Timer(Duration(seconds: 1), () {
          Get.toNamed(AppPages.ORDER_SCREEN);
        });
      } else {
        Get.toNamed(AppPages.ORDER_SCREEN);
      }
    } on FirebaseException catch (e) {
      Get.snackbar("Error", e.message ?? "Unknown Firebase error");
      print("FirebaseException: ${e.message}");
    } catch (e) {
      Get.snackbar("Error", "An unexpected error occurred.");
      print("Exception: $e");
    }
  }

  Future<void> removeItemFromCart(String itemId) async {
    if (currentUser == null) {
      Get.snackbar("Error", "User not authenticated");
      return;
    }
    try {
      final cartCollection = _getUserCartCollection();
      QuerySnapshot snapshot =
          await cartCollection.where('id', isEqualTo: itemId).get();
      for (QueryDocumentSnapshot doc in snapshot.docs) {
        await doc.reference.delete();
      }
      cartItems.removeWhere((item) => item.id == itemId);
      Get.snackbar("Sukses!!", "Item telah berhasil dihapus",
          backgroundColor: successcolor);
    } on FirebaseException catch (e) {
      Get.snackbar("Error", e.message ?? "Unknown Firebase error");
      print("FirebaseException: ${e.message}");
    } catch (e) {
      Get.snackbar("Error", "An unexpected error occurred.");
      print("Exception: $e");
    }
  }

  Future<void> clearCart() async {
    if (currentUser == null) {
      Get.snackbar("Error", "User not authenticated");
      return;
    }
    try {
      final cartCollection = _getUserCartCollection();
      QuerySnapshot snapshot = await cartCollection.get();
      for (QueryDocumentSnapshot doc in snapshot.docs) {
        await doc.reference.delete();
      }
      final orderCollection = _getOrderCartCollection();
      QuerySnapshot snapshotOrder = await orderCollection.get();
      for (QueryDocumentSnapshot doc in snapshotOrder.docs) {
        await doc.reference.delete();
      }
      cartItems.clear();
      Get.snackbar("Sukses!!", "Item telah berhasil dihapus",
          backgroundColor: successcolor);
      Timer(Duration(seconds: 2), () {
        Get.toNamed(AppPages.HOME);
      });
    } on FirebaseException catch (e) {
      Get.snackbar("Error", e.message ?? "Unknown Firebase error");
      print("FirebaseException: ${e.message}");
    } catch (e) {
      Get.snackbar("Error", "An unexpected error occurred.");
      print("Exception: $e");
    }
  }
}
