class SendEmailResponseModel {
  SendEmailResponseModel({
    required this.code,
    required this.message,
  });

  int code;
  String message;

  factory SendEmailResponseModel.fromJson(Map<String, dynamic> json) =>
      SendEmailResponseModel(
        code: json['httpStatusCode'] as int,
        message: json['requestId'] as String,
      );

  Map<String, dynamic> toJson() => {
        'httpStatusCode': code,
        'requestId': message,
      };
}
