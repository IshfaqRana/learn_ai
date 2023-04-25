import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_images.dart';
import '../../../utils/app_utils.dart';
import '../../../utils/text_styles.dart';
import '../../widgets/custom_button.dart';
import 'forget_password_controller.dart';

// ignore: must_be_immutable
class ForgetPassword extends StatelessWidget {
  ForgetPassword({Key? key}) : super(key: key);

  TextEditingController emailController = TextEditingController();
  ForgetPasswordController forgetPasswordController =
      Get.put(ForgetPasswordController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: AppColors.kWhite,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(4.0.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: SizedBox(
                      height: 3.h,
                      width: 1.5.h,
                      child: Image.asset(AppImages.back,
                          color: AppColors.lightBlue),
                    ),
                  ),
                  SizedBox(
                    height: 4.0.h,
                  ),
                  Center(
                    child: SizedBox(
                        height: 17.h,
                        child: Image.asset(
                          AppImages.login,
                          fit: BoxFit.contain,
                        )),
                  ),
                  SizedBox(
                    height: 4.0.h,
                  ),
                  SizedBox(
                    height: 7.h,
                    width: 70.0.w,
                    child: Text(
                      "Forgot Password",
                      style: AppTextStyles.regBlack25Medium,
                    ),
                  ),
                  SizedBox(
                    height: 1.5.h,
                  ),
                  SizedBox(
                    height: 4.h,
                    width: 90.0.w,
                    child: Text(
                      "Enter the email adrees associated with your account",
                      style: AppTextStyles.regBlack10,
                    ),
                  ),
                  SizedBox(
                    height: 4.0.h,
                  ),
                  Container(
                    height: 5.4.h,
                    decoration: BoxDecoration(
                      color: AppColors.kWhite,
                      borderRadius: BorderRadius.circular(1.0.h),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF000000).withOpacity(0.04),
                          blurRadius: 0.5.h,
                          spreadRadius: 0.2.h,
                          offset: Offset(0.5.h, 0.5.h),
                        ),
                        BoxShadow(
                          color: const Color(0xFF000000).withOpacity(0.04),
                          blurRadius: 1.0.h,
                          spreadRadius: 0.1.w,
                          offset: Offset(-0.2.h, -0.2.h),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 4.w,
                          height: 4.w,
                        ),
                        SizedBox(
                            width: 4.w,
                            height: 4.w,
                            child: Icon(
                              Icons.email_outlined,
                              size: 4.w,
                              color: AppColors.lightBlue,
                            )),
                        SizedBox(
                          width: 4.w,
                          height: 4.w,
                        ),
                        SizedBox(
                          width: 68.w,
                          child: TextField(
                            style: AppTextStyles.regBlackTextField12,
                            maxLines: 1,
                            controller: emailController,
                            decoration: InputDecoration.collapsed(
                              hintText: "Email Address",
                              border: InputBorder.none,
                              hintStyle: AppTextStyles.regBlackTextField12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  CustomButton(
                    color: AppColors.lightBlue,
                    text: "Submit",
                    height: 5.4.h,
                    loading: forgetPasswordController.loading.value,
                    onPressed: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      if (emailController.text == "") {
                        Utils.showToasts(context, "Please enter email...");
                      } else {
                        forgetPasswordController
                            .forgetPassword(emailController.text);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
