// To parse this JSON data, do
//
//     final loginDataModel = loginDataModelFromJson(jsonString);

import 'dart:convert';

LoginDataModel loginDataModelFromJson(String str) =>
    LoginDataModel.fromJson(json.decode(str));

String loginDataModelToJson(LoginDataModel data) => json.encode(data.toJson());

class LoginDataModel {
  LoginDataModel({
    this.status,
    this.statusCode,
    this.message,
    this.payload,
  });

  final bool? status;
  final int? statusCode;
  final String? message;
  final String? payload;

  factory LoginDataModel.fromJson(Map<String, dynamic> json) => LoginDataModel(
        status: json["status"],
        statusCode: json["statusCode"],
        message: json["message"],
        payload: json["payload"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "statusCode": statusCode,
        "message": message,
        "payload": payload,
      };
}
