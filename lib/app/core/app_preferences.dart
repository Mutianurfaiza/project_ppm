import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  void setLoginState(bool value) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setBool('isLogin', value);
  }

  Future<bool> getLoginState() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getBool('isLogin') ?? false;
  }

  void setIdUser(String idUser) async {
    SharedPreferences pref = await _prefs;
    pref.setString('iduser', idUser);
  }

  Future<String> getIdUser() async {
    SharedPreferences pref = await _prefs;
    return pref.getString('iduser')!;
  }
}
