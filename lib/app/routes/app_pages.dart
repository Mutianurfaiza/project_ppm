import 'package:get/get.dart';
import 'package:kulbal/presentation/bindings/auth/auth.dart';
import 'package:kulbal/presentation/pages/pages.dart';

import '../../presentation/bindings/home/home_binding.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;
  static const HOME = Routes.HOME;
  static const DETAIL_MENU = Routes.DETAIL_MENU;
  static const LOGIN = Routes.LOGIN;
  static const ORDER_SCREEN = Routes.ORDER_SCREEN;
  static const PAYMENT_SCREEN = Routes.PAYMENT_SCREEN;
  static const SUCCESS_SCREEN = Routes.SUCCESS_SCREEN;
  static const REGISTER = Routes.REGISTER;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashScreenPage(),
    ),
    GetPage(
        name: _Paths.LOGIN, page: () => LoginView(), binding: AuthBinding()),
    GetPage(name: _Paths.PAYMENT_SCREEN, page: () => PaymentScreen()),
    GetPage(name: _Paths.SUCCESS_SCREEN, page: () => SuccessScreen()),
    GetPage(name: _Paths.ORDER_SCREEN, page: () => const OrderScreen()),
    GetPage(name: _Paths.REGISTER, page: () => RegisterView()),
    GetPage(name: _Paths.DETAIL_MENU, page: () => DetailMenu()),
  ];
}
