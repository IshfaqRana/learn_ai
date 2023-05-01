// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learn_ai/presentations/screens/signup/signup_controller.dart';
import 'package:learn_ai/utils/theme.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_images.dart';
import '../../../utils/app_utils.dart';
import '../../../utils/text_styles.dart';
import '../../widgets/custom_button.dart';

// ignore: must_be_immutable
class SignupView extends StatelessWidget {
  SignupView({Key? key}) : super(key: key);
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmController = TextEditingController();

  SignupController signupController = Get.put(SignupController());
  DarkThemePreference darkThemePreference = Get.put(DarkThemePreference());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: !darkThemePreference.darkMode.value
            ? AppColors.kWhite
            : AppColors.hardBlue,
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
                          color: !darkThemePreference.darkMode.value
                              ? AppColors.kBlack2
                              : AppColors.kWhite),
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
                      "Sign Up",
                      style: !darkThemePreference.darkMode.value
                          ? AppTextStyles.regBlack20Medium
                          : AppTextStyles.regWhiteBold20,
                    ),
                  ),
                  SizedBox(
                    height: 4.0.h,
                  ),
                  Container(
                    height: 5.4.h,
                    decoration: BoxDecoration(
                      color: !darkThemePreference.darkMode.value
                          ? AppColors.kWhite
                          : AppColors.kGrey,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(1.0.h),
                          topRight: Radius.circular(1.0.h)),
                      border: signupController.username.value
                          ? Border.all(
                              color: !darkThemePreference.darkMode.value
                                  ? AppColors.red
                                  : Colors.greenAccent,
                              width: 0.5.w)
                          : const Border.fromBorderSide(BorderSide.none),
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
                          width: !signupController.username.value ? 4.w : 3.5.w,
                          height: 4.w,
                        ),
                        SizedBox(
                            width: 4.w,
                            height: 4.w,
                            child: Icon(
                              Icons.person,
                              size: 4.w,
                              color: !darkThemePreference.darkMode.value
                                  ? AppColors.kBlack2
                                  : AppColors.kWhite,
                            )),
                        SizedBox(
                          width: 4.w,
                          height: 4.w,
                        ),
                        SizedBox(
                          width: 68.w,
                          child: TextField(
                            style: !darkThemePreference.darkMode.value
                                ? AppTextStyles.regBlackTextField12
                                : AppTextStyles.regWhiteTextField12,
                            maxLines: 1,
                            controller: usernameController,
                            decoration: InputDecoration.collapsed(
                              hintText: "Username",
                              border: InputBorder.none,
                              hintStyle: !darkThemePreference.darkMode.value
                                  ? AppTextStyles.regBlackTextField12
                                  : AppTextStyles.regWhiteTextField12,
                            ),
                            onTap: () {
                              signupController.checkUsernameEmpty();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 0.3.h,
                  ),
                  Container(
                    height: 5.4.h,
                    decoration: BoxDecoration(
                      color: !darkThemePreference.darkMode.value
                          ? AppColors.kWhite
                          : AppColors.kGrey,
                      // borderRadius: BorderRadius.only(
                      //     topLeft: Radius.circular(1.0.h),
                      //     topRight: Radius.circular(1.0.h)),
                      border: signupController.email.value
                          ? Border.all(
                              color: !darkThemePreference.darkMode.value
                                  ? AppColors.red
                                  : Colors.greenAccent,
                              width: 0.5.w)
                          : const Border.fromBorderSide(BorderSide.none),
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
                          width: !signupController.email.value ? 4.w : 3.5.w,
                          height: 4.w,
                        ),
                        SizedBox(
                            width: 4.w,
                            height: 4.w,
                            child: Icon(
                              Icons.email_outlined,
                              size: 4.w,
                              color: !darkThemePreference.darkMode.value
                                  ? AppColors.kBlack2
                                  : AppColors.kWhite,
                            )),
                        SizedBox(
                          width: 4.w,
                          height: 4.w,
                        ),
                        SizedBox(
                          width: 68.w,
                          child: TextField(
                            style: !darkThemePreference.darkMode.value
                                ? AppTextStyles.regBlackTextField12
                                : AppTextStyles.regWhiteTextField12,
                            maxLines: 1,
                            controller: emailController,
                            decoration: InputDecoration.collapsed(
                              hintText: "Email Address",
                              border: InputBorder.none,
                              hintStyle: !darkThemePreference.darkMode.value
                                  ? AppTextStyles.regBlackTextField12
                                  : AppTextStyles.regWhiteTextField12,
                            ),
                            onTap: () {
                              signupController.checkEmailEmpty();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 0.3.h,
                  ),
                  Container(
                    height: 5.4.h,
                    decoration: BoxDecoration(
                      color: !darkThemePreference.darkMode.value
                          ? AppColors.kWhite
                          : AppColors.kGrey,
                      border: signupController.password.value
                          ? Border.all(
                              color: !darkThemePreference.darkMode.value
                                  ? AppColors.red
                                  : Colors.greenAccent,
                              width: 0.5.w)
                          : const Border.fromBorderSide(BorderSide.none),
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
                          width: !signupController.password.value ? 4.w : 3.5.w,
                          height: 4.w,
                        ),
                        SizedBox(
                            width: 4.w,
                            height: 4.w,
                            child: Icon(
                              Icons.lock_outlined,
                              size: 4.w,
                              color: !darkThemePreference.darkMode.value
                                  ? AppColors.kBlack2
                                  : AppColors.kWhite,
                            )),
                        SizedBox(
                          width: 4.w,
                          height: 4.w,
                        ),
                        SizedBox(
                          width: 68.w,
                          child: TextField(
                            style: !darkThemePreference.darkMode.value
                                ? AppTextStyles.regBlackTextField12
                                : AppTextStyles.regWhiteTextField12,
                            maxLines: 1,
                            controller: passwordController,
                            obscureText: signupController.visiblePassword.value,
                            decoration: InputDecoration.collapsed(
                              hintText: "Password",
                              border: InputBorder.none,
                              hintStyle: !darkThemePreference.darkMode.value
                                  ? AppTextStyles.regBlackTextField12
                                  : AppTextStyles.regWhiteTextField12,
                            ),
                            onTap: () {
                              signupController.checkPasswordEmpty();
                            },
                          ),
                        ),
                        SizedBox(
                          width: 4.w,
                          height: 4.w,
                        ),
                        SizedBox(
                          width: 4.w,
                          height: 4.w,
                          child: signupController.visiblePassword.value
                              ? InkWell(
                                  onTap: () {
                                    signupController.visiblePassword.value =
                                        false;
                                  },
                                  child: Icon(
                                    Icons.visibility_off,
                                    size: 5.w,
                                    color: AppColors.kBlack2,
                                  ))
                              : InkWell(
                                  onTap: () {
                                    signupController.visiblePassword.value =
                                        true;
                                  },
                                  child: Icon(
                                    Icons.visibility,
                                    size: 5.w,
                                    color: AppColors.kBlack2,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 0.3.h,
                  ),
                  Container(
                    height: 5.4.h,
                    decoration: BoxDecoration(
                      color: !darkThemePreference.darkMode.value
                          ? AppColors.kWhite
                          : AppColors.kGrey,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(1.0.h),
                          bottomRight: Radius.circular(1.0.h)),
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
                              Icons.lock_outlined,
                              size: 4.w,
                              color: !darkThemePreference.darkMode.value
                                  ? AppColors.kBlack2
                                  : AppColors.kWhite,
                            )),
                        SizedBox(
                          width: 4.w,
                          height: 4.w,
                        ),
                        SizedBox(
                          width: 68.w,
                          child: TextField(
                              maxLines: 1,
                              style: !darkThemePreference.darkMode.value
                                  ? AppTextStyles.regBlackTextField12
                                  : AppTextStyles.regWhiteTextField12,
                              obscureText:
                                  signupController.visibleConfirmPassword.value,
                              controller: confirmController,
                              decoration: InputDecoration.collapsed(
                                hintText: "Repeat Password",
                                border: InputBorder.none,
                                hintStyle: !darkThemePreference.darkMode.value
                                    ? AppTextStyles.regBlackTextField12
                                    : AppTextStyles.regWhiteTextField12,
                              )),
                        ),
                        SizedBox(
                          width: 4.w,
                          height: 4.w,
                        ),
                        SizedBox(
                          width: 4.w,
                          height: 4.w,
                          child: signupController.visibleConfirmPassword.value
                              ? InkWell(
                                  onTap: () {
                                    signupController
                                        .visibleConfirmPassword.value = false;
                                  },
                                  child: Icon(
                                    Icons.visibility_off,
                                    size: 5.w,
                                    color: AppColors.kBlack2,
                                  ))
                              : InkWell(
                                  onTap: () {
                                    signupController
                                        .visibleConfirmPassword.value = true;
                                  },
                                  child: Icon(
                                    Icons.visibility,
                                    size: 5.w,
                                    color: AppColors.kBlack2,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  CustomButton(
                    color: !darkThemePreference.darkMode.value
                        ? AppColors.kBlack2
                        : AppColors.lightBlue,
                    style: AppTextStyles.regWhiteBold12,
                    text: "Sign Up",
                    height: 5.4.h,
                    loading: signupController.loading.value,
                    onPressed: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      if (usernameController.text.isEmpty) {
                        signupController.username.value = true;
                      } else if (emailController.text.isEmpty) {
                        signupController.email.value = true;
                      } else if (passwordController.text.isEmpty) {
                        signupController.password.value = true;
                      }
                      if (emailController.text.isNotEmpty &&
                          passwordController.text.isNotEmpty) {
                        if (passwordController.text == confirmController.text) {
                          signupController.signup(
                            usernameController.text.trim(),
                            emailController.text.trim(),
                            passwordController.text.trim(),
                            context,
                          );
                        } else {
                          Utils.showToasts(context, "Password is not matched");
                        }
                      }
                    },
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  SizedBox(
                    height: 3.h,
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
