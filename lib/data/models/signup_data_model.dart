// To parse this JSON data, do
//
//     final signupDataModel = signupDataModelFromJson(jsonString);

import 'dart:convert';

SignupDataModel signupDataModelFromJson(String str) =>
    SignupDataModel.fromJson(json.decode(str));

String signupDataModelToJson(SignupDataModel data) =>
    json.encode(data.toJson());

class SignupDataModel {
  SignupDataModel({
    this.status,
    this.statusCode,
    this.message,
    this.payload,
  });

  final bool? status;
  final int? statusCode;
  final String? message;
  final Payload? payload;

  factory SignupDataModel.fromJson(Map<String, dynamic> json) =>
      SignupDataModel(
        status: json["status"],
        statusCode: json["statusCode"],
        message: json["message"],
        payload:
            json["payload"] == null ? null : Payload.fromJson(json["payload"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "statusCode": statusCode,
        "message": message,
        "payload": payload?.toJson(),
      };
}

class Payload {
  Payload({
    this.jwt,
  });

  final String? jwt;

  factory Payload.fromJson(Map<String, dynamic> json) => Payload(
        jwt: json["jwt"],
      );

  Map<String, dynamic> toJson() => {
        "jwt": jwt,
      };
}
