import 'package:get/get.dart';

class ForgetPasswordController extends GetxController {
  RxBool loading = false.obs;

  forgetPassword(email) async {
    loading.value = true;

    await Future.delayed(Duration(seconds: 2));

    loading.value = false;
  }
}
