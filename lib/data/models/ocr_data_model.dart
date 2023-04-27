// To parse this JSON data, do
//
//     final ocrDataModel = ocrDataModelFromJson(jsonString);

import 'dart:convert';

OcrDataModel ocrDataModelFromJson(String str) =>
    OcrDataModel.fromJson(json.decode(str));

String ocrDataModelToJson(OcrDataModel data) => json.encode(data.toJson());

class OcrDataModel {
  final bool? status;
  final int? statusCode;
  final String? message;
  final Payload? payload;

  OcrDataModel({
    this.status,
    this.statusCode,
    this.message,
    this.payload,
  });

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
  final List<String>? text;
  final String? url;

  Payload({
    this.text,
    this.url,
  });

  factory Payload.fromJson(Map<String, dynamic> json) => Payload(
        text: List<String>.from(json["text"]!.map((x) => x)),
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "text": text == null ? [] : List<dynamic>.from(text!.map((x) => x)),
        "url": url,
      };
}
