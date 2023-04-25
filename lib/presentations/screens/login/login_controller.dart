import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/apis/api_calls.dart';
import '../../../data/models/login_data_model.dart';
import '../../../utils/app_utils.dart';
import '../home/home_view.dart';

class LoginController extends GetxController {
  RxBool loading = false.obs;
  RxBool visible = true.obs;
  APIServices apiServices = APIServices();

  login(email, password, context) async {
    loading.value = true;
    LoginDataModel loginDataModel =
        await apiServices.loginUser(email, password, context);
    if (loginDataModel.status ?? false) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(
          'sessionToken', loginDataModel.payload ?? "session token");

      Get.offAll(() => HomePageView());
    }
    loading.value = false;
  }
}
