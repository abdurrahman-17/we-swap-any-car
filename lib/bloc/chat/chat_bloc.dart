import 'package:equatable/equatable.dart';
import 'package:wsac/model/chat_model/chat_group/chat_user_model.dart';

import '../../core/configurations.dart';
import '../../core/locator.dart';
import '../../model/car_model/car_model.dart';
import '../../model/chat_model/chat_group/chat_car_model.dart';
import '../../model/chat_model/chat_group/chat_group_model.dart';
import '../../model/chat_model/user_chat_model/user_chat_model.dart';
import '../../repository/car_repo.dart';
import '../../repository/chat_repo.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatInitialState()) {
    on<ChatInitialEvent>((event, emit) {
      emit(ChatInitialState());
    });

    on<CreateChatGroupEvent>((event, emit) async {
      emit(ChatGroupCreateState(
        createChatGroupStatus: ProviderStatus.loading,
        routeName: event.routeName,
      ));
      final isSuccess = await Locator.instance
          .get<ChatRepo>()
          .createGroupOrUpdateGroup(chatGroup: event.chatGroup);

      if (isSuccess) {
        emit(ChatGroupCreateState(
          createChatGroupStatus: ProviderStatus.success,
          chatGroup: event.chatGroup,
          routeName: event.routeName,
          selectedIndex: event.selectedIndex,
        ));
      } else {
        emit(ChatGroupCreateState(
          createChatGroupStatus: ProviderStatus.error,
          errorMessage: errorOccurred,
          routeName: event.routeName,
        ));
      }
    });

    on<InsertChatEvent>((event, emit) async {
      bool status = await ChatRepo().insertChatToDb(chatModel: event.chatModel);

      if (status &&
          event.chatModel.type == convertEnumToString(MessageType.offer)) {
        final UserChatModel chatModel = event.chatModel;
        List<dynamic> buyerCars = [];

        for (final ChatCarModel item in chatModel.payload?.offer?.cars ?? []) {
          buyerCars.add({"id": item.carId});
        }

        String? transactionPayBy;
        if (chatModel.payload?.offer?.payType != null) {
          //offer created by seller
          if (event.seller?.userId == chatModel.createdUserId) {
            //seller pays
            if (chatModel.payload?.offer?.payType == payYou) {
              transactionPayBy = convertEnumToString(TransactionPayBy.seller);
            } else {
              transactionPayBy = convertEnumToString(TransactionPayBy.buyer);
            }
          } else {
            //offer created by buyer
            if (chatModel.payload?.offer?.payType == payYou) {
              transactionPayBy = convertEnumToString(TransactionPayBy.buyer);
            } else {
              transactionPayBy = convertEnumToString(TransactionPayBy.seller);
            }
          }
        }

        Map<String, dynamic> transactionJson = {
          "sellerId": event.seller?.userId,
          "sellerCarId": event.car?.carId,
          "buyerId": event.buyer?.userId,
          "buyerCarIds": buyerCars,
          "type": chatModel.payload?.offer?.offerType,
          "createdBy": chatModel.createdUserId,
          if (transactionPayBy != null) "payBy": transactionPayBy,
          if (chatModel.payload?.offer?.cash != null)
            "amount": chatModel.payload?.offer?.cash
        };

        ///CREATE NEW TRANSACTION INTO BACKEND
        final result = await Locator.instance
            .get<ChatRepo>()
            .createTransaction(transactionJson: transactionJson);
        result.fold((error) => null, (success) {
          chatModel.payload?.offer?.transferSummaryId = success.sId!;

          ///UPDATING TRANSACTION ID TO CHATS
          Locator.instance.get<ChatRepo>().updateTransferSummaryId(
              groupId: chatModel.groupId!,
              chatDocId: chatModel.id!,
              transferSummaryId: success.sId!);
        });
      }
    });

    on<UpdateOfferStatusEvent>((event, emit) async {
      await Locator.instance.get<ChatRepo>().updateOfferStatus(
            groupId: event.groupId,
            chatDocId: event.chatDocId,
            data: event.data,
          );
    });

    ///GET MY ACTIVE CARS
    on<GetMyActiveCarsEvent>((event, emit) async {
      emit(const GetMyActiveCarsState(myCarStatus: ProviderStatus.loading));
      final result = await Locator.instance
          .get<CarRepo>()
          .getMyCarsWithFilterRepo(fetchMyCarjson: event.myActiveCarJson);

      final GetMyActiveCarsState state = result.fold((fail) {
        //fail
        return const GetMyActiveCarsState(myCarStatus: ProviderStatus.error);
      }, (myCars) {
        return GetMyActiveCarsState(
            myCarStatus: ProviderStatus.success, myCarsList: myCars.cars ?? []);
      });
      emit(state);
    });

    ///GET MY ACTIVE CARS
    on<GetMoreMyActiveCarsEvent>((event, emit) async {
      emit(const GetMoreMyActiveCarsState(
          myMoreCarStatus: ProviderStatus.loading));
      final result = await Locator.instance
          .get<CarRepo>()
          .getMyCarsWithFilterRepo(fetchMyCarjson: event.moreMyActiveCarJson);

      final GetMoreMyActiveCarsState state = result.fold((fail) {
        //fail
        return const GetMoreMyActiveCarsState(
            myMoreCarStatus: ProviderStatus.error);
      }, (myCars) {
        return GetMoreMyActiveCarsState(
            myMoreCarStatus: ProviderStatus.success,
            myMoreCarsList: myCars.cars ?? []);
      });
      emit(state);
    });

    ///UpdateChatReadStatusEvent
    on<UpdateChatReadStatusEvent>((event, emit) async {
      await Locator.instance.get<ChatRepo>().updateChatReadStatus(
          groupId: event.groupId,
          chatDocId: event.chatDocId,
          userId: event.userId);
    });
  }
}
