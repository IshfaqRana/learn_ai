import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:learn_ai/presentations/screens/login/login_controller.dart';
import 'package:learn_ai/utils/theme.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_images.dart';
import '../../../utils/app_utils.dart';
import '../../../utils/text_styles.dart';
import '../../widgets/custom_button.dart';
import '../signup/signup_view.dart';

class LoginView extends StatelessWidget {
  LoginView({Key? key}) : super(key: key);

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  LoginController loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;
    bool darkThemePreference = brightness == Brightness.dark;
    return Obx(
      () => Scaffold(
        backgroundColor:
            !darkThemePreference ? AppColors.kWhite : AppColors.kDarkBG,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(4.0.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 4.0.h,
                  ),
                  Center(
                    child: SizedBox(
                        height: 20.h,
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
                    child: RichText(
                        textAlign: TextAlign.start,
                        maxLines: 1,
                        text: TextSpan(
                            text: 'Let’s ',
                            style: !darkThemePreference
                                ? AppTextStyles.regBlack12Bold
                                : AppTextStyles.regGrey12Bold,
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'Sign ',
                                  style: TextStyle(
                                    color: AppColors.orange,
                                    fontSize: 12.sp,
                                    fontFamily: AppFont.sFDisplaySemibold,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: 'you In ',
                                      style: !darkThemePreference
                                          ? AppTextStyles.regBlack12Bold
                                          : AppTextStyles.regGrey12Bold,
                                    )
                                  ]),
                            ])),
                  ),
                  SizedBox(
                    height: 4.0.h,
                  ),
                  Container(
                    height: 5.4.h,
                    decoration: BoxDecoration(
                      color: !darkThemePreference
                          ? AppColors.kWhite
                          : AppColors.kText2,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(1.0.h),
                          topRight: Radius.circular(1.0.h)),
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
                            Ionicons.person_outline,
                            //CupertinoIcons.person,
                            size: 3.8.w,
                            color: !darkThemePreference
                                ? AppColors.kBlack2
                                : AppColors.kWhite,
                          ),
                        ),
                        SizedBox(
                          width: 4.w,
                          height: 4.w,
                        ),
                        SizedBox(
                          width: 68.w,
                          child: TextField(
                              //textAlign: TextAlign.start,
                              style: !darkThemePreference
                                  ? AppTextStyles.regBlackTextField12
                                  : AppTextStyles.regWhiteTextField12,
                              maxLines: 1,
                              controller: emailController,
                              decoration: InputDecoration.collapsed(
                                // contentPadding: EdgeInsets.symmetric(
                                //     vertical: 1.7.h, horizontal: 0.5.h),
                                hintText: "Email",

                                border: InputBorder.none,
                                hintStyle: !darkThemePreference
                                    ? AppTextStyles.regBlackTextField12
                                    : AppTextStyles.regWhiteTextField12,
                              )),
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
                      color: !darkThemePreference
                          ? AppColors.kWhite
                          : AppColors.kText2,
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
                        crossAxisAlignment: CrossAxisAlignment.center,
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
                                color: !darkThemePreference
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
                                style: !darkThemePreference
                                    ? AppTextStyles.regBlackTextField12
                                    : AppTextStyles.regWhiteTextField12,
                                obscureText: loginController.visible.value,
                                controller: passwordController,
                                textAlignVertical: TextAlignVertical.center,
                                decoration: InputDecoration.collapsed(
                                  hintText: "Password",
                                  border: InputBorder.none,
                                  hintStyle: !darkThemePreference
                                      ? AppTextStyles.regBlackTextField12
                                      : AppTextStyles.regWhiteTextField12,

                                  // suffix: SizedBox(
                                  //     height: 1.h,
                                  //     width: 1.h,
                                  //     child: Image.asset(
                                  //       AppImages.eye,
                                  //       fit: BoxFit.cover,
                                  //     )),
                                )),
                          ),
                          SizedBox(
                            width: 4.w,
                            height: 4.w,
                          ),
                          SizedBox(
                            child: loginController.visible.value
                                ? InkWell(
                                    onTap: () {
                                      loginController.visible.value = false;
                                    },
                                    child: Icon(
                                      Icons.visibility_off,
                                      size: 5.w,
                                      color: darkThemePreference
                                          ? AppColors.kWhite
                                          : AppColors.kBlack2,
                                    ))
                                : InkWell(
                                    onTap: () {
                                      loginController.visible.value = true;
                                    },
                                    child: Icon(
                                      Icons.visibility,
                                      size: 5.w,
                                      color: darkThemePreference
                                          ? AppColors.kWhite
                                          : AppColors.kBlack2,
                                    ),
                                  ),
                          )
                        ]),
                  ),
                  // SizedBox(
                  //   height: 2.0.h,
                  // ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.end,
                  //   children: [
                  //     SizedBox(
                  //       height: 2.5.h,
                  //       width: 12.w,
                  //       child: InkWell(
                  //         onTap: () {
                  //           Get.to(() => ForgetPassword());
                  //           //BlocProvider.of<AppCubits>(context).onForget();
                  //         },
                  //         child: Text(
                  //           "Forget?",
                  //           style: AppTextStyles.regBlueBold10,
                  //           textAlign: TextAlign.end,
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  SizedBox(
                    height: 5.h,
                  ),
                  CustomButton(
                    color: !darkThemePreference
                        ? AppColors.kText2
                        : AppColors.kText,
                    style: AppTextStyles.regWhiteBold12,
                    text: "Sign In",
                    height: 5.4.h,
                    loading: loginController.loading.value,
                    onPressed: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      if (emailController.text == "") {
                        Utils.showToasts(context, "Please enter email");
                      } else if (passwordController.text == "") {
                        Utils.showToasts(context, "Please enter password");
                      } else {
                        loginController.login(emailController.text.trim(),
                            passwordController.text.trim(), context);
                      }
                    },
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        height: 3.h,
                        width: 65.w,
                        child: RichText(
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            text: TextSpan(
                                text: 'Don`t have an account? ',
                                style: !darkThemePreference
                                    ? AppTextStyles.regBlack10Bold
                                    : AppTextStyles.regWhite10Bold,
                                children: <TextSpan>[
                                  TextSpan(
                                      text: 'Sign Up',
                                      style: TextStyle(
                                        color: AppColors.orange,
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Get.to(() => SignupView());
                                          // BlocProvider.of<AppCubits>(context)
                                          //     .onSignup();
                                        }),
                                ])),
                      )),
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
