import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:wsac/utility/date_time_utils.dart';

import '../../../bloc/chat/chat_bloc.dart';
import '../../../core/configurations.dart';
import '../../../core/locator.dart';
import '../../../model/chat_model/chat_group/chat_group_model.dart';
import '../../../model/chat_model/user_chat_model/attachments_model.dart';
import '../../../model/chat_model/user_chat_model/user_chat_model.dart';
import '../../../repository/chat_repo.dart';
import '../../../utility/chat_utils.dart';
import '../../../utility/file_utils.dart';
import '../../common_widgets/common_popups.dart';
import '../../common_widgets/full_screen_image_viewer.dart';
import '../../common_widgets/full_screen_video_player.dart';
import '../../common_widgets/video_player_widget.dart';
import 'user_deal_item.dart';
import 'common_outiled_button.dart';

class MessageBox extends StatefulWidget {
  const MessageBox({
    Key? key,
    required this.isSender,
    required this.chat,
    required this.chatGroup,
    required this.currentUserId,
  }) : super(key: key);
  final bool isSender;
  final UserChatModel chat;
  final ChatGroupModel chatGroup;
  final String currentUserId;

  @override
  State<MessageBox> createState() => _MessageBoxState();
}

class _MessageBoxState extends State<MessageBox> {
  final ValueNotifier<int> _downloadProgress = ValueNotifier<int>(0);
  late ChatBloc chatBloc;
  final TextEditingController messageController = TextEditingController();
  String selectedPayType = '';
  final List<String> payTypes = [
    payYou,
    payMe,
  ];

  Map<String, dynamic> updateOfferStatusJson(String status, {num? amount}) => {
        "payload.offer.offerStatus": status,
        "updatedAt": getCurrentTimeStamp(),
        if (amount != null) "payload.offer.cash": amount
      };

  void updateTransactionStatus(String status, {num? amount}) {
    ///TRANSACTION UPDATION
    Map<String, dynamic> transactionJson = {
      "status": status,
      if (widget.chat.type == convertEnumToString(MessageType.offer))
        "_id": widget.chat.payload?.offer?.transferSummaryId,
      if (amount != null) "amount": amount,
    };
    Locator.instance
        .get<ChatRepo>()
        .updateTransactionStatus(transactionJson: transactionJson);
  }

  @override
  void initState() {
    chatBloc = BlocProvider.of<ChatBloc>(context);
    selectedPayType = widget.chat.payload?.offer?.payType ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          widget.isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!widget.isSender)
          chatAvatar(
            widget.chat.createdUserId == widget.chatGroup.admin!.userId
                ? widget.chatGroup.admin?.userImage
                : widget.chatGroup.receiver?.userImage,
          ),
        widget.chat.status == convertEnumToString(ChatStatus.deleted) ||
                widget.chat.status ==
                    convertEnumToString(ChatStatus.disappeared)
            ? deleteOrDisappeared()
            : widget.chat.type == convertEnumToString(MessageType.normal)
                ? Flexible(
                    child: Container(
                      decoration: decorationContainer(widget.isSender),
                      padding: EdgeInsets.all(8.r),
                      margin: EdgeInsets.only(
                        left: !widget.isSender ? 5 : 0,
                        right: widget.isSender ? 5 : 0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          normalMessage(widget.chat),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                widget.isSender
                                    ? Icon(Icons.done_all,
                                        size: 14,
                                        color: widget.chat.readUsers.isNotEmpty
                                            ? Colors.blue
                                            : Colors.black)
                                    : const SizedBox(),
                                SizedBox(
                                  width: widget.isSender ? 8 : 0,
                                ),
                                Text(
                                  getTimeFromData(widget.chat.createdAt!),
                                  style: const TextStyle(fontSize: 8),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                : Flexible(
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: !widget.isSender ? 5 : 0,
                        right: widget.isSender ? 5 : 0,
                      ),
                      child: offerMessage(widget.chat),
                    ),
                  ),
        if (widget.isSender)
          chatAvatar(
            widget.chat.createdUserId == widget.chatGroup.admin!.userId
                ? widget.chatGroup.admin?.userImage
                : widget.chatGroup.receiver?.userImage,
          ),
      ],
    );
  }

  //decoration
  BoxDecoration decorationContainer(bool isSender) {
    return BoxDecoration(
      borderRadius: isSender
          ? BorderRadius.only(
              bottomLeft: Radius.circular(15.r),
              topLeft: Radius.circular(15.r),
              bottomRight: Radius.circular(15.r),
            )
          : BorderRadius.only(
              bottomRight: Radius.circular(15.r),
              topRight: Radius.circular(15.r),
              bottomLeft: Radius.circular(15.r),
            ),
      color: isSender ? const Color(0xffF27B79) : ColorConstant.kColorWhite,
      boxShadow: const [
        BoxShadow(
          color: Colors.grey,
          blurRadius: 3,
        ),
      ],
    );
  }

  Widget morePhotos(int count) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      top: 0,
      child: Center(
        child: Text(
          "+ $count",
          style: AppTextStyle.appBarTextStyle.copyWith(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
    );
  }

  //deleteOrDisappeared
  Widget deleteOrDisappeared() {
    return Flexible(
      child: Container(
        decoration: decorationContainer(widget.isSender),
        padding: EdgeInsets.all(8.r),
        margin: EdgeInsets.only(
          left: !widget.isSender ? 5 : 0,
          right: widget.isSender ? 5 : 0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            widget.chat.status == convertEnumToString(ChatStatus.deleted)
                ? Text(
                    "This message was disappeared",
                    style: AppTextStyle.italicDeletedStyle.copyWith(
                      color: widget.isSender
                          ? ColorConstant.kColorWhite
                          : Colors.black,
                    ),
                  )
                : Text(
                    widget.isSender
                        ? "You deleted this message"
                        : "This message was deleted",
                    style: AppTextStyle.italicDeletedStyle.copyWith(
                      color: widget.isSender
                          ? ColorConstant.kColorWhite
                          : Colors.black,
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                getTimeFromData(widget.chat.createdAt!),
                style: const TextStyle(fontSize: 8),
              ),
            )
          ],
        ),
      ),
    );
  }

  ///question message
  Widget normalMessage(UserChatModel chat) {
    final AttachmentsModel? attachments =
        chat.payload?.messageModel?.attachments;
    final uploadingLoader = Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      top: 0,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Uploading..",
              style: AppTextStyle.appBarTextStyle.copyWith(color: Colors.white),
            ),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
    if (attachments != null) {
      if ((attachments.images.isNotEmpty)) {
        final bool isFile = attachments.images[0].filePath != null;
        return Stack(
          children: [
            CustomImageView(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  FullScreenImageViewer.routeName,
                  arguments: {
                    'imageList': [
                      for (final item in attachments.images) item.url
                    ],
                    "isMultiImage": true,
                  },
                );
              },
              file: isFile ? File(attachments.images[0].filePath!) : null,
              url: attachments.images[0].url,
              fit: BoxFit.contain,
            ),
            if (isFile) uploadingLoader,
            if (!isFile && attachments.images.length > 1)
              morePhotos(attachments.images.length - 1)
          ],
        );
      } else if (attachments.videos.isNotEmpty) {
        final bool isFile = attachments.videos[0].filePath != null;
        return Stack(
          children: [
            VideoPlayerWidget(
              videoFilePath: attachments.videos[0].filePath,
              videoUrl: attachments.videos[0].url,
              playAction: isFile
                  ? null
                  : () {
                      Navigator.pushNamed(
                        context,
                        FullScreenVideoPlayer.routeName,
                        arguments: {
                          'networkVideoUrl': attachments.videos[0].url!,
                        },
                      );
                    },
            ),
            if (isFile) uploadingLoader
          ],
        );
      } else {
        final file = attachments.documents[0];
        final bool isFile = attachments.documents[0].filePath != null;
        return FutureBuilder(
            future: getTemporaryDirectoryPath(),
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.done &&
                  snap.hasData) {
                final folderPath = snap.data ?? '';
                final localPath = "$folderPath/file_picker/${file.name}";
                return ListTile(
                  onTap: () async {
                    if (File(localPath).existsSync()) {
                      // openFile(localPath);
                    } else {
                      //download
                      downloadFile(
                        file.url!,
                        filePath: localPath,
                        folderPath: "$folderPath/file_picker",
                      );
                    }
                  },
                  leading: isFile
                      ? const SizedBox(
                          height: 35,
                          width: 35,
                          child: CircularProgressIndicator(),
                        )
                      : File(localPath).existsSync()
                          ? const Icon(
                              Icons.file_copy,
                              size: 35,
                            )
                          : ValueListenableBuilder(
                              valueListenable: _downloadProgress,
                              builder: (context, progress, _) {
                                log("progress:${progress.toString()}");
                                return progress == 0
                                    ? const Icon(
                                        Icons.download_for_offline_outlined,
                                        size: 35,
                                      )
                                    : progress != 100
                                        ? SizedBox(
                                            height: 35,
                                            width: 35,
                                            child: Stack(
                                              children: [
                                                CircularProgressIndicator(
                                                  value: (progress / 100),
                                                ),
                                                Align(child: Text("$progress"))
                                              ],
                                            ),
                                          )
                                        : const Icon(
                                            Icons.file_copy,
                                            size: 35,
                                          );
                              },
                            ),
                  title: Text(
                    file.name!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    isFile ? "uploading" : "${file.size} KB",
                    maxLines: 1,
                  ),
                );
              }
              return const SizedBox();
            });
      }
    } else {
      return Text(
        chat.payload?.messageModel?.message ?? '',
        style: AppTextStyle.hintTextStyle.copyWith(
          color: widget.isSender ? ColorConstant.kColorWhite : Colors.black,
        ),
      );
    }
  }

  ///offer message
  Widget offerMessage(UserChatModel chat) {
    // log(chat.selectedCars.toString());
    return offerCard(chat, widget.isSender);
  }

  ///chat profile image
  Widget chatAvatar(String? userImage) {
    return Container(
      height: 35,
      width: 35,
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(shape: BoxShape.circle),
      child: CustomImageView(
        url: userImage,
        errorAsset: Assets.profilePic,
        fit: BoxFit.cover,
      ),
    );
  }

//offer card
  Widget offerCard(UserChatModel chat, bool isSender) {
    Widget buttons = const SizedBox();
    switch (chat.payload?.offer!.offerStatus) {
      case "accepted":
        {
          buttons = Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 30,
                  width: 0,
                  child: CommonOutlineButton(
                    label: "ACCEPTED",
                    buttonTextColor: ColorConstant.kColorC1C1C1,
                    onTap: () {},
                  ),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: GradientElevatedButton(
                  buttonGradient: LinearGradient(colors: [
                    ColorConstant.lightGreenA700,
                    ColorConstant.kColorC8CC00
                  ]),
                  title: "PROCEED",
                  fontSize: 10.sp,
                  height: getVerticalSize(30),
                  onTap: () {
                    //TO DO: - transfer summary
                  },
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: CustomElevatedButton(
                  title: "CANCEL",
                  fontSize: 10.sp,
                  height: getVerticalSize(30),
                  onTap: () async {
                    bool result = await confirmationPopup(
                        title: "REJECT",
                        message: cancelConfirm,
                        isQuestion: true,
                        messageTextAlign: TextAlign.center);
                    if (result) {
                      final Map<String, dynamic> body = updateOfferStatusJson(
                          convertEnumToString(OfferStatus.canceled));

                      chatBloc.add(UpdateOfferStatusEvent(
                          groupId: widget.chatGroup.groupId ?? '',
                          chatDocId: widget.chat.id ?? '',
                          data: body));
                      updateTransactionStatus(
                          convertEnumToString(OfferStatus.canceled));
                    }
                  },
                ),
              ),
            ],
          );

          break;
        }
      case "rejected":
        {
          buttons = GradientElevatedButton(
            title: "REJECTED",
            fontSize: 10.sp,
            height: getVerticalSize(30),
            width: 120,
            onTap: () {},
          );
          break;
        }
      case "negotiated":
        {
          buttons = SizedBox(
            width: 120,
            child: CommonOutlineButton(
              buttonTextColor: ColorConstant.kColorWhite,
              label: "NEGOTIATED",
              buttonBgColor: Colors.black,
              onTap: () {},
            ),
          );
          break;
        }
      case "waiting":
        {
          if (isSender) {
            buttons = Column(
              children: [
                Text(
                  "Waiting for response",
                  style: AppTextStyle.hintTextStyle.copyWith(
                    color: ColorConstant.kColor7C7C7C,
                  ),
                ),
                Padding(
                  padding: getPadding(top: 7, bottom: 5),
                  child: GradientElevatedButton(
                    height: 30,
                    width: 120,
                    onTap: () async {
                      bool result = await confirmationPopup(
                          title: "Cancel",
                          message: cancelConfirm,
                          isQuestion: true,
                          messageTextAlign: TextAlign.center);
                      if (result) {
                        final Map<String, dynamic> body = updateOfferStatusJson(
                            convertEnumToString(OfferStatus.canceled));

                        chatBloc.add(UpdateOfferStatusEvent(
                            groupId: widget.chatGroup.groupId ?? '',
                            chatDocId: widget.chat.id ?? '',
                            data: body));
                        updateTransactionStatus(
                            convertEnumToString(OfferStatus.canceled));
                      }
                    },
                    title: 'Cancel This Deal',
                    textStyle: AppTextStyle.smallTextStyle
                        .copyWith(color: ColorConstant.kColorWhite),
                  ),
                )
              ],
            );
          } else {
            buttons = Row(
              children: [
                //ACCEPT
                Expanded(
                  child: CommonOutlineButton(
                    width: 0,
                    label: acceptButton,
                    onTap: () async {
                      bool result = await confirmationPopup(
                          title: acceptButton,
                          message: areYouSureWantToProceedWithTheOffer,
                          isQuestion: true,
                          messageTextAlign: TextAlign.center);
                      if (result) {
                        final Map<String, dynamic> body = updateOfferStatusJson(
                          convertEnumToString(OfferStatus.accepted),
                        );

                        chatBloc.add(UpdateOfferStatusEvent(
                            groupId: widget.chatGroup.groupId ?? '',
                            chatDocId: widget.chat.id ?? '',
                            data: body));
                        updateTransactionStatus(
                            convertEnumToString(OfferStatus.accepted));
                      }
                    },
                  ),
                ),
                SizedBox(width: 12.w),
                //REJECT
                Expanded(
                  child: GradientElevatedButton(
                    width: 0,
                    title: rejectTitle,
                    fontSize: 10.sp,
                    height: getVerticalSize(30),
                    onTap: () async {
                      bool result = await confirmationPopup(
                          title: rejectTitle,
                          message: areYouSureWantToReject,
                          isQuestion: true,
                          messageTextAlign: TextAlign.center);
                      if (result) {
                        final Map<String, dynamic> body = updateOfferStatusJson(
                            convertEnumToString(OfferStatus.rejected));

                        chatBloc.add(UpdateOfferStatusEvent(
                            groupId: widget.chatGroup.groupId ?? '',
                            chatDocId: widget.chat.id ?? '',
                            data: body));
                        updateTransactionStatus(
                            convertEnumToString(OfferStatus.rejected));
                      }
                    },
                  ),
                ),
                SizedBox(width: 12.w),
                //NEGOTIATE
                Expanded(
                  child: CustomElevatedButton(
                    width: 0,
                    title: "NEGOTIATE",
                    fontSize: 8.sp,
                    height: getVerticalSize(30),
                    onTap: () async {
                      messageController.clear();
                      await customPopup(
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'NEGOTIATE',
                              style: AppTextStyle.regularTextStyle.copyWith(
                                  color: ColorConstant.kPrimaryDarkRed,
                                  fontWeight: FontWeight.w700,
                                  fontSize: getFontSize(16)),
                            ),
                            makeAnOfferTextField(
                                isPayType:
                                    chat.payload?.offer?.payType != null),
                            SizedBox(height: 15.w),
                            Row(
                              children: [
                                Expanded(
                                  child: CustomElevatedButton(
                                    title: 'CANCEL',
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                Expanded(
                                  child: GradientElevatedButton(
                                    title: 'SEND',
                                    onTap: () {
                                      if (messageController.text.isEmpty) {
                                        showSnackBar(
                                            message: "Please enter amount");
                                        return;
                                      }
                                      final Map<String, dynamic> body =
                                          updateOfferStatusJson(
                                        convertEnumToString(
                                            OfferStatus.negotiated),
                                        amount:
                                            int.parse(messageController.text),
                                      );
                                      chatBloc.add(UpdateOfferStatusEvent(
                                          groupId:
                                              widget.chatGroup.groupId ?? '',
                                          chatDocId: widget.chat.id ?? '',
                                          data: body));
                                      updateTransactionStatus(
                                          convertEnumToString(
                                              OfferStatus.negotiated),
                                          amount: int.parse(
                                              messageController.text));
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                )
              ],
            );
          }

          break;
        }
      case "canceled":
        {
          buttons = Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GradientElevatedButton(
                height: 30,
                width: 120,
                onTap: () {},
                title: 'Cancelled',
                textStyle: AppTextStyle.smallTextStyle
                    .copyWith(color: ColorConstant.kColorWhite),
              ),
            ],
          );
          break;
        }
    }
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          color: ColorConstant.kColorWhite),
      child: Column(
        children: [
          UserDealItem(
            chat: chat,
            chatGroup: widget.chatGroup,
            currentUserId: widget.currentUserId,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buttons,
                const SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    widget.isSender
                        ? Icon(Icons.done_all,
                            size: 14,
                            color: chat.readUsers.isNotEmpty
                                ? Colors.blue
                                : Colors.black)
                        : const SizedBox(),
                    SizedBox(
                      width: widget.isSender ? 8 : 0,
                    ),
                    Text(
                      getTimeFromData(chat.createdAt!),
                      style: const TextStyle(fontSize: 8),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget makeAnOfferTextField({bool isPayType = false}) {
    return Container(
      padding: EdgeInsets.only(top: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isPayType)
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
              Expanded(
                child: TextField(
                  minLines: 1,
                  controller: messageController,
                  decoration: InputDecoration(
                    prefixIcon: isPayType
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: getPadding(left: 10, right: 5),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton2<String>(
                                    dropdownStyleData: const DropdownStyleData(
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
                                      selectedPayType = newValue!;
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
                              const SizedBox(width: 5)
                            ],
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
            ],
          ),
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

  void downloadFile(
    String url, {
    required String filePath,
    required String folderPath,
  }) async {
    try {
      if (!Directory(folderPath).existsSync()) {
        Directory(folderPath).createSync();
      }
      await Dio().download(
        url,
        filePath,
        onReceiveProgress: (received, total) async {
          int percentage = ((received / total) * 100).floor();
          _downloadProgress.value = percentage;
        },
      );
    } on Exception catch (e) {
      log("downloadFile:$e");
    }
  }
}
