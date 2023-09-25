part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class ChatInitialEvent extends ChatEvent {}

class CreateChatGroupEvent extends ChatEvent {
  final ChatGroupModel chatGroup;
  final String routeName;

  //this is used to while navigating to chat
  //screen select make an offer by default
  final int selectedIndex;

  const CreateChatGroupEvent({
    required this.chatGroup,
    this.routeName = '',
    this.selectedIndex = 1,
  });
}

class InsertChatEvent extends ChatEvent {
  final UserChatModel chatModel;
  final ChatUserModel? buyer;
  final ChatUserModel? seller;
  final ChatCarModel? car;

  const InsertChatEvent(
      {required this.chatModel,
      required this.seller,
      required this.buyer,
      required this.car});
}

class UpdateOfferStatusEvent extends ChatEvent {
  final String groupId;
  final String chatDocId;
  final Map<String, dynamic> data;

  const UpdateOfferStatusEvent({
    required this.groupId,
    required this.chatDocId,
    required this.data,
  });
}

class GetMyActiveCarsEvent extends ChatEvent {
  final Map<String, dynamic> myActiveCarJson;

  const GetMyActiveCarsEvent({required this.myActiveCarJson});
}

class GetMoreMyActiveCarsEvent extends ChatEvent {
  final Map<String, dynamic> moreMyActiveCarJson;

  const GetMoreMyActiveCarsEvent({required this.moreMyActiveCarJson});
}

//UpdateChatReadStatus
class UpdateChatReadStatusEvent extends ChatEvent {
  final String groupId;
  final String chatDocId;
  final String userId;

  const UpdateChatReadStatusEvent({
    required this.groupId,
    required this.chatDocId,
    required this.userId,
  });
}
