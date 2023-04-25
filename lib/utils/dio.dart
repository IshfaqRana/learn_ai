import 'package:dio/dio.dart';
import 'package:dio_logging_interceptor/dio_logging_interceptor.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_utils.dart';
import 'consts.dart';
import 'error_handler.dart';

class DioUtils {
  DioUtils() {
    _dio!.interceptors.add(
      DioLoggingInterceptor(
        level: Level.body,
        compact: false,
      ),
    );
  }

  Dio? _dio = Dio();

  String baseUrl = "https://api.learnaiedu.com/api/v1";

  String buildUrl(url) {
    final String apiUrl = baseUrl + url;
    return apiUrl;
  }

  accessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken')!;
  }

  static CancelToken cancelToken = CancelToken();

  Future<dynamic> post(url, body,
      {isPrivateRoute = true, refreshToken = false}) async {
    try {
      var umOptions = BaseOptions(
          connectTimeout: 30000,
          receiveTimeout: 30000,
          baseUrl: baseUrl,
          responseType: ResponseType.json,
          contentType: Headers.jsonContentType);

      _dio = Dio(umOptions);
      _dio!.interceptors.add(
        DioLoggingInterceptor(
          level: Level.body,
          compact: false,
        ),
      );
      var response =
          await _dio!.post(url, data: body, cancelToken: cancelToken);
      //Utils.printDebug(response);

      if (response.statusCode == 200) {
        ResponseHandler handler =
            ResponseHandler(true, "success", response.data);
        return handler;
      }
    } on DioError catch (e) {
      DioExceptions.fromDioError(e).toString();

      Utils.printDebug(DioExceptions.fromDioError(e).toString());

      Utils.printDebug(e.response?.statusCode);
      return ResponseHandler(false, DioExceptions.fromDioError(e).toString(),
          e.response == null ? "No response" : e.response!.data);
    }
  }

  Future<dynamic> patch(url, body,
      {isPrivateRoute = true, refreshToken = false}) async {
    if (cancelToken.isCancelled) {
      cancelToken = CancelToken();
    }

    try {
      var umOptions = BaseOptions(
          connectTimeout: 25000,
          receiveTimeout: 25000,
          baseUrl: baseUrl,
          responseType: ResponseType.json,
          contentType: Headers.jsonContentType);

      _dio = Dio(umOptions);
      _dio!.interceptors.add(
        DioLoggingInterceptor(
          level: Level.body,
          compact: false,
        ),
      );
      var response =
          await _dio!.patch(url, data: body, cancelToken: cancelToken);
      //Utils.printDebug(response);

      if (response.statusCode == 200) {
        ResponseHandler handler =
            ResponseHandler(true, "success", response.data);
        return handler;
      }
    } on DioError catch (e) {
      DioExceptions.fromDioError(e).toString();

      Utils.printDebug(DioExceptions.fromDioError(e).toString());

      Utils.printDebug(e.response?.statusCode);
      return ResponseHandler(
          false, DioExceptions.fromDioError(e).toString(), e.response!.data);
    }
  }

  Future<dynamic> get(url, {isPrivateRoute = true}) async {
    if (cancelToken.isCancelled) {
      cancelToken = CancelToken();
    }
    try {
      if (isPrivateRoute) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var token = prefs.getString('accessToken')!;
        Utils.printDebug(token);
        var umOptions = BaseOptions(
            connectTimeout: 25000,
            receiveTimeout: 25000,
            baseUrl: baseUrl,
            headers: {"Authorization": "Bearer $token"},
            responseType: ResponseType.json,
            contentType: Headers.jsonContentType);
        _dio = Dio(umOptions);
      } else {
        var umOptions = BaseOptions(
            baseUrl: baseUrl,
            responseType: ResponseType.json,
            contentType: Headers.jsonContentType);
        _dio = Dio(umOptions);
      }
      _dio!.interceptors.add(
        DioLoggingInterceptor(
          level: Level.basic,
          compact: false,
        ),
      );

      var response = await _dio!.get(url, cancelToken: cancelToken);
      if (response.statusCode == 200) {
        ResponseHandler handler =
            ResponseHandler(true, "success", response.data);
        return handler;
      }
    } on DioError catch (e) {
      DioExceptions.fromDioError(e).toString();
      return ResponseHandler(false, e.response!.statusMessage!, null);
    }
  }
}
