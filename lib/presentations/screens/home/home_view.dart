// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:document_scanner_flutter/configs/configs.dart';
import 'package:document_scanner_flutter/document_scanner_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:learn_ai/presentations/screens/home/home_controller.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_utils.dart';
import '../../../utils/text_styles.dart';
import '../../widgets/curved_app_bar.dart';
import '../answer_screen/detail_screen.dart';
import '../login/login_view.dart';

class HomePageView extends StatefulWidget {
  HomePageView({Key? key}) : super(key: key);

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  HomeController homeController = Get.put(HomeController());
  File? scannedImage;

  @override
  void initState() {
    super.initState();
    requestCameraPermission();
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
        child: CircularProgressIndicator(
          strokeWidth: 1.w,
          valueColor: AlwaysStoppedAnimation(AppColors.lightBlue),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: homeController.loading.value
          ? Scaffold(
              body: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                        child:
                            SizedBox(height: 4.h, width: 4.h, child: loader()))
                  ]),
            )
          : SafeArea(
            child: Scaffold(
                backgroundColor: AppColors.hardBlue,
                floatingActionButton: FloatingActionButton.extended(
                  backgroundColor: AppColors.lightBlue,
                  // foregroundColor: Colors.black,
                  onPressed: () {
                    openImageScanner(context);
                  },
                  icon: Icon(
                    Icons.camera_alt,
                    size: 6.w,
                    color: AppColors.kWhite,
                  ),
                  label: const Text('Scan Assignment'),
                ),
                // drawer: Drawer(
                //   child: ListView(
                //     padding: EdgeInsets.zero,
                //     children: [
                //       DrawerHeader(
                //         decoration: BoxDecoration(
                //           color: AppColors.lightBlue,
                //         ),
                //         child: Center(
                //           child: Text(
                //             'Learn AI',
                //             style: AppTextStyles.regBlack12Bold,
                //           ),
                //         ),
                //       ),
                //       ListTile(
                //         leading: Icon(Icons.logout),
                //         title: Text(
                //           'Log out',
                //           style: AppTextStyles.regBlack10Medium,
                //         ),
                //         onTap: () async {
                //           SharedPreferences prefs =
                //               await SharedPreferences.getInstance();
                //           prefs.clear();
                //           Get.offAll(() => LoginView());
                //         },
                //       ),
                //     ],
                //   ),
                // ),
                appBar: PreferredSize(
                  preferredSize: const Size.fromHeight(kToolbarHeight + 100),
                  child: AppBar(
                    backgroundColor: AppColors.hardBlue,
                    flexibleSpace: ClipPath(
                      clipper: CustomAppBarClipper(),
                      child: Container(color: AppColors.kGrey),
                    ),
                    centerTitle: false,
                    title: Text(
                      "Learn AI",
                      style: AppTextStyles.regWhiteBold20,
                    ),
                    // centerTitle: true,
                    elevation: 0,
                    actions: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            top: 2.5.w, left: 2.5.w, right: 4.w, bottom: 2.5.w),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
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
          
                // AppBar(
                //     backgroundColor: AppColors.lightBlue,
                //     title: Text(
                //       "Learn AI",
                //       style: AppTextStyles.regBlack12Bold,
                //     )),
                body: Obx(() {
                  return SizedBox(
                    height: 87.5.h,
                    child: Padding(
                      padding: EdgeInsets.all(2.h),
                      child: homeController.chats.isEmpty
                          ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 4.h,
                                child: Text("Previuos Searches",style: AppTextStyles.regWhiteBold15,),
                              ),
                              SizedBox(
                                height: 62.h,
                                child: Center(
                                    child: Text(
                                      "Search history is empty!",
                                      style: AppTextStyles.regWhite10Bold,
                                    ),
                                  ),
                              ),
                            ],
                          )
                          : ListView.builder(
                              itemCount: homeController.chats.length,
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
                                                chat: homeController.chats[index],
                                              ));
                                        },
                                        child: Container(
                                          height: 8.h,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                width: .2.w,
                                                color: AppColors.kGrey),
                                            borderRadius:
                                                BorderRadius.circular(2.w),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.only(
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
                                                    Icons.chat_bubble,
                                                    size: 8.w,
                                                    color: AppColors.kGrey,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 2.w,
                                                ),
                                                SizedBox(
                                                  width: 64.w,
                                                  child: Text(
                                                    homeController.chats[index]
                                                            .question ??
                                                        "Question",
                                                    style: AppTextStyles
                                                        .regBlackTextField10,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
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
                                                      color: AppColors.kGrey,
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
                  );
                }),
              ),
          ),
    );
  }
}
