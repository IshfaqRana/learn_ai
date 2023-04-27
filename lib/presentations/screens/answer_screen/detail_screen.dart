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
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: InkWell(
            onTap: () {
              Get.to(HomePageView());
            },
            child: SizedBox(
              height: 3.h,
              width: 5.w,
              child: Image.asset(AppImages.back, color: AppColors.kWhite),
            ),
          ),
          backgroundColor: AppColors.lightBlue,
          centerTitle: false,
          title: Text(
            "Answer",
            style: AppTextStyles.regWhiteBold15,
          )),
      body: Padding(
        padding: EdgeInsets.all(2.h),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // SizedBox(
              //   child: Row(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         SizedBox(
              //             height: 10.w,
              //             width: 10.w,
              //             child: Container(
              //               decoration: BoxDecoration(
              //                   color: AppColors.kGrey2,
              //                   borderRadius: BorderRadius.circular(1.w)),
              //               child: Icon(
              //                 Icons.chat_bubble,
              //                 size: 8.w,
              //                 color: AppColors.kGrey,
              //               ),
              //             )),
              //         SizedBox(
              //           width: 2.h,
              //         ),
              //         SizedBox(
              //           width: 74.w,
              //           child: Center(
              //             child: Text(
              //               widget.chat.question ?? "Question",
              //               style: AppTextStyles.regBlackTextField10,
              //             ),
              //           ),
              //         ),
              //         SizedBox(
              //           width: 2.w,
              //         ),
              //       ]),
              // ),
              SizedBox(
                height: 2.h,
              ),
              SizedBox(
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                          height: 10.w,
                          width: 10.w,
                          child: Container(
                              decoration: BoxDecoration(
                                  color: AppColors.kWhite,
                                  borderRadius: BorderRadius.circular(1.w)),
                              child: Padding(
                                padding: EdgeInsets.all(2.w),
                                child: Image.asset(
                                  AppImages.logo,
                                  fit: BoxFit.fill,
                                ),
                              ))),
                      SizedBox(
                        width: 2.h,
                      ),
                      SizedBox(
                        width: 74.w,
                        child: Text(
                          widget.chat.question ?? "Answer",
                          style: AppTextStyles.regBlack12W300,
                        ),
                      ),
                      SizedBox(
                        width: 2.w,
                      ),
                    ]),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
