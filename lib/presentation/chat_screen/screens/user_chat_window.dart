import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/scheduler.dart';

import 'package:wsac/utility/file_utils.dart';

import '../../../bloc/chat/chat_bloc.dart';
import '../../../model/chat_model/chat_group/chat_user_model.dart';
import '../../../repository/user_repo.dart';
import '../../../core/configurations.dart';
import '../../../core/locator.dart';
import '../../../model/chat_model/chat_group/chat_group_model.dart';
import '../../../model/chat_model/user_chat_model/user_chat_model.dart';
import '../../../repository/chat_repo.dart';
import '../../../utility/chat_utils.dart';
import '../../../utility/date_time_utils.dart';
import '../../common_widgets/common_loader.dart';
import '../../common_widgets/custom_text_widget.dart';
import '../widgets/message_box.dart';
import '../widgets/message_input.dart';
import '../widgets/selected_car_item_widget.dart';

class UserChatScreen extends StatefulWidget {
  static const String routeName = "user_chat_screen";

  const UserChatScreen({
    Key? key,
    required this.chatGroup,
    required this.userIdOrAdminUserId,
    this.selectedIndex,
  }) : super(key: key);

  final ChatGroupModel chatGroup;
  final int? selectedIndex;
  final String userIdOrAdminUserId;

  @override
  State<UserChatScreen> createState() => _UserChatScreenState();
}

class _UserChatScreenState extends State<UserChatScreen> {
  late ChatBloc chatBloc;
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<bool> _refreshLoader = ValueNotifier<bool>(false);
  final StreamController<List<DocumentSnapshot>> _streamController =
      StreamController<List<DocumentSnapshot>>();
  final List<DocumentSnapshot> _products = [];

  num? rating;
  bool _isRequesting = false;
  bool _isFinish = false;
  bool _isFirst = false;
  final int docLimit = 20;
  bool _autoScrollTOBottom = true;
  bool isEmptyChat = false;
  List<UserChatModel> tempAttachmentUploading = [];

  void onChangeData(List<DocumentChange> documentChanges) {
    if (documentChanges.isEmpty) {
      isEmptyChat = true;
      setState(() {});
    }
    bool isChange = false;
    for (var productChange in documentChanges) {
      if (productChange.type == DocumentChangeType.removed) {
        _products.removeWhere((product) {
          return productChange.doc.id == product.id;
        });
        isChange = true;
      } else if (productChange.type == DocumentChangeType.added && !_isFirst) {
        _autoScrollTOBottom = true;
        _products.add(productChange.doc);
        isChange = true;
      } else {
        if (productChange.type == DocumentChangeType.modified) {
          int indexWhere = _products.indexWhere((product) {
            return productChange.doc.id == product.id;
          });

          if (indexWhere >= 0) {
            _products[indexWhere] = productChange.doc;
          }
          isChange = true;
        }
      }
    }

    if (isChange) {
      _streamController.add(_products);
    }
  }

  /// pagination
  void requestNextPage() async {
    if (!_isRequesting && !_isFinish) {
      QuerySnapshot querySnapshot;
      _isRequesting = true;
      if (_products.isEmpty) {
        _isFirst = true;
        querySnapshot = await Locator.instance.get<ChatRepo>().getChats(
              groupId: widget.chatGroup.groupId ?? '',
              docLimit: docLimit,
            );
      } else {
        _refreshLoader.value = true;
        querySnapshot =
            querySnapshot = await Locator.instance.get<ChatRepo>().getChats(
                  groupId: widget.chatGroup.groupId ?? '',
                  docLimit: docLimit,
                  lastDoc: _products[_products.length - 1],
                );
      }

      _isFirst = false;
      int oldSize = _products.length;
      _products.addAll(querySnapshot.docs);

      int newSize = _products.length;
      if (oldSize != newSize) {
        _streamController.add(_products);
      } else {
        _isFinish = true;
      }
      _isRequesting = false;
      _refreshLoader.value = false;
    }
  }

  @override
  void initState() {
    log("GroupId:${widget.chatGroup.groupId}");
    chatBloc = context.read<ChatBloc>();
    if (widget.chatGroup.carDetails?.userId ==
        widget.chatGroup.groupAdminUserId) {
      rating = widget.chatGroup.admin?.rating;
    } else {
      rating = widget.chatGroup.receiver?.rating;
    }

    requestNextPage();
    //stream listener
    Locator.instance
        .get<ChatRepo>()
        .retrieveChatInfo(groupId: widget.chatGroup.groupId!)
        .listen((data) => onChangeData(data.docChanges));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: CustomScaffold(
        backgroundColor: const Color(0xffF6F6F6),
        resizeToAvoidBottomInset: true,
        title: "CHAT",
        body: Column(
          children: [
            Expanded(
              child: ScrollConfiguration(
                behavior: MyBehavior(),
                child: NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollEnd) {
                    final metrics = scrollEnd.metrics;
                    if (metrics.atEdge) {
                      bool isTop = metrics.pixels == 0;
                      if (isTop) {
                        log('At the top');
                        requestNextPage();
                      }
                    }
                    return true;
                  },
                  child: ListView(
                    controller: _scrollController,
                    children: [
                      //SELECTED CAR DETAILS
                      SelectedCarItemWidget(
                        userIdOrAdminUserId: widget.userIdOrAdminUserId,
                        groupId: widget.chatGroup.groupId!,
                        rating: rating,
                        userName: widget.chatGroup.groupAdminUserId! ==
                                widget.chatGroup.carDetails!.userId!
                            ? widget.chatGroup.admin?.userName ?? ''
                            : widget.chatGroup.receiver?.userName ?? '',
                        carName: widget.chatGroup.carDetails?.carName ?? '',
                        carImage: widget.chatGroup.carDetails?.carImage ?? '',
                        groupUsers: widget.chatGroup.groupUsers,
                      ),

                      ValueListenableBuilder<bool>(
                          valueListenable: _refreshLoader,
                          builder: (BuildContext context, bool value,
                              Widget? child) {
                            return value
                                ? const Center(child: CircularLoader())
                                : const SizedBox();
                          }),
                      //CHAT
                      StreamBuilder<List<DocumentSnapshot>>(
                        stream: _streamController.stream,
                        builder: (context,
                            AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.active) {
                            if (_products.isEmpty) {
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical:
                                        MediaQuery.of(context).size.height / 4),
                                child: const CenterText(text: "No messages.."),
                              );
                            }

                            ///SORTING CHATS
                            final sortedList = sortChatList(_products);

                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (_, index) {
                                SchedulerBinding.instance
                                    .addPostFrameCallback((_) {
                                  if (_autoScrollTOBottom) {
                                    _autoScrollTOBottom = false;
                                    _scrollController.jumpTo(_scrollController
                                            .position.maxScrollExtent +
                                        300);
                                  }
                                });

                                final UserChatModel chatItem =
                                    UserChatModel.fromJson(sortedList[index]
                                        .data() as Map<String, dynamic>);

                                DateTime previousChatDate = getDateOnly(
                                    (sortedList[index == 0 ? index : index - 1]
                                            ['createdAt'] as Timestamp)
                                        .toDate());

                                //chat createdTime
                                final chatCreatedDateTime = chatItem.createdAt!;
                                //checking sender or not
                                final bool isSender =
                                    widget.userIdOrAdminUserId ==
                                        chatItem.createdUserId;

                                //update read status
                                if (chatItem.createdUserId !=
                                        widget.userIdOrAdminUserId &&
                                    !chatItem.readUsers
                                        .contains(widget.userIdOrAdminUserId)) {
                                  chatBloc.add(UpdateChatReadStatusEvent(
                                      groupId: chatItem.groupId!,
                                      chatDocId: chatItem.id!,
                                      userId: widget.userIdOrAdminUserId));
                                }

                                ///checking clear chat
                                if (widget.chatGroup.clearChat?[
                                        widget.userIdOrAdminUserId] !=
                                    null) {
                                  final DateTime chatClearedDateTime = widget
                                      .chatGroup
                                      .clearChat?[widget.userIdOrAdminUserId]
                                      .toDate() as DateTime;

                                  if (chatCreatedDateTime
                                      .isBefore(chatClearedDateTime)) {
                                    return const SizedBox();
                                  }
                                }
                                return Column(
                                  children: [
                                    groupHeader(
                                      previousChatDate,
                                      chatCreatedDateTime,
                                      index,
                                    ),
                                    chatItemWidget(
                                        isSender,
                                        index,
                                        sortedList.length,
                                        chatItem,
                                        widget.chatGroup),
                                  ],
                                );
                              },
                              itemCount: sortedList.length,
                            );

                            // return GroupedListView<dynamic, String>(
                            //   shrinkWrap: true,
                            //   physics: const NeverScrollableScrollPhysics(),
                            //   elements: sortedList,
                            //   groupBy: (element) => customDateFormat(
                            //    (element['createdAt'] as Timestamp).toDate()),
                            //   indexedItemBuilder: (context, element, index) {
                            //     SchedulerBinding.instance
                            //         .addPostFrameCallback((_) {
                            //       if (_autoScrollTOBottom) {
                            //         _autoScrollTOBottom = false;
                            //       _scrollController.jumpTo(_scrollController
                            //                 .position.maxScrollExtent +
                            //             300);
                            //       }
                            //     });
                            //     final UserChatModel chatItem =
                            //         UserChatModel.fromJson(
                            //          element.data() as Map<String, dynamic>);
                            //     final bool isSender =
                            //         widget.userIdOrAdminUserId ==
                            //             chatItem.createdUserId;

                            //     //update read status
                            //     if (chatItem.createdUserId !=
                            //             widget.userIdOrAdminUserId &&
                            //         !chatItem.readUsers
                            //         .contains(widget.userIdOrAdminUserId)) {
                            //       chatBloc.add(UpdateChatReadStatusEvent(
                            //           groupId: chatItem.groupId!,
                            //           chatDocId: chatItem.id!,
                            //           userId: widget.userIdOrAdminUserId));
                            //     }

                            //     ///checking clear chat
                            //     if (widget.chatGroup.clearChat?[
                            //             widget.userIdOrAdminUserId] !=
                            //         null) {
                            //       final DateTime chatClearedDateTime = widget
                            //           .chatGroup
                            //           .clearChat?[widget.userIdOrAdminUserId]
                            //           .toDate() as DateTime;
                            //       final chatCreatedDateTime =
                            //           chatItem.createdAt!;
                            //       if (chatCreatedDateTime
                            //           .isBefore(chatClearedDateTime)) {
                            //         return const SizedBox();
                            //       }
                            //     }

                            //     return chatItemWidget(
                            //         isSender,
                            //         index,
                            //         sortedList.length,
                            //         chatItem,
                            //         widget.chatGroup);
                            //   },
                            //   groupHeaderBuilder: (element) {
                            //     final UserChatModel chatItem =
                            //         UserChatModel.fromJson(
                            //         element.data() as Map<String, dynamic>);

                            //     ///checking clear chat
                            //     if (widget.chatGroup.clearChat?[
                            //             widget.userIdOrAdminUserId] !=
                            //         null) {
                            //       final DateTime chatClearedDateTime = widget
                            //           .chatGroup
                            //           .clearChat?[widget.userIdOrAdminUserId]
                            //           .toDate() as DateTime;
                            //       final chatCreatedDateTime =
                            //           chatItem.createdAt!;
                            //       if (chatCreatedDateTime
                            //           .isBefore(chatClearedDateTime)) {
                            //         return const SizedBox();
                            //       }
                            //     }
                            //     return Padding(
                            //       padding: getPadding(top: 12, bottom: 12),
                            //       child: Text(
                            //         convertDateTimeToDayFormat(
                            //             chatItem.createdAt!),
                            //         textAlign: TextAlign.center,
                            //         style: const TextStyle(fontSize: 12),
                            //       ),
                            //     );
                            //   },
                            // );
                          } else if (snapshot.connectionState ==
                                  ConnectionState.waiting &&
                              isEmptyChat) {
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical:
                                      MediaQuery.of(context).size.height / 4),
                              child: const CenterText(text: "No messages.."),
                            );
                          }
                          return const Center(
                            child: LottieLoader(),
                          );
                        },
                      ),
                      if (tempAttachmentUploading.isNotEmpty)
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (_, int index) {
                            final chatItem = tempAttachmentUploading[index];
                            return chatItemWidget(
                                true,
                                index,
                                tempAttachmentUploading.length,
                                chatItem,
                                widget.chatGroup);
                          },
                          separatorBuilder: (_, __) {
                            return const SizedBox(
                              height: 5,
                            );
                          },
                          itemCount: tempAttachmentUploading.length,
                        ),
                    ],
                  ),
                ),
              ),
            ),
            MessageInput(
              currentUserId: widget.userIdOrAdminUserId,
              chatGroup: widget.chatGroup,
              selectedIndex: widget.selectedIndex ?? 0,
              userIdOrAdminUserId: widget.userIdOrAdminUserId,
              insertChat: (chat) async {
                attachmentCheckAndInsert(chat);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget groupHeader(
    DateTime pre,
    DateTime now,
    int index,
  ) {
    final header = Padding(
      padding: getPadding(top: 12, bottom: 12),
      child: Text(
        convertDateTimeToDayFormat(now),
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 12),
      ),
    );
    if (index == 0 || !pre.isAtSameMomentAs(getDateOnly(now))) {
      return header;
    } else {
      return const SizedBox();
    }
  }

  Widget chatItemWidget(
    bool isSender,
    int index,
    int length,
    UserChatModel chatItem,
    ChatGroupModel chatGroup,
  ) {
    return Padding(
      padding: EdgeInsets.only(
        left: chatItem.type == convertEnumToString(MessageType.normal)
            ? isSender
                ? 91.w
                : 16.w
            : 16.w,
        right: chatItem.type == convertEnumToString(MessageType.normal)
            ? !isSender
                ? 91.w
                : 16.w
            : 16.w,
        bottom: 10.h,
      ),
      child: MessageBox(
        isSender: isSender,
        chat: chatItem,
        chatGroup: chatGroup,
        currentUserId: widget.userIdOrAdminUserId,
      ),
    );
  }

  Future<bool> _onBackPressed() async {
    Navigator.pop(context);
    return true;
  }

  void refresh() {
    setState(() {});
  }

  Future<void> attachmentCheckAndInsert(UserChatModel chat) async {
    ChatUserModel? seller = widget.chatGroup.receiver;
    ChatUserModel? buyer = widget.chatGroup.admin;
    if (widget.chatGroup.carDetails?.userId ==
        widget.chatGroup.groupAdminUserId) {
      seller = widget.chatGroup.admin;
      buyer = widget.chatGroup.receiver;
    }
    final chatBloc = context.read<ChatBloc>();

    ///attachment
    if (chat.payload?.messageModel?.attachments != null) {
      final attachment = chat.payload?.messageModel?.attachments!;
      _autoScrollTOBottom = true;
      tempAttachmentUploading.add(chat);
      refresh();
      if (attachment!.images.isNotEmpty) {
        for (int i = 0; i < attachment.images.length; i++) {
          final file = File(attachment.images[i].filePath!);
          final url = await Locator.instance
              .get<UserRepo>()
              .uploadFile(filePath: file.path, fileName: file.name);
          if (url != null) {
            chat.payload!.messageModel!.attachments!.images[i].url =
                getEncodedUrl(url);
          }
        }

        tempAttachmentUploading.remove(chat);
        _autoScrollTOBottom = true;
        refresh();
        // chat.payload!.messageModel!.attachments!.images[0].url = url;
      }
      // else if (attachment.documents.isNotEmpty) {
      //   final file = File(attachment.documents[0].filePath!);
      //   final url = await Locator.instance
      //       .get<UserRepo>()
      //       .uploadFile(filePath: file.path, fileName: file.name);
      //   tempAttachmentUploading.remove(chat);
      //   _autoScrollTOBottom = true;
      //   refresh();
      //   chat.payload!.messageModel!.attachments!.documents[0].url = url;
      // } else if (attachment.videos.isNotEmpty) {
      //   final file = File(attachment.videos[0].filePath!);
      //   final url = await Locator.instance
      //       .get<UserRepo>()
      //       .uploadFile(filePath: file.path, fileName: file.name);
      //   tempAttachmentUploading.remove(chat);
      //   _autoScrollTOBottom = true;
      //   refresh();
      //   chat.payload!.messageModel!.attachments!.videos[0].url = url;
      // }
      chatBloc.add(InsertChatEvent(
          chatModel: chat,
          seller: seller,
          buyer: buyer,
          car: widget.chatGroup.carDetails));
    } else {
      chatBloc.add(InsertChatEvent(
          chatModel: chat,
          seller: seller,
          buyer: buyer,
          car: widget.chatGroup.carDetails));
    }
  }
}
