import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learn_ai/utils/theme.dart';
import 'package:sizer/sizer.dart';

import '../../../data/models/chat_model.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_images.dart';
import '../../../utils/text_styles.dart';
import '../home/home_view.dart';

class DetailScreen extends StatefulWidget {
  final ChatModel chat;
  const DetailScreen({Key? key, required this.chat}) : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;
    bool darkThemePreference = brightness == Brightness.dark;
    return Scaffold(
      backgroundColor:
          !darkThemePreference ? AppColors.kWhite : AppColors.kDarkBG,
      appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: InkWell(
            onTap: () {
              Get.to(() => HomePageView());
            },
            child: SizedBox(
              height: 3.w,
              width: 3.w,
              child: Image.asset(
                AppImages.back,
                color: AppColors.orange,
                fit: BoxFit.none,
              ),
            ),
          ),
          backgroundColor:
              !darkThemePreference ? AppColors.kGrey4 : AppColors.kText2,
          centerTitle: false,
          title: Text(
            "Answer",
            style: darkThemePreference
                ? AppTextStyles.regWhiteBold15
                : AppTextStyles.regBlack15Bold,
          )),
      body: Padding(
        padding: EdgeInsets.all(0.5.h),
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: widget.chat.question!.length,
            itemBuilder: ((context, index) {
              return widget.chat.question![index] == ""
                  ? SizedBox()
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: !darkThemePreference
                              ? AppColors.kGreyToWhite
                              : AppColors.kText2,

                          // : Color(0xFF616D7E),
                          borderRadius: BorderRadius.circular(1.h),
                          border:
                              Border.all(width: .2.w, color: AppColors.orange
                                  // !darkThemePreference
                                  //     ? AppColors
                                  //         .kText2
                                  //     : AppColors
                                  //         .kGrey4,
                                  ),
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
                        child: Padding(
                          padding: EdgeInsets.all(1.h),
                          child:
                              // DefaultTextStyle(
                              //   style: !darkThemePreference
                              //       ? AppTextStyles.regBlack12Bold
                              //       : AppTextStyles.regWhiteBold12,
                              //   child:                             AnimatedTextKit(
                              //     totalRepeatCount: 1,
                              //     animatedTexts: [
                              //       TyperAnimatedText(
                              //         widget.chat.question![index],
                              //       ),
                              //     ],
                              //   ),
                              // ),
                              SelectableText(
                            widget.chat.question![index],
                            style: !darkThemePreference
                                ? AppTextStyles.regBlack12Bold
                                : AppTextStyles.regWhiteBold12,
                            toolbarOptions: ToolbarOptions(
                              copy: true,
                              selectAll: true,
                            ),
                            showCursor: true,
                            cursorWidth: 2,
                            cursorColor: Colors.red,
                            cursorRadius: Radius.circular(5),
                          ),
                        ),
                      ),
                    );
            })),
      ),
    );
  }
}
