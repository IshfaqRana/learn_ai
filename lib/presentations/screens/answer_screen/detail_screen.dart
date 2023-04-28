import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.hardBlue,
      appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: InkWell(
            onTap: () {
              Get.to(() => HomePageView());
            },
            child: SizedBox(
              height: 3.h,
              width: 5.w,
              child: Image.asset(AppImages.back, color: AppColors.kWhite),
            ),
          ),
          backgroundColor: AppColors.kGrey,
          centerTitle: false,
          title: Text(
            "Answer",
            style: AppTextStyles.regWhiteBold15,
          )),
      body: Padding(
        padding: EdgeInsets.all(2.h),
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
                          color: AppColors.kGrey,
                          borderRadius: BorderRadius.circular(1.h),
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
                          child: DefaultTextStyle(
                            style: AppTextStyles.regWhiteBold12,
                            child: AnimatedTextKit(
                              totalRepeatCount: 1,
                              animatedTexts: [
                                TyperAnimatedText(
                                  widget.chat.question![index],
                                ),
                              ],
                            ),
                          ),
                          // Text(
                          //   widget.chat.question![index],
                          //   style: AppTextStyles.regWhiteBold12,
                          // ),
                        ),
                      ),
                    );
            })),
      ),
    );
  }
}
