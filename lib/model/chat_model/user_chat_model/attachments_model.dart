import 'single_attachment_model.dart';

class AttachmentsModel {
  List<SingleAttachmentModel> documents = [];
  List<SingleAttachmentModel> images = [];
  List<SingleAttachmentModel> videos = [];

  AttachmentsModel({
    this.documents = const [],
    this.images = const [],
    this.videos = const [],
  });

  AttachmentsModel.fromJson(Map<String, dynamic> json) {
    if (json['documents'] != null) {
      for (final item in json['documents'] as List) {
        documents
            .add(SingleAttachmentModel.fromJson(item as Map<String, dynamic>));
      }
    }
    if (json['images'] != null) {
      for (final item in json['images'] as List) {
        images
            .add(SingleAttachmentModel.fromJson(item as Map<String, dynamic>));
      }
    }
    if (json['videos'] != null) {
      for (final item in json['videos'] as List) {
        videos
            .add(SingleAttachmentModel.fromJson(item as Map<String, dynamic>));
      }
    }
  }
  Map<String, dynamic> toJson() {
    Map<String, dynamic> attachments = {};
    if (images.isNotEmpty) {
      List<dynamic> temp = [];
      for (var element in images) {
        temp.add(element.toJson());
      }
      attachments['images'] = temp;
    }
    if (videos.isNotEmpty) {
      List<dynamic> temp = [];
      for (var element in videos) {
        temp.add(element.toJson());
      }
      attachments['videos'] = temp;
    }
    if (documents.isNotEmpty) {
      List<dynamic> temp = [];
      for (var element in documents) {
        temp.add(element.toJson());
      }
      attachments['documents'] = temp;
    }
    return attachments;
  }
}
