// To parse this JSON data, do
//
//     final getJwtTokenDataModel = getJwtTokenDataModelFromJson(jsonString);

import 'dart:convert';

GetJwtTokenDataModel getJwtTokenDataModelFromJson(String str) =>
    GetJwtTokenDataModel.fromJson(json.decode(str));

String getJwtTokenDataModelToJson(GetJwtTokenDataModel data) =>
    json.encode(data.toJson());

class GetJwtTokenDataModel {
  GetJwtTokenDataModel({
    this.status,
    this.statusCode,
    this.message,
    this.payload,
  });

  final bool? status;
  final int? statusCode;
  final String? message;
  final String? payload;

  factory GetJwtTokenDataModel.fromJson(Map<String, dynamic> json) =>
      GetJwtTokenDataModel(
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
