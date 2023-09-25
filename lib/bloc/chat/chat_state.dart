part of 'chat_bloc.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

class ChatInitialState extends ChatState {}

class ChatGroupCreateState extends ChatState {
  final ChatGroupModel? chatGroup;
  final String? errorMessage;
  final ProviderStatus createChatGroupStatus;
  final String routeName;
  final int selectedIndex;
  const ChatGroupCreateState({
    required this.createChatGroupStatus,
    this.chatGroup,
    this.errorMessage,
    this.routeName = '',
    this.selectedIndex = 1,
  });
  @override
  List<Object> get props => [createChatGroupStatus];
}

class ChatGroupCreationFailState extends ChatState {}

class GetMyActiveCarsState extends ChatState {
  final ProviderStatus myCarStatus;
  final List<CarModel> myCarsList;
  const GetMyActiveCarsState({
    required this.myCarStatus,
    this.myCarsList = const [],
  });
  @override
  List<Object> get props => [myCarStatus];
}

class GetMoreMyActiveCarsState extends ChatState {
  final ProviderStatus myMoreCarStatus;
  final List<CarModel> myMoreCarsList;
  const GetMoreMyActiveCarsState({
    required this.myMoreCarStatus,
    this.myMoreCarsList = const [],
  });
  @override
  List<Object> get props => [myMoreCarStatus];
}
