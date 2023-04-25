// To parse this JSON data, do
//
//     final ocrDataModel = ocrDataModelFromJson(jsonString);

import 'dart:convert';

OcrDataModel ocrDataModelFromJson(String str) =>
    OcrDataModel.fromJson(json.decode(str));

String ocrDataModelToJson(OcrDataModel data) => json.encode(data.toJson());

class OcrDataModel {
  OcrDataModel({
    this.status,
    this.statusCode,
    this.message,
    this.payload,
  });

  final bool? status;
  final int? statusCode;
  final String? message;
  final Payload? payload;

  factory OcrDataModel.fromJson(Map<String, dynamic> json) => OcrDataModel(
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
    this.text,
    this.url,
  });

  final String? text;
  final String? url;

  factory Payload.fromJson(Map<String, dynamic> json) => Payload(
        text: json["text"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "text": text,
        "url": url,
      };
}
