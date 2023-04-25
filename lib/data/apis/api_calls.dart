// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio_logging_interceptor/dio_logging_interceptor.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../../utils/app_utils.dart';
import '../../utils/dio.dart';
import '../models/get_token_data_model.dart';
import '../models/login_data_model.dart';
import '../models/ocr_data_model.dart';
import '../models/response_error.dart';
import '../models/signup_data_model.dart';

class APIServices {
  DioUtils dioUtils = DioUtils();

  Future<LoginDataModel> loginUser(
      String email, String password, BuildContext context) async {
    ResponseHandler response = await dioUtils.post(
        "/Auth", {"email": email, "password": password},
        isPrivateRoute: false);
    Utils.printDebug("Response");
    Utils.printDebug(response.data);
    if (response.data != null && response.data != "No response") {
      if (LoginDataModel.fromJson(response.data).payload == "User not found") {
        var user = ErrorModel.fromJson(response.data);
        Utils.printDebug(user.message);
        Utils.showToasts(context, "Incorrect Credentials");
        return LoginDataModel(message: response.message, status: false);
      } else {
        return LoginDataModel.fromJson(response.data);
      }
    } else {
      Utils.showToasts(context, "Request Timeout");
      return LoginDataModel(message: "Request Timeout", status: false);
    }
  }

  Future<SignupDataModel> createAccount(String username, String email,
      String password, BuildContext context) async {
    ResponseHandler response = await dioUtils.post("/account",
        {"username": username, "email": email, "password": password},
        isPrivateRoute: false);
    if (response.data != null || response.data != "No response") {
      if (!response.success) {
        var user = ErrorModel.fromJson(response.data);
        Utils.printDebug(user.message);
        Utils.showToasts(context, user.message!);
        return SignupDataModel(message: response.message, status: false);
      } else {
        return SignupDataModel.fromJson(response.data);
      }
    } else {
      Utils.showToasts(context, "Request Timeout");
      return SignupDataModel(message: "Request Timeout", status: false);
    }
  }

  Future<GetJwtTokenDataModel> getToken(
      String email, String password, BuildContext context) async {
    ResponseHandler response = await dioUtils.post(
        "/Auth/get-jwt-token", {"email": email, "password": password},
        isPrivateRoute: false);
    if (response.data != null || response.data != "No response") {
      if (!response.success) {
        var user = ErrorModel.fromJson(response.data);
        Utils.printDebug(user.message);
        Utils.showToasts(context, user.message!);
        return GetJwtTokenDataModel(message: response.message, status: false);
      } else {
        return GetJwtTokenDataModel.fromJson(response.data);
      }
    } else {
      Utils.showToasts(context, "Request Timeout");
      return GetJwtTokenDataModel(message: "Request Timeout", status: false);
    }
  }

  Future<OcrDataModel> getAnswer(File file, BuildContext context) async {
    Dio? dio = Dio();
    var umOptions = BaseOptions(
      baseUrl: "https://api.learnaiedu.com/api/v1",
      headers: {
        "Content-Type": "multipart/form-data",
      },
      responseType: ResponseType.json,
      contentType: "multipart/form-data",
    );
    dio = Dio(umOptions);
    dio.interceptors.add(
      DioLoggingInterceptor(
        level: Level.body,
        compact: false,
      ),
    );
    try {
      FormData formData = FormData.fromMap({
        "image": await MultipartFile.fromFile(
          file.path,
          filename: file.path.split("/").last,
          contentType: MediaType("image", "png"),
        ),
        "type": "image/png"
      });

      Response response = await dio.post(
        "/ocr",
        data: formData,
        options: Options(
          contentType: "multipart/form-data",
        ),
      );

      print(response);

      if (response.statusCode != 200) {
        var user = ErrorModel.fromJson(response.data);
        Utils.printDebug(user.message);
        Utils.showToasts(context, user.message!);
        return OcrDataModel(message: user.message, status: false);
      } else {
        return OcrDataModel.fromJson(response.data);
      }
    } on DioError catch (e) {
      print(e.response?.statusCode);
      return OcrDataModel(message: e.message);
    }
  }

  final Uri postUri = Uri.parse('https://api.learnaiedu.com/api/v1/ocr');

  Future<void> postImage(File imageFile) async {
    final request = http.MultipartRequest('POST', postUri);
    Utils.printDebug("Image size : ${imageFile.path}");
    List<int> bytes = await imageFile.readAsBytes();
    request.headers.addAll({
      'Content-Type': 'multipart/form-data',
    });
    request.files.add(http.MultipartFile.fromBytes(
      'image',
      bytes,
      // contentType: MediaType("image", "jpeg"),
    ));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      Utils.printDebug(response);
    } else {
      print('Upload failed with status: ${response.statusCode}.');
    }
  }
}
