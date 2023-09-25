import 'dart:developer';
import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_refresh/easy_refresh.dart';

import '../../../bloc/chat/chat_bloc.dart';
import '../../../core/configurations.dart';
import '../../../model/car_model/car_model.dart';
import '../../../model/chat_model/chat_group/chat_car_model.dart';
import '../../../model/chat_model/chat_group/chat_group_model.dart';
import '../../../model/chat_model/user_chat_model/attachments_model.dart';
import '../../../model/chat_model/user_chat_model/message_model.dart';
import '../../../model/chat_model/user_chat_model/offer_model.dart';
import '../../../model/chat_model/user_chat_model/payload_model.dart';
import '../../../model/chat_model/user_chat_model/single_attachment_model.dart';
import '../../../model/chat_model/user_chat_model/user_chat_model.dart';
import '../../../utility/chat_utils.dart';
import '../../../utility/date_time_utils.dart';
import '../../../utility/file_upload_helper.dart';
import '../../../utility/file_utils.dart';
import '../../common_widgets/common_divider.dart';
import '../../common_widgets/common_loader.dart';
import '../../common_widgets/custom_icon_button.dart';
import '../../my_cars/my_car_profile_screen.dart';
import 'offer_selection_widget.dart';

class MessageInput extends StatefulWidget {
  const MessageInput({
    Key? key,
    required this.currentUserId,
    required this.chatGroup,
    required this.insertChat,
    required this.userIdOrAdminUserId,
    this.selectedIndex = 0,
  }) : super(key: key);

  final String currentUserId;
  final ChatGroupModel chatGroup;
  final void Function(UserChatModel) insertChat;
  final int? selectedIndex;
  final String userIdOrAdminUserId;

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController messageController = TextEditingController();
  int selectedIndex = 0;
  String selectedOption = "";
  String selectedPayType = '';
  final List<String> offerOptionList = [swap, cash, swapAndCash];
  final List<String> payTypes = [payYou, payMe];
  List<CarModel> selectedCars = [];
  List<CarModel> myCars = [];
  bool isFirst = true;
  double containerHeight = 0;
  int perPage = 10;
  int pageNo = 0;

  void callBack(String value) {
    selectedOption = value;
    containerHeight = getContainerHeight();
    setState(() {});
  }

  final EasyRefreshController _easyRefreshController = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  @override
  void initState() {
    _tabController = TabController(
      initialIndex: widget.selectedIndex!,
      length: 2,
      vsync: this,
    );
    _tabController.addListener(() {
      log("selectedIndex${_tabController.index}");
      selectedCars.clear();
      keyBoardHide(context);
      selectedIndex = _tabController.index;
      containerHeight = getContainerHeight();
      log(containerHeight.toString());
      setState(() {});
    });

    getMyCars();
    selectedIndex = _tabController.index;
    selectedOption = offerOptionList[0];
    selectedPayType = payTypes[0];
    containerHeight = getContainerHeight();
    super.initState();
  }

  ///MY CARS API CALL
  void getMyCars() async {
    pageNo = 0;
    final getActiveCarsJson = {
      'perPage': perPage,
      'pageNo': pageNo,
      'filters': {
        'status': [CarStatus.active.name]
      },
    };
    context
        .read<ChatBloc>()
        .add(GetMyActiveCarsEvent(myActiveCarJson: getActiveCarsJson));
  }

  ///MORE MY CARS API CALL
  void getLoadMoreCars() async {
    final loadMoreActiveCarsJson = {
      'perPage': perPage,
      'pageNo': ++pageNo,
      'filters': {
        'status': [CarStatus.active.name]
      },
    };
    context.read<ChatBloc>().add(
        GetMoreMyActiveCarsEvent(moreMyActiveCarJson: loadMoreActiveCarsJson));
  }

  double getContainerHeight() {
    if (selectedIndex == 0) {
      return getVerticalSize(50);
    } else if (selectedIndex == 1 &&
        selectedOption == cash &&
        myCars.isNotEmpty) {
      return getVerticalSize(128);
    } else if (selectedIndex == 1 && selectedOption == cash) {
      return getVerticalSize(70);
    } else if (selectedIndex == 1 && selectedOption == swap) {
      return getVerticalSize(230);
    } else {
      return getVerticalSize(270);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xffE4E4E4),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(35.r),
            topRight: Radius.circular(35.r),
          ),
        ),
        child: Column(
          children: [
            ///tab bar
            Container(
              margin: getMargin(
                top: 30.h,
                left: 24.h,
                right: 24.h,
              ),
              height: 40.h,
              decoration: BoxDecoration(
                color: ColorConstant.black900,
                borderRadius: BorderRadius.circular(
                  getHorizontalSize(100.r),
                ),
              ),
              child: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: "Chat"),
                  Tab(text: "Make an offer"),
                ],
                labelColor: ColorConstant.whiteA700,
                unselectedLabelColor: ColorConstant.whiteA700,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    getHorizontalSize(100.00.r),
                  ),
                  gradient: LinearGradient(
                    begin: const Alignment(0, 0.5),
                    end: const Alignment(1, 0.5),
                    colors: kPrimaryGradientColor,
                  ),
                ),
              ),
            ),
            Container(
              height: containerHeight,
              margin: getMargin(top: 22.h),
              child: TabBarView(
                controller: _tabController,
                children: [
                  textMessageWidget(onTap: () {
                    if (messageController.text.isNotEmpty) {
                      final message = maskChat(messageController.text);
                      final chat = UserChatModel(
                          id: getUniqueId(),
                          groupId: widget.chatGroup.groupId,
                          createdUserId: widget.currentUserId,
                          readUsers: [],
                          createdAt: getCurrentDateTime(),
                          updatedAt: getCurrentDateTime(),
                          type: convertEnumToString(MessageType.normal),
                          payload: PayloadModel(
                            messageModel: MessageModel(message: message),
                          ));
                      sendMessage(chat);
                    } else {
                      showSnackBar(message: "Please enter the message");
                    }
                  }),
                  makeAnOfferWidget(),
                ],
              ),
            ),
            SizedBox(
              height: selectedIndex == 0 ? 37.h : 5.h,
            )
          ],
        ),
      ),
    );
  }

  Widget makeAnOfferWidget() {
    return BlocConsumer<ChatBloc, ChatState>(
      listener: (context, state) {
        if (state is GetMoreMyActiveCarsState &&
            state.myMoreCarStatus == ProviderStatus.success) {
          if (state.myMoreCarsList.isNotEmpty) {
            myCars.addAll(state.myMoreCarsList);
            _easyRefreshController.finishLoad(IndicatorResult.success, true);
          } else {
            _easyRefreshController.finishLoad(IndicatorResult.noMore, true);
          }
        }
      },
      builder: (context, state) {
        log(state.toString());
        if ((state is GetMyActiveCarsState &&
                state.myCarStatus == ProviderStatus.success) ||
            state is GetMoreMyActiveCarsState) {
          if (state is GetMyActiveCarsState &&
              state.myCarStatus == ProviderStatus.success) {
            myCars = state.myCarsList;
          }

          ///NO CARS AVAILABLE FOR SWAPPING
          if (myCars.isEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              if (isFirst) {
                isFirst = false;
                setState(() {
                  selectedOption = cash;
                  containerHeight = getContainerHeight();
                });
              }
            });

            return makeAnOfferTextField(
              onTap: () {
                //offer
                UserChatModel chat = UserChatModel(
                    id: getUniqueId(),
                    groupId: widget.chatGroup.groupId,
                    createdUserId: widget.currentUserId,
                    readUsers: [],
                    createdAt: getCurrentDateTime(),
                    updatedAt: getCurrentDateTime(),
                    type: convertEnumToString(MessageType.offer));

                ///CASH
                if (messageController.text.isEmpty) {
                  showSnackBar(message: "Please enter the value");
                } else {
                  chat.payload = PayloadModel(
                    offer: OfferModel(
                      offerType: convertEnumToString(OfferType.cash),
                      offerStatus: convertEnumToString(OfferStatus.waiting),
                      cash: int.parse(messageController.text),
                    ),
                  );

                  sendMessage(chat);
                }
              },
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              OfferSelectionRadioWidget(
                callBack: callBack,
                offerOptions: offerOptionList,
                selectedOption: selectedOption,
              ),
              SizedBox(
                height: getVerticalSize(23),
              ),
              const GradientDivider(),
              if (selectedOption != cash)
                Container(
                  margin: getPadding(top: 18, left: 10),
                  height: getVerticalSize(105),
                  child: EasyRefresh(
                    triggerAxis: Axis.horizontal,
                    clipBehavior: Clip.none,
                    controller: _easyRefreshController,
                    footer: const ClassicFooter(
                      showText: false,
                      failedIcon: SizedBox(),
                      noMoreIcon: Text("No more"),
                    ),
                    onLoad: () {
                      getLoadMoreCars();
                    },
                    child: ListView.separated(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final item = myCars[index];
                        return Stack(
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  if (selectedCars
                                      .any((file) => file.id == item.id)) {
                                    selectedCars.remove(item);
                                  } else {
                                    selectedCars.add(item);
                                  }
                                });
                              },
                              child: Container(
                                clipBehavior: Clip.antiAlias,
                                width: getHorizontalSize(113),
                                height: getVerticalSize(66),
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),
                                child: CustomImageView(
                                  url: item.uploadPhotos?.rightImages?.first ??
                                      '',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 10,
                              child: SizedBox(
                                width: getHorizontalSize(113),
                                child: Center(
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        MyCarProfileScreen.routeName,
                                        arguments: {'carId': item.id},
                                      );
                                    },
                                    child: Text(
                                      '${item.manufacturer?.name ?? ''} '
                                      '${item.model ?? ''}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            if (selectedCars.contains(item))
                              Positioned(
                                right: 5,
                                bottom: 45,
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                        colors: kPrimaryGradientColor),
                                    border: Border.all(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.done,
                                      size: 15,
                                      color: ColorConstant.kColorWhite,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(
                          width: getHorizontalSize(10),
                        );
                      },
                      itemCount: myCars.length,
                    ),
                  ),
                ),
              makeAnOfferTextField(
                onTap: () {
                  //offer
                  UserChatModel chat = UserChatModel(
                      id: getUniqueId(),
                      groupId: widget.chatGroup.groupId,
                      createdUserId: widget.currentUserId,
                      readUsers: [],
                      createdAt: getCurrentDateTime(),
                      updatedAt: getCurrentDateTime(),
                      type: convertEnumToString(MessageType.offer));

                  ///SWAP
                  if (selectedOption == swap) {
                    if (selectedCars.isEmpty) {
                      showSnackBar(message: "Please select a car");
                    } else {
                      final List<ChatCarModel> tempList = [];
                      for (var element in selectedCars) {
                        tempList.add(ChatCarModel(
                          carId: element.id,
                          userId: element.userId,
                          carImage:
                              element.uploadPhotos?.frontImages?.first ?? '',
                          carName: element.manufacturer?.name ?? '',
                          carModelName: element.model,
                          carCash: element.userExpectedValue,
                        ));
                      }

                      chat.payload = PayloadModel(
                        offer: OfferModel(
                          offerType: convertEnumToString(OfferType.swap),
                          offerStatus: convertEnumToString(OfferStatus.waiting),
                          cars: tempList,
                        ),
                      );

                      log(selectedCars.toString());
                      sendMessage(chat);
                    }
                  }

                  ///CASH
                  else if (selectedOption == cash) {
                    if (messageController.text.isEmpty) {
                      showSnackBar(message: "Please enter the value");
                    } else {
                      chat.payload = PayloadModel(
                        offer: OfferModel(
                          offerType: convertEnumToString(OfferType.cash),
                          offerStatus: convertEnumToString(OfferStatus.waiting),
                          cash: int.parse(messageController.text),
                        ),
                      );

                      sendMessage(chat);
                    }
                  }

                  ///SWAP PLUS CASH
                  else {
                    if (selectedCars.isNotEmpty &&
                        messageController.text.isNotEmpty) {
                      final List<ChatCarModel> tempList = [];
                      for (var element in selectedCars) {
                        tempList.add(ChatCarModel(
                          carId: element.id,
                          userId: element.userId,
                          carImage:
                              element.uploadPhotos?.frontImages?.first ?? '',
                          carName: element.manufacturer?.name ?? '',
                          carModelName: element.model,
                          carCash: element.userExpectedValue,
                        ));
                      }
                      chat.payload = PayloadModel(
                        offer: OfferModel(
                          offerType: convertEnumToString(OfferType.swapAndCash),
                          offerStatus: convertEnumToString(OfferStatus.waiting),
                          payType: selectedPayType,
                          cash: int.parse(messageController.text),
                          cars: tempList,
                        ),
                      );

                      log(selectedCars.toString());
                      sendMessage(chat);
                    } else if (messageController.text.isEmpty) {
                      showSnackBar(message: "Please enter the value");
                    } else {
                      showSnackBar(message: "Please select a car");
                    }
                  }
                },
              ),
            ],
          );
        }
        return shimmerLoader(Container(
          color: ColorConstant.kColorWhite,
          height: getVerticalSize(30),
        ));
      },
    );
  }

  ///text  message only
  Widget textMessageWidget({required VoidCallback onTap}) {
    return Container(
      padding: EdgeInsets.only(
        left: 15.w,
        right: 15.w,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 287.w,
            child: TextField(
              minLines: 1,
              maxLines: 4,
              controller: messageController,
              decoration: InputDecoration(
                prefixIcon: IconButton(
                  onPressed: () => onAttachmentTap(),
                  icon: const Icon(
                    Icons.attachment_outlined,
                    color: Colors.black,
                  ),
                ),
                hintText: "Enter message..",
                hintStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15.sp,
                  color: const Color.fromRGBO(48, 48, 48, 0.15),
                ),
                disabledBorder: messageFieldDecoration,
                border: messageFieldDecoration,
                focusedBorder: messageFieldDecoration,
                enabledBorder: messageFieldDecoration,
                contentPadding: EdgeInsets.only(
                  top: 22.r,
                  right: 20.r,
                  left: 20.r,
                  bottom: 5.r,
                ),
                fillColor: ColorConstant.kColorWhite,
                filled: true,
              ),
            ),
          ),
          SizedBox(
            width: 2.w,
          ),
          CustomIconButton(
            height: 50,
            width: 50,
            margin: getMargin(right: 5, bottom: 5),
            shape: IconButtonShape.RoundedBorder100,
            padding: IconButtonPadding.PaddingAll6,
            onTap: onTap,
            child: const Center(
              child: CustomImageView(
                svgPath: Assets.sendBtn,
              ),
            ),
          )
        ],
      ),
    );
  }

  OutlineInputBorder get messageFieldDecoration => OutlineInputBorder(
        borderSide: BorderSide(
          color: ColorConstant.kColorD9D9D9,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(50.r),
        ),
      );

  Widget makeAnOfferTextField({required VoidCallback onTap}) {
    return Container(
      padding: EdgeInsets.only(left: 15.w, right: 15.w, top: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (selectedOption == swapAndCash)
            Padding(
              padding: getPadding(bottom: 10),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline_rounded,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    selectedPayType == payTypes[0]
                        ? 'Pay you :  Extra amount I pay'
                        : 'Pay me :  The amount I need',
                    style: AppTextStyle.hintTextStyle.copyWith(
                      color: ColorConstant.kColor6C6C6C,
                    ),
                  ),
                ],
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (selectedOption != swap)
                Expanded(
                  child: TextField(
                    minLines: 1,
                    maxLines: 4,
                    controller: messageController,
                    decoration: InputDecoration(
                      prefixIcon: selectedOption == swapAndCash
                          ? IntrinsicHeight(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: getPadding(left: 10, right: 5),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton2<String>(
                                        dropdownStyleData:
                                            const DropdownStyleData(
                                          padding: EdgeInsets.zero,
                                        ),
                                        iconStyleData: const IconStyleData(
                                            icon: Icon(
                                          Icons.keyboard_arrow_down,
                                          color: Colors.black,
                                        )),
                                        value: selectedPayType,
                                        isDense: true,
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            log(newValue.toString());
                                            selectedPayType = newValue!;
                                          });
                                        },
                                        items: payTypes.map((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(
                                              value,
                                              style: AppTextStyle.hintTextStyle
                                                  .copyWith(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                  const VerticalDivider(
                                    color: Color(0xffD7D7D7),
                                    thickness: 1,
                                    width: 6,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  )
                                ],
                              ),
                            )
                          : null,
                      hintText: "Enter value",
                      hintStyle: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15.sp,
                          color: const Color.fromRGBO(48, 48, 48, 0.15)),
                      disabledBorder: messageFieldDecoration,
                      border: messageFieldDecoration,
                      focusedBorder: messageFieldDecoration,
                      enabledBorder: messageFieldDecoration,
                      contentPadding: EdgeInsets.only(
                          top: 22.r, right: 20.r, left: 20.r, bottom: 5.r),
                      fillColor: ColorConstant.kColorWhite,
                      filled: true,
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              SizedBox(width: 10.w),
              CustomIconButton(
                height: 50,
                width: 50,
                margin: getMargin(
                  right: 5,
                ),
                shape: IconButtonShape.RoundedBorder100,
                padding: IconButtonPadding.PaddingAll6,
                onTap: onTap,
                child: const Center(
                  child: CustomImageView(
                    svgPath: Assets.sendBtn,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  void sendMessage(UserChatModel chatModel) {
    widget.insertChat(chatModel);
    FocusScope.of(context).unfocus();
    // log(chatModel.selectedCars.toString());
    setState(() {
      messageController.text = '';
      selectedCars.clear();
    });
  }

//onTap attachment
  void onAttachmentTap() {
    // showModelSheetForChatAttachment(
    //   getFile: (value, type) async {
    //     if (value != null && value.isNotEmpty) {
    //       UserChatModel chat = UserChatModel(
    //         id: getUniqueId(),
    //         groupId: widget.chatGroup.groupId,
    //         createdUserId: widget.currentUserId,
    //         readUsers: [],
    //         createdAt: getCurrentDateTime(),
    //         updatedAt: getCurrentDateTime(),
    //         type: convertEnumToString(MessageType.normal),
    //       );
    //       log(value);
    //       final file = File(value);
    //       // final url = await Locator.instance
    //       //     .get<UserRepo>()
    //       //     .uploadFile(filePath: file.path, fileName: file.name);
    //       switch (type) {
    //         case AttachmentType.image:
    //           {
    //             chat.payload = PayloadModel(
    //               messageModel: MessageModel(
    //                 attachments: AttachmentsModel(
    //                   images: [
    //                     SingleAttachmentModel(
    //                         name: file.name,
    //                         size: "${getFileSizeInMB(
    //                           file,
    //                           isInKB: true,
    //                         )}",
    //                         // url: getEncodedUrl(url!),
    //                         filePath: file.path),
    //                   ],
    //                 ),
    //               ),
    //             );
    //             break;
    //           }
    //         case AttachmentType.video:
    //           {
    //             chat.payload = PayloadModel(
    //               messageModel: MessageModel(
    //                 attachments: AttachmentsModel(
    //                   videos: [
    //                     SingleAttachmentModel(
    //                         name: file.name,
    //                         size: "${getFileSizeInMB(
    //                           file,
    //                           isInKB: true,
    //                         )}",
    //                         // url: getEncodedUrl(url!),
    //                         filePath: file.path),
    //                   ],
    //                 ),
    //               ),
    //             );
    //             break;
    //           }
    //         case AttachmentType.document:
    //           {
    //             chat.payload = PayloadModel(
    //               messageModel: MessageModel(
    //                 attachments: AttachmentsModel(
    //                   documents: [
    //                     SingleAttachmentModel(
    //                         name: file.name,
    //                         size: "${getFileSizeInMB(
    //                           file,
    //                           isInKB: true,
    //                         )}",
    //                         filePath: file.path
    //                         // url: getEncodedUrl(url!),
    //                         ),
    //                   ],
    //                 ),
    //               ),
    //             );
    //             break;
    //           }
    //         default:
    //           break;
    //       }
    //       sendMessage(chat);
    //     }
    //   },
    // );
    FileManager().showModelSheetForImage(
      isMultiImage: true,
      fileCount: 5,
      getFiles: (images) async {
        if (images.isNotEmpty) {
          UserChatModel chat = UserChatModel(
            id: getUniqueId(),
            groupId: widget.chatGroup.groupId,
            createdUserId: widget.currentUserId,
            readUsers: [],
            createdAt: getCurrentDateTime(),
            updatedAt: getCurrentDateTime(),
            type: convertEnumToString(MessageType.normal),
          );
          chat.payload = PayloadModel(
            messageModel: MessageModel(
              attachments: AttachmentsModel(
                images: [
                  for (final item in images)
                    SingleAttachmentModel(
                      name: File(item).name,
                      size: "${getFileSizeInMB(
                        File(item),
                        isInKB: true,
                      )}",
                      filePath: item,
                    ),
                ],
              ),
            ),
          );
          sendMessage(chat);
        }
      },
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _easyRefreshController.dispose();
    super.dispose();
  }
}
