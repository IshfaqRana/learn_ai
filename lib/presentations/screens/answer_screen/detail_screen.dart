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
      backgroundColor: AppColors.hardBlue,
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
          backgroundColor: AppColors.kGrey,
          centerTitle: false,
          title: Text(
            "Answer",
            style: AppTextStyles.regWhiteBold15,
          )),
      body: Padding(
        padding: EdgeInsets.all(2.h),
        child: Column(
          children: [
            SizedBox(
              height: 2.h,
            ),
            SizedBox(
              child:
                  // Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  // SizedBox(
                  //     height: 10.w,
                  //     width: 10.w,
                  //     child: Container(
                  //         decoration: BoxDecoration(
                  //             color: AppColors.kWhite,
                  //             borderRadius: BorderRadius.circular(1.w)),
                  //         child: Padding(
                  //           padding: EdgeInsets.all(2.w),
                  //           child: Image.asset(
                  //             AppImages.logo,
                  //             fit: BoxFit.fill,
                  //           ),
                  //         ))),
                  // SizedBox(
                  //   width: 2.h,
                  // ),
                  SizedBox(
                      // width: 74.w,
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: widget.chat.question!.length,
                          itemBuilder: ((context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.kGrey,
                                  borderRadius: BorderRadius.circular(1.h),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF000000)
                                          .withOpacity(0.04),
                                      blurRadius: 0.5.h,
                                      spreadRadius: 0.2.h,
                                      offset: Offset(0.5.h, 0.5.h),
                                    ),
                                    BoxShadow(
                                      color: const Color(0xFF000000)
                                          .withOpacity(0.04),
                                      blurRadius: 1.0.h,
                                      spreadRadius: 0.1.w,
                                      offset: Offset(-0.2.h, -0.2.h),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(1.h),
                                  child: Text(
                                    widget.chat.question![index],
                                    style: AppTextStyles.regWhiteBold12,
                                  ),
                                ),
                              ),
                            );
                          }))),
              // SizedBox(
              //   width: 2.w,
              // ),
              // ]),
            ),
          ],
        ),
      ),
    ));
  }
}
