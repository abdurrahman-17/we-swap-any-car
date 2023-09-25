class ErrorModel {
  bool status;
  String message;
  Map<String, dynamic>? data;

  ErrorModel({
    this.status = false,
    required this.message,
    this.data,
  });
}
