class ResponseModel {
  ResponseModel({
    required this.code,
    required this.message,
  });

  String code;
  String message;

  factory ResponseModel.fromJson(Map<String, dynamic> json) => ResponseModel(
        code: json['code'] as String,
        message: json['message'] as String,
      );

  Map<String, dynamic> toJson() => {
        'code': code,
        'message': message,
      };
}
