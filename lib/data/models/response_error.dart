class ErrorModel {
  ErrorModel({
    this.success,
    this.message,
  });

  final bool? success;
  final String? message;

  factory ErrorModel.fromJson(Map<String, dynamic> json) => ErrorModel(
        success: json["success"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
      };
}
