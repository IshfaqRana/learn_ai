import 'package:get/get.dart';
import 'package:learn_ai/utils/app_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DarkThemePreference extends GetxController {
  static const THEME_STATUS = "THEMESTATUS";
  RxBool darkMode = false.obs;

  @override
  void onInit() {
    // getTheme();
    super.onInit();
  }

  setDarkTheme(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(THEME_STATUS, value);
    darkMode.value = value;
    Utils.printDebug(darkMode);
  }

  Future<bool> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    darkMode.value = prefs.getBool(THEME_STATUS) ?? false;
    Utils.printDebug(darkMode);
    return prefs.getBool(THEME_STATUS) ?? false;
  }
}
