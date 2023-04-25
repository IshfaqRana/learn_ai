import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image/image.dart' as img;
import 'package:sizer/sizer.dart';

import 'app_colors.dart';
import 'custom_toast.dart';
import 'dio.dart';

class ResponseHandler {
  ResponseHandler(this.success, this.message, this.data);

  bool success;
  String message;
  dynamic data;
}

class SortedValues {
  SortedValues(this.sortBy, this.sortValue);
  int sortValue;
  String sortBy;
}

class Utils {
  static printDebug(data) {
    if (kDebugMode) {
      print(data);
    }
  }

  static SortedValues sort(String value) {
    if (value == "Market Value (Highest)") {
      return SortedValues("market_value", -1);
    } else if (value == "Market Value (Lowest)") {
      return SortedValues("market_value", 1);
    } else if (value == "Year Value (Highest)") {
      return SortedValues("year_built", -1);
    } else if (value == "Year Value (Lowest)") {
      return SortedValues("year_built", 1);
    } else if (value == "Land Area (Highest)") {
      return SortedValues("area", -1);
    } else if (value == "Land Area (Lowest)") {
      return SortedValues("area", 1);
    } else if (value == "Land Value (Highest)") {
      return SortedValues("land_value", -1);
    } else if (value == "Land Value (Lowest)") {
      return SortedValues("land_value", 1);
    } else if (value == "Improvement Value (Highest)") {
      return SortedValues("improvement_value", -1);
    } else if (value == "Improvement Value (Lowest)") {
      return SortedValues("improvement_value", 1);
    } else if (value == "Sale Date (Highest)") {
      return SortedValues("sale_date", -1);
    } else if (value == "Sale Date (Lowest)") {
      return SortedValues("sale_date", 1);
    } else if (value == "Most Recent") {
      return SortedValues("created_at", 1);
    } else if (value == "Value Up") {
      return SortedValues("market_value", 1);
    } else if (value == "Value Down") {
      return SortedValues("market_value", -1);
    } else {
      return SortedValues("market_value", -1);
    }
  }

  loader() => SizedBox(
        height: 15,
        width: 15,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation(AppColors.kWhite),
        ),
      );

  static int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  static Future<File> convertImage(File imageFile) async {
    final Uint8List imageData = await imageFile.readAsBytes();
    final Uint8List compressedData =
        await FlutterImageCompress.compressWithList(
      imageData,
      format: CompressFormat.png,
    );
    final String path = imageFile.path.replaceAll(RegExp(r'\.jpg$'), '.png');
    final File compressedFile = File(path);
    await compressedFile.writeAsBytes(compressedData);
    return compressedFile;
  }

  static Future<File> compressImage(File file) async {
    img.Image? image = img.decodeImage(file.readAsBytesSync());
    img.Image? smallerImage = img.copyResize(image!,
        width: 800); // Adjust the width as per your requirement
    return File(file.path)
      ..writeAsBytesSync(img.encodeJpg(smallerImage,
          quality: 10)); // Adjust the quality as per your requirement
  }

  static FToast fToast = FToast();

  static Widget toast(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.greenAccent,
      ),
      child: Text(text),
    );
  }

  static successToast(BuildContext context, String msg) {
    showToastWidget(IconToastWidget.success(msg: msg),
        context: context,
        position: StyledToastPosition.center,
        animation: StyledToastAnimation.scale,
        reverseAnimation: StyledToastAnimation.fade,
        duration: const Duration(seconds: 4),
        animDuration: const Duration(seconds: 1),
        curve: Curves.elasticOut,
        reverseCurve: Curves.linear);
  }

  static failToast(BuildContext context, String msg) {
    showToastWidget(
        IconToastWidget.fail(
          msg: msg,
        ),
        context: context,
        position: StyledToastPosition.center,
        animation: StyledToastAnimation.scale,
        reverseAnimation: StyledToastAnimation.fade,
        duration: const Duration(seconds: 4),
        animDuration: const Duration(seconds: 1),
        curve: Curves.elasticOut,
        reverseCurve: Curves.linear);
  }

  static showNormalToasts(String text) {
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      fontSize: 16.0,
    );
  }

  static showToasts(BuildContext context, String text) {
    showToast(
      text,
      context: context,
      axis: Axis.horizontal,
      alignment: Alignment.bottomCenter,
      position: StyledToastPosition.bottom,
      duration: const Duration(seconds: 5),
    );
  }

  static snackBar(String? text) {
    printDebug("Your OTP is: $text");
    Get.snackbar("Your OTP is:", text ?? "Hi",
        duration: const Duration(seconds: 10));
  }

  static Future<ResponseHandler> responseError(response) async {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        return ResponseHandler(true, "success", responseJson);
      case 400:
        return ResponseHandler(false, "Bad Request Error", null);
      case 403:
        return ResponseHandler(false, "Fobidden", null);
      case 401:
        return ResponseHandler(false, "Unauthorised Request Error", null);
      case 422:
        return ResponseHandler(false, "Validation Error", null);
      default:
        return ResponseHandler(
            false, "Oops something went wrong ${response.statusCode}", null);
    }
  }
}
