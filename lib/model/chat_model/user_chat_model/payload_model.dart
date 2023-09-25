import 'message_model.dart';
import 'offer_model.dart';

class PayloadModel {
  MessageModel? messageModel;
  OfferModel? offer;

  PayloadModel({
    this.offer,
    this.messageModel,
  });

  PayloadModel.fromJson(Map<String, dynamic> json) {
    if (json['offer'] != null) {
      offer = OfferModel.fromJson(json['offer'] as Map<String, dynamic>);
    }
    if (json['message'] != null) {
      messageModel =
          MessageModel.fromJson(json['message'] as Map<String, dynamic>);
    }
  }

  Map<String, dynamic> toJson() {
    return {
      if (offer != null) "offer": offer!.toJson(),
      if (messageModel != null) "message": messageModel!.toJson(),
    };
  }
}
