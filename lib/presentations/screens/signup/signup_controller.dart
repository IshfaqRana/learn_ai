import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/apis/api_calls.dart';
import '../../../data/models/signup_data_model.dart';
import '../../../utils/app_utils.dart';
import '../home/home_view.dart';

class SignupController extends GetxController {
  RxBool email = false.obs;
  RxBool username = false.obs;
  RxBool password = false.obs;
  RxBool visiblePassword = true.obs;
  RxBool visibleConfirmPassword = true.obs;
  RxBool loading = false.obs;
  RxBool confirmPassword = false.obs;
  APIServices apiServices = APIServices();

  checkEmailEmpty() {
    email.value = false;
  }

  checkPasswordEmpty() {
    password.value = false;
  }

  checkUsernameEmpty() {
    username.value = false;
  }

  checkConfPasswordEmpty() {
    confirmPassword.value = false;
  }

  signup(username, email, password, context) async {
    loading.value = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    SignupDataModel signupDataModel =
        await apiServices.createAccount(username, email, password, context);
    if (signupDataModel.status ?? false) {
      Utils.showToasts(context, "Registered Successfully!");
      prefs.setString(
          'sessionToken', signupDataModel.payload!.jwt ?? "session token");

      Get.offAll(() => HomePageView());
    }
    loading.value = false;
  }
}
