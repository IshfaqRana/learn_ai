// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:document_scanner_flutter/configs/configs.dart';
import 'package:document_scanner_flutter/document_scanner_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learn_ai/presentations/screens/home/home_controller.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_utils.dart';
import '../../../utils/text_styles.dart';
import '../../../utils/theme.dart';
import '../../widgets/curved_app_bar.dart';
import '../answer_screen/detail_screen.dart';
import '../login/login_view.dart';

class HomePageView extends StatefulWidget {
  HomePageView({Key? key}) : super(key: key);

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late TabController _tabController;
  late PageController pageController;
  HomeController homeController = Get.put(HomeController());

  File? scannedImage;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    pageController = PageController(
      initialPage: 0,
    );
    super.initState();
    requestCameraPermission();
  }

  @override
  void dispose() {
    _tabController.dispose();
    pageController.dispose();
    super.dispose();
  }

  Future<void> requestCameraPermission() async {
    final status = await Permission.camera.request();
    if (status == PermissionStatus.granted) {
      // permission granted

    } else if (status == PermissionStatus.denied) {
      // permission not granted
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Camera permission not granted'),
          content: Text('Please grant camera permission to use the camera.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> requestStoragePermission() async {
    bool isGranted = await Permission.storage.isGranted;
    if (isGranted) {
      Utils.printDebug("permission granted");
    } else {
      // permission not granted
      var status = await Permission.storage.request();
    }
  }

// Pick an image.

  openImageScanner(BuildContext context) async {
    var image = await DocumentScannerFlutter.launch(context,
        source: ScannerFileSource.CAMERA,
        labelsConfig: {
          ScannerLabelsConfig.ANDROID_NEXT_BUTTON_LABEL: "Next Step",
          ScannerLabelsConfig.ANDROID_OK_LABEL: "OK"
        });
    // final CompressImagesFlutter compressImagesFlutter = CompressImagesFlutter();

    if (image != null) {
      scannedImage = image;
      File file = File(scannedImage!.path);

      Utils.printDebug("Image size : ${scannedImage!.path}");
      Utils.printDebug("Image size : ${scannedImage!.readAsBytes()}");
      File compressedPhoto = await Utils.compressImage(file);
      File converted = await Utils.convertImage(compressedPhoto);

      Utils.printDebug("Image format : ${compressedPhoto.path}");
      Utils.printDebug("Image format : ${converted.path}");
      final bytes = (await converted.readAsBytes()).lengthInBytes;
      final kb = bytes / 1024;
      Utils.printDebug("Image Size : $kb");

      homeController.getAnswer(converted.path, context);
      setState(() {});
    }
  }

  loader(darkThemePreference) => SizedBox(
        height: 15,
        width: 15,
        child: LoadingAnimationWidget.staggeredDotsWave(
          color: darkThemePreference ? Colors.white : AppColors.lightBlue,
          // rightDotColor: Colors.yellow,
          size: 10.w,
        ),
        // Platform.isIOS
        //     ? CupertinoActivityIndicator(
        //         radius: 25,
        //         color: AppColors.kWhite,
        //       )
        //     : CircularProgressIndicator(
        //         strokeWidth: 1.w,
        //         valueColor: AlwaysStoppedAnimation(AppColors.kGrey),
        //       ),
      );

  double _xOffset = 0.0;

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    if (_xOffset < 0 || details.delta.dx < 0) {
      setState(() {
        _xOffset += details.delta.dx;
        Utils.printDebug(_xOffset);
        // if(_xOffset < -)
      });
    }
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (_xOffset < -200) {
      openImageScanner(context);
    }
    setState(() {
      _xOffset = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;
    bool darkThemePreference = brightness == Brightness.dark;
    return Obx(() {
      return homeController.loading.value
          ? Scaffold(
              backgroundColor:
                  !darkThemePreference ? AppColors.kWhite : AppColors.kDarkBG,
              body: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                        child: SizedBox(
                            height: 5.h,
                            width: 5.h,
                            child: loader(darkThemePreference)))
                  ]),
            )
          : Scaffold(
              backgroundColor:
                  !darkThemePreference ? AppColors.kWhite : AppColors.kDarkBG,
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(kToolbarHeight + 100),
                child: AppBar(
                  backgroundColor: !darkThemePreference
                      ? AppColors.kWhite
                      : AppColors.kDarkBG,
                  flexibleSpace: Stack(
                    children: [
                      ClipPath(
                        clipper: CustomAppBarClipper(),
                        child: Container(
                            height:  25.h+.5.w,
                            // clipBehavior: Clip.antiAlias,
                            color: AppColors.orange),
                      ),
                      ClipPath(
                        clipper: CustomAppBarClipper(),
                        child: Container(
                          height: 25.h,
                          // clipBehavior: Clip.antiAlias,
                          // color: AppColors.orange
                          color: darkThemePreference
                              ? AppColors.kText2
                              : AppColors.kGrey4,
                        ),
                      ),
                    ],
                  ),
                  foregroundColor:
                      darkThemePreference ? AppColors.kText2 : AppColors.kGrey4,
                  centerTitle: false,
                  title: RichText(
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      text: TextSpan(
                          text: 'Learn ',
                          style: AppTextStyles.regOrangeBold20,
                          // !darkThemePreference
                          //     ? AppTextStyles.regBlack10Bold
                          //     : AppTextStyles.regWhite10Bold,
                          children: <TextSpan>[
                            TextSpan(
                              text: 'AI',
                              style: !darkThemePreference
                                  ? TextStyle(
                                      color: AppColors.kBlack1,
                                      fontSize: 25.sp,
                                      // fontWeight: FontWeight.bold,
                                      fontFamily: AppFont.railsDislay,
                                    )
                                  : AppTextStyles.regAIWhiteBold20,
                            ),
                          ])),

                  // Row(
                  //   children: [
                  //     Text(
                  //       "Learn",
                  //       style: AppTextStyles.regOrangeBold20,
                  //     ),
                  //     Text(
                  //       " AI",
                  // style: !darkThemePreference
                  //     ? AppTextStyles.regAIBlackBold20
                  //     : AppTextStyles.regAIWhiteBold20,
                  //     ),
                  //   ],
                  // ),
                  elevation: 0,
                  actions: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                          top: 2.5.w, left: 2.w, right: 4.w, bottom: 2.5.w),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: !darkThemePreference
                              ? AppColors.kText2
                              : AppColors.kGrey3,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                                width: .2.w, color: AppColors.orange),
                            borderRadius: BorderRadius.circular(6.h),
                          ),
                        ),
                        onPressed: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.clear();
                          Get.offAll(() => LoginView());
                        },
                        child: Text(
                          'Logout',
                          style: TextStyle(
                            color: AppColors.kWhite,
                            fontFamily: AppFont.sFDisplayBold,
                            fontSize: 13.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                  automaticallyImplyLeading: false,
                ),
              ),
              body: GestureDetector(
                onHorizontalDragUpdate: _onHorizontalDragUpdate,
                onHorizontalDragEnd: _onHorizontalDragEnd,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  transform: Matrix4.translationValues(_xOffset, 0, 0),
                  child: Stack(
                    children: [
                      SizedBox(
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: 2.h, bottom: 2.h, left: 2.5.w, right: 2.5.w),
                          child: homeController.chats.isEmpty
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 4.h,
                                      child: Text(
                                        "Previous Searches",
                                        style: !darkThemePreference
                                            ? AppTextStyles.regBlack12Bold
                                            : AppTextStyles.regWhiteBold12,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 62.h,
                                      child: Center(
                                        child: DefaultTextStyle(
                                          style: !darkThemePreference
                                              ? AppTextStyles.regBlack10Bold
                                              : AppTextStyles.regWhite10Bold,
                                          child: AnimatedTextKit(
                                            totalRepeatCount: 1,
                                            animatedTexts: [
                                              TyperAnimatedText(
                                                "Search history is empty!",
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 4.h,
                                      child: Text(
                                        "Previuos Searches",
                                        style: !darkThemePreference
                                            ? AppTextStyles.regBlack12Bold
                                            : AppTextStyles.regWhiteBold12,
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 66.h,
                                      child: ListView.builder(
                                          itemCount:
                                              homeController.chats.length,
                                          itemBuilder: ((context, index) {
                                            return SizedBox(
                                              height: 10.h,
                                              child: Column(
                                                children: [
                                                  SizedBox(
                                                    height: 1.h,
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      Get.to(() => DetailScreen(
                                                            chat: homeController
                                                                .chats[index],
                                                          ));
                                                    },
                                                    child: Container(
                                                      height: 8.h,
                                                      decoration: BoxDecoration(
                                                        color: darkThemePreference
                                                            ? AppColors.kDarkBG
                                                            : AppColors
                                                                .kGreyToWhite,
                                                        border: Border.all(
                                                            width: .2.w,
                                                            color:
                                                                AppColors.orange
                                                            // !darkThemePreference
                                                            //     ? AppColors
                                                            //         .kText2
                                                            //     : AppColors
                                                            //         .kGrey4,
                                                            ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(2.w),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 2.w,
                                                                right: 2.w,
                                                                top: 1.w,
                                                                bottom: 1.w),
                                                        child: Row(
                                                          children: [
                                                            SizedBox(
                                                              height: 4.h,
                                                              width: 10.w,
                                                              child: Icon(
                                                                  Icons
                                                                      .chat_bubble,
                                                                  size: 8.w,
                                                                  color: !darkThemePreference
                                                                      ? AppColors
                                                                          .kText2
                                                                      : AppColors
                                                                          .kGreyToWhite),
                                                            ),
                                                            SizedBox(
                                                              width: 2.w,
                                                            ),
                                                            SizedBox(
                                                              width: 64.w,
                                                              child:
                                                                  DefaultTextStyle(
                                                                style: !darkThemePreference
                                                                    ? AppTextStyles
                                                                        .regBlack10
                                                                    : AppTextStyles
                                                                        .regWhite10,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 1,
                                                                child:
                                                                    AnimatedTextKit(
                                                                  totalRepeatCount:
                                                                      1,
                                                                  animatedTexts: [
                                                                    TyperAnimatedText(
                                                                      homeController
                                                                          .chats[
                                                                              index]
                                                                          .question![0],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 2.w,
                                                            ),
                                                            SizedBox(
                                                              height: 4.h,
                                                              width: 10.w,
                                                              child: InkWell(
                                                                onTap: () {
                                                                  homeController
                                                                      .deleteQuestion(
                                                                          homeController
                                                                              .chats[index]);
                                                                },
                                                                child: Icon(
                                                                  Icons.delete,
                                                                  size: 8.w,
                                                                  color: !darkThemePreference
                                                                      ? AppColors
                                                                          .kText2
                                                                      : AppColors
                                                                          .kGreyToWhite,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 1.h,
                                                  )
                                                ],
                                              ),
                                            );
                                          })),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: SizedBox(
                          height: 8.h,
                          child: RichText(
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              text: TextSpan(
                                  text: 'Swipe Left to ',
                                  style: !darkThemePreference
                                      ? AppTextStyles.regBlack12Bold
                                      : AppTextStyles.regGrey12Bold,
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: 'Scan ',
                                        style: TextStyle(
                                          color: AppColors.orange,
                                          fontSize: 12.sp,
                                          fontFamily: AppFont.sFDisplaySemibold,
                                        ),
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: 'Document ',
                                            style: !darkThemePreference
                                                ? AppTextStyles.regBlack12Bold
                                                : AppTextStyles.regGrey12Bold,
                                          )
                                        ]),
                                  ])),
                        ),
                      ),
                    ],
                  ),
                ),
                // Container(
                //   color: !darkThemePreference
                //       ? AppColors.kWhite
                //       : AppColors.kBlack2,
                //   child: Center(
                //     child: Builder(builder: (BuildContext context) {
                //       openImageScanner(context);
                //       return Stack(
                //         children: [
                //           Align(
                //               alignment: Alignment.bottomCenter,
                //             child: SizedBox(
                //               height: 8.h,
                //               child: RichText(
                //                                   textAlign: TextAlign.center,
                //                                   maxLines: 1,
                //                                   text: TextSpan(
                //                                       text: '<<< Swipe Right for ',
                //                                       style: !darkThemePreference
                //                           ? AppTextStyles.regBlack12Bold
                //                           : AppTextStyles.regGrey12Bold,

                //                                       children: <TextSpan>[
                //               TextSpan(
                //                 text: 'Home ',
                //                 style: TextStyle(
                //                 color: AppColors.orange,
                //                 fontSize: 12.sp,
                //                 fontFamily: AppFont.sFDisplaySemibold,
                //               ),

                //               children: <TextSpan>[
                //                                         TextSpan(
                //                                       text: 'Page ',
                //                                       style: !darkThemePreference
                //                           ? AppTextStyles.regBlack12Bold
                //                           : AppTextStyles.regGrey12Bold,
                //                                         )
                //               ]
                //               ),
                //                                       ])),
                //             ),
                //           ),

                // Align(
                //     alignment: Alignment.bottomCenter,
                //     child: SizedBox(
                //       height: 8.h,
                //       child: Text(
                //         "<<< Swipe Right for Home Page",
                //         style: !darkThemePreference
                //             ? AppTextStyles.regBlack12Bold
                //             : AppTextStyles.regGrey12Bold,
                //       ),
                //     ))
                //         ],
                //       );
                //     }),
                //   ),
                // ),
                // ],
              ),
            );
    });
  }
}
