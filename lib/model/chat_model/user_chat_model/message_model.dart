import 'attachments_model.dart';

class MessageModel {
  String? message;
  AttachmentsModel? attachments;

  MessageModel({
    this.message,
    this.attachments,
  });

  MessageModel.fromJson(Map<String, dynamic> json) {
    message = json["message"] as String?;
    if (json['attachments'] != null) {
      attachments = AttachmentsModel.fromJson(
          json['attachments'] as Map<String, dynamic>);
    }
  }

  Map<String, dynamic> toJson() {
    return {
      if (message != null) "message": message,
      if (attachments != null) "attachments": attachments!.toJson(),
    };
  }
}
