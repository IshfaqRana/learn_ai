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
  DarkThemePreference darkThemePreference = Get.put(DarkThemePreference());
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

  loader() => SizedBox(
        height: 15,
        width: 15,
        child: LoadingAnimationWidget.staggeredDotsWave(
          color: darkThemePreference.darkMode.value
              ? Colors.white
              : AppColors.lightBlue,
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

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return homeController.loading.value
          ? Scaffold(
              backgroundColor: !darkThemePreference.darkMode.value
                  ? AppColors.kWhite
                  : AppColors.kBlack2,
              body: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                        child:
                            SizedBox(height: 5.h, width: 5.h, child: loader()))
                  ]),
            )
          : Scaffold(
              backgroundColor: !darkThemePreference.darkMode.value
                  ? AppColors.kWhite
                  : AppColors.kBlack2,
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(kToolbarHeight + 100),
                child: AppBar(
                  backgroundColor: !darkThemePreference.darkMode.value
                      ? AppColors.kWhite
                      : AppColors.kBlack2,
                  flexibleSpace: ClipPath(
                    clipper: CustomAppBarClipper(),
                    child: Container(
                      color: darkThemePreference.darkMode.value
                          ? AppColors.kText2
                          : AppColors.kGrey4,
                    ),
                  ),
                  centerTitle: false,
                  title: Text(
                    "Learn AI",
                    style: !darkThemePreference.darkMode.value
                        ? AppTextStyles.regBlackBold20
                        : AppTextStyles.regWhiteBold20,
                  ),
                  elevation: 0,
                  actions: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                          top: 2.5.w, left: 2.w, right: 1.w, bottom: 2.5.w),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: !darkThemePreference.darkMode.value
                              ? AppColors.kText2
                              : AppColors.kGrey3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.h),
                          ),
                        ),
                        onPressed: () async {
                          if (darkThemePreference.darkMode.value) {
                            darkThemePreference.setDarkTheme(false);
                          } else {
                            darkThemePreference.setDarkTheme(true);
                          }
                        },
                        child: Text(
                          !darkThemePreference.darkMode.value
                              ? 'Dark'
                              : "Light",
                          style: TextStyle(
                            color: AppColors.kWhite,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: 2.5.w, left: 2.w, right: 4.w, bottom: 2.5.w),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: !darkThemePreference.darkMode.value
                              ? AppColors.kText2
                              : AppColors.kGrey3,
                          shape: RoundedRectangleBorder(
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
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                  automaticallyImplyLeading: false,
                ),
              ),
              body: PageView(
                controller: pageController,
                children: [
                  Stack(
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
                                        "Previuos Searches",
                                        style:
                                            !darkThemePreference.darkMode.value
                                                ? AppTextStyles.regBlack12Bold
                                                : AppTextStyles.regWhiteBold12,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 62.h,
                                      child: Center(
                                        child: DefaultTextStyle(
                                          style: !darkThemePreference
                                                  .darkMode.value
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
                                        style:
                                            !darkThemePreference.darkMode.value
                                                ? AppTextStyles.regBlack12Bold
                                                : AppTextStyles.regWhiteBold12,
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 68.h,
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
                                                                .darkMode.value
                                                            ? AppColors.kBlack2
                                                            : AppColors
                                                                .kGreyToWhite,
                                                        border: Border.all(
                                                          width: .2.w,
                                                          color:
                                                              !darkThemePreference
                                                                      .darkMode
                                                                      .value
                                                                  ? AppColors
                                                                      .kText2
                                                                  : AppColors
                                                                      .kGrey4,
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
                                                                          .darkMode
                                                                          .value
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
                                                                        .darkMode
                                                                        .value
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
                                                                          .darkMode
                                                                          .value
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
                            child: Text(
                              "Swipe left to Scan Document >>>",
                              style: !darkThemePreference.darkMode.value
                                  ? AppTextStyles.regBlack12Bold
                                  : AppTextStyles.regGrey12Bold,
                            ),
                          ))
                    ],
                  ),
                  Container(
                    color: !darkThemePreference.darkMode.value
                        ? AppColors.kWhite
                        : AppColors.kBlack2,
                    child: Center(
                      child: Builder(builder: (BuildContext context) {
                        openImageScanner(context);
                        return Stack(
                          children: [
                            Align(
                                alignment: Alignment.bottomCenter,
                                child: SizedBox(
                                  height: 8.h,
                                  child: Text(
                                    "<<< Swipe Right for Home Page",
                                    style: !darkThemePreference.darkMode.value
                                        ? AppTextStyles.regBlack12Bold
                                        : AppTextStyles.regGrey12Bold,
                                  ),
                                ))
                          ],
                        );
                      }),
                    ),
                  ),
                ],
              ),
            );
    });
  }
}
