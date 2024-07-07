import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kulbal/app/common/app_styles.dart';
import 'package:kulbal/app/core/app_preferences.dart';
import 'package:kulbal/app/routes/app_pages.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _preferences = AppPreferences();

  Stream<User?> get streamuser => _auth.authStateChanges();

  Future<UserCredential> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      if (userCredential.user != null) {
        _preferences.setIdUser(userCredential.user!.uid);
        _preferences.setLoginState(true);
        Get.snackbar("Login Sukses !!!", "Hallo ${userCredential.user!.email}",
            backgroundColor: successcolor);
        Timer(Duration(seconds: 2), () {
          Get.offAllNamed(AppPages.HOME);
        });
      } else {
        Get.snackbar("Login Gagal", "Login failed: User is null",
            backgroundColor: failcolor);
      }
      return userCredential;
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Login Gagal", "${e.message}", backgroundColor: failcolor);
      throw Exception("Authentication error: ${e.message}");
    } catch (e) {
      print("General exception: $e");
      throw Exception("An error occurred during login: $e");
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      _preferences.setLoginState(false);
      Get.snackbar("Logout Sukses", "Selamat tinggal",
          backgroundColor: failcolor);
      Timer(Duration(seconds: 2), () => Get.offAllNamed(AppPages.LOGIN));
    } catch (e) {
      throw Exception("An error occurred during sign out: $e");
    }
  }

  Future<void> register(
      String name, String phone, String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'name': name,
          'phone': phone,
          'email': email,
          'role': 'user',
        });

        _preferences.setIdUser(user.uid);
        _preferences.setLoginState(true);
        Get.snackbar("Registrasi Sukses !!!", "Hallo ${user.email}",
            backgroundColor: successcolor);
        Timer(const Duration(seconds: 2), () {
          Get.offAllNamed(AppPages.HOME);
        });
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Registrasi Gagal", "${e.message}",
          backgroundColor: failcolor);
      throw Exception("Authentication error: ${e.message}");
    } catch (e) {
      print("General exception: $e");
      Get.snackbar("Error", "An error occurred during registration",
          backgroundColor: failcolor);
      throw Exception("An error occurred during registration: $e");
    }
  }
}
