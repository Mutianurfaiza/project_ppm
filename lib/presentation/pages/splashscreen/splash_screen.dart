part of '../pages.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  final AppPreferences _preferences = AppPreferences();

  @override
  void initState() {
    super.initState();
    startSplashScreen();
  }

  startSplashScreen() async {
    var duration = const Duration(seconds: 3);
    return Timer(duration, () async {
      final isLogin = await _preferences.getLoginState();

      (isLogin)
          ? Get.offAllNamed(AppPages.HOME)
          : Get.offAllNamed(AppPages.LOGIN);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: baseColor,
      body: Center(
        child: SizedBox(
          height: 200,
          width: 200,
          child: Image.asset("assets/img/icon_logo.png"),
        ),
      ),
    );
  }
}
