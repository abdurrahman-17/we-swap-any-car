import 'dart:developer';

import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../bloc/user/user_bloc.dart';
import '../../../core/configurations.dart';
import '../../../core/locator.dart';
import '../../../model/chat_model/chat_group/chat_group_model.dart';
import '../../../model/user/user_model.dart';
import '../../../repository/chat_repo.dart';
import '../../../utility/debouncer.dart';
import '../../common_widgets/common_loader.dart';
import '../../common_widgets/common_popups.dart';
import '../widgets/chat_item_widget.dart';
import '../widgets/unread_widget.dart';
import 'blocked_user_screen.dart';
import 'user_chat_window.dart';

class ChatScreenNew extends StatefulWidget {
  static const String routeName = "chat_screen_new";
  const ChatScreenNew({
    Key? key,
    this.drawerOnTap,
    this.floatingActionButton,
    this.bottomNavigationBar,
  }) : super(key: key);
  final VoidCallback? drawerOnTap;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;

  @override
  State<ChatScreenNew> createState() => ChatScreenNewState();
}

class ChatScreenNewState extends State<ChatScreenNew> {
  final TextEditingController textEditingController = TextEditingController();
  final ValueNotifier<bool> searchValue = ValueNotifier<bool>(false);
  final _debouncer = Debouncer();
  bool clear = false;
  Stream<List<ChatGroupModel>>? recentChatListStream;
  List<ChatGroupModel> recentChats = [];
  final bool isGuest = false;
  String userIdOrAdminUserId = '';

  @override
  void initState() {
    UserModel? currentUserData = context.read<UserBloc>().currentUser;
    if (currentUserData?.userType == convertEnumToString(UserType.private)) {
      userIdOrAdminUserId = currentUserData?.userId ?? '';
    } else {
      userIdOrAdminUserId = currentUserData?.trader?.adminUserId ?? '';
    }

    recentChatListStream = Locator.instance
        .get<ChatRepo>()
        .retrieveRecentChats(userId: userIdOrAdminUserId);
    super.initState();
  }

  ///search from recent list
  void search(String search, List<ChatGroupModel> chatList) async {
    ///refreshing list view
    _debouncer.run(() {
      log(search);
      searchValue.value = true;
      recentChats = chatList
          .where((element) => element.carDetails!.carName!
              .toLowerCase()
              .contains(search.toLowerCase()))
          .toList();
      searchValue.value = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomDrawerScaffold(
      backgroundColor: ColorConstant.kBackgroundColor,
      title: chatNavAppBar,
      drawerOnTap: widget.drawerOnTap,
      actions: [
        CustomImageView(
          svgPath: Assets.blockUserIcon,
          margin: getMargin(left: 20.w, right: 25.w),
          onTap: () {
            Navigator.pushNamed(context, BlockedUsersScreen.routeName);
          },
        ),
      ],
      body: Stack(
        children: [
          CustomImageView(
            alignment: Alignment.bottomCenter,
            svgPath: Assets.homeBackground,
            width: size.width,
            fit: BoxFit.fitWidth,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: getHorizontalSize(25),
              vertical: getVerticalSize(20),
            ),
            child: StreamBuilder<List<ChatGroupModel>>(
              stream: recentChatListStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  recentChats = snapshot.data ?? [];
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CommonTextFormField(
                        onChanged: (value) {
                          if (textEditingController.text.isNotEmpty) {
                            if (!clear) {
                              setState(() => clear = true);
                            }
                          } else {
                            if (clear) {
                              setState(() => clear = false);
                            }
                          }
                          search(value, snapshot.data ?? []);
                        },
                        controller: textEditingController,
                        hint: searchText,
                        suffixIcon: clear
                            ? IconButton(
                                onPressed: () {
                                  textEditingController.clear();
                                  setState(() {
                                    clear = false;
                                  });
                                },
                                icon: Icon(
                                  Icons.clear,
                                  color: Colors.grey.shade600,
                                ),
                              )
                            : IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.search_outlined,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                      ),
                      ScrollConfiguration(
                        behavior: MyBehavior(),
                        child: Expanded(
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: getPadding(bottom: 15),
                              child: ValueListenableBuilder<bool>(
                                valueListenable: searchValue,
                                builder: (BuildContext context, bool value,
                                    Widget? _) {
                                  if (value) {
                                    return const Center(child: LottieLoader());
                                  }
                                  if (recentChats.isEmpty) {
                                    return emptyChat();
                                  }

                                  ///delete count
                                  int deletedChatCount = 0;
                                  return ListView.separated(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    separatorBuilder: (context, index) {
                                      return SizedBox(
                                          height: getVerticalSize(14.00));
                                    },
                                    itemCount: recentChats.length,
                                    itemBuilder: (context, index) {
                                      //recent chat item
                                      final ChatGroupModel chatGroupItem =
                                          recentChats[index];
                                      if (chatGroupItem.deleteChat?[
                                              userIdOrAdminUserId] !=
                                          null) {
                                        final DateTime deletedDateTime =
                                            chatGroupItem.deleteChat![
                                                    userIdOrAdminUserId]
                                                .toDate() as DateTime;
                                        final DateTime updatedAt =
                                            chatGroupItem.updatedAt!;
                                        if (deletedDateTime
                                                .isAfter(updatedAt) ||
                                            deletedDateTime
                                                .isAtSameMomentAs(updatedAt)) {
                                          deletedChatCount++;

                                          ///all the chats are deleted
                                          if (recentChats.length ==
                                              deletedChatCount) {
                                            return emptyChat();
                                          }
                                          return const SizedBox();
                                        }
                                      }

                                      ///checking whether the current
                                      ///user is muted the chat or not
                                      bool isMutedUser = chatGroupItem
                                          .mutedUsers
                                          .contains(userIdOrAdminUserId);
                                      return Slidable(
                                        key: const ValueKey(0),
                                        startActionPane: ActionPane(
                                          extentRatio: 0.3,
                                          motion: const DrawerMotion(),
                                          children: [
                                            SlidableAction(
                                              onPressed: (_) async =>
                                                  muteUnMuteUser(
                                                isMutedUser: isMutedUser,
                                                chatGroupItem: chatGroupItem,
                                              ),
                                              backgroundColor:
                                                  Colors.transparent,
                                              foregroundColor: ColorConstant
                                                  .kPrimaryLightRed,
                                              icon: isMutedUser
                                                  ? Icons.volume_up_rounded
                                                  : Icons.volume_off,
                                              label:
                                                  isMutedUser ? unMute : mute,
                                              padding: const EdgeInsets.all(2),
                                            ),
                                            SlidableAction(
                                              onPressed: (_) async =>
                                                  onClearChat(chatGroupItem),
                                              backgroundColor:
                                                  Colors.transparent,
                                              foregroundColor: ColorConstant
                                                  .kPrimaryLightRed,
                                              icon: Icons
                                                  .cleaning_services_outlined,
                                              padding: const EdgeInsets.all(2),
                                              label: clearTitle.toProperCase(),
                                            ),
                                          ],
                                        ),
                                        endActionPane: ActionPane(
                                          extentRatio: 0.3,
                                          motion: const DrawerMotion(),
                                          children: [
                                            SlidableAction(
                                              onPressed: (_) async =>
                                                  onDeleteChat(chatGroupItem),
                                              backgroundColor:
                                                  Colors.transparent,
                                              foregroundColor: ColorConstant
                                                  .kPrimaryLightRed,
                                              icon: Icons.delete,
                                              padding: const EdgeInsets.all(2),
                                              label: deleteTitle.toProperCase(),
                                            ),
                                            SlidableAction(
                                              onPressed: (_) async =>
                                                  onBlockUser(chatGroupItem),
                                              backgroundColor:
                                                  Colors.transparent,
                                              foregroundColor: ColorConstant
                                                  .kPrimaryLightRed,
                                              icon: Icons.block,
                                              padding: const EdgeInsets.all(2),
                                              label: blockTiitle.toProperCase(),
                                            ),
                                          ],
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              top: index == 0
                                                  ? getVerticalSize(10)
                                                  : 0),
                                          child: ChatItemWidget(
                                            currentUserId: userIdOrAdminUserId,
                                            chatGroup: chatGroupItem,
                                            onTap: () {
                                              Navigator.pushNamed(context,
                                                  UserChatScreen.routeName,
                                                  arguments: {
                                                    "chatGroup": chatGroupItem,
                                                    "userIdOrAdminUserId":
                                                        userIdOrAdminUserId
                                                  });
                                            },
                                            unreadWidget: UnreadWidget(
                                              groupId: chatGroupItem.groupId!,
                                              userIdOrAdminUserId:
                                                  userIdOrAdminUserId,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }

                return ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (_, __) {
                    return shimmerLoader(
                      Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: ColorConstant.kColorWhite,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (__, _) {
                    return const SizedBox(
                      height: 10,
                    );
                  },
                  itemCount: 8,
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: widget.floatingActionButton,
      bottomNavigationBar: widget.bottomNavigationBar,
    );
  }

  Widget emptyChat() {
    return Container(
      alignment: Alignment.center,
      height: getVerticalSize(size.height / 1.5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomImageView(
            svgPath: Assets.bottomChat,
            height: getSize(50),
            width: getSize(50),
          ),
          Padding(
            padding: getPadding(top: 25.h, bottom: 39.h),
            child: Text(
              noChatAvailable,
              style: AppTextStyle.regularTextStyle.copyWith(
                fontSize: getFontSize(16),
                color: ColorConstant.kColor606060,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> muteUnMuteUser({
    bool isMutedUser = false,
    required ChatGroupModel chatGroupItem,
  }) async {
    bool result = await confirmationPopup(
      title: (isMutedUser ? unMute : mute).toUpperCase(),
      message:
          "Are you sure you want to ${isMutedUser ? unMute : mute} this chat?",
      messageTextAlign: TextAlign.center,
      isQuestion: true,
    );
    if (result) {
      if (isMutedUser) {
        Locator.instance.get<ChatRepo>().unMuteChat(
              userId: userIdOrAdminUserId,
              groupId: chatGroupItem.groupId!,
            );
      } else {
        Locator.instance.get<ChatRepo>().muteChat(
              userId: userIdOrAdminUserId,
              groupId: chatGroupItem.groupId!,
            );
      }
    }
  }

  Future<void> onClearChat(ChatGroupModel chatGroupItem) async {
    bool result = await confirmationPopup(
      title: clearTitle,
      message: areYouSureWantToClearThisChat,
      messageTextAlign: TextAlign.center,
      isQuestion: true,
    );
    if (result) {
      Locator.instance.get<ChatRepo>().clearChat(
            userId: userIdOrAdminUserId,
            groupId: chatGroupItem.groupId!,
          );
    }
  }

  Future<void> onDeleteChat(ChatGroupModel chatGroupItem) async {
    bool result = await confirmationPopup(
      title: deleteTitle,
      message: areYouSureWantToDeleteThisChat,
      messageTextAlign: TextAlign.center,
      isQuestion: true,
    );
    if (result) {
      await Locator.instance.get<ChatRepo>().deleteChat(
            userId: userIdOrAdminUserId,
            groupId: chatGroupItem.groupId!,
          );
    }
  }

  Future<void> onBlockUser(ChatGroupModel chatGroupItem) async {
    bool result = await confirmationPopup(
      title: blockTiitle,
      message: areYouSureWantToBlockThisUser,
      messageTextAlign: TextAlign.center,
      isQuestion: true,
    );
    if (result) {
      progressDialogue();
      await Locator.instance.get<ChatRepo>().blockChat(
            userId: userIdOrAdminUserId,
            groupId: chatGroupItem.groupId!,
            oppositeUserId: chatGroupItem.groupUsers[0] == userIdOrAdminUserId
                ? "${chatGroupItem.groupUsers[1]}"
                : "${chatGroupItem.groupUsers[0]}",
          );
      if (!mounted) return;
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _debouncer.dispose();
    textEditingController.dispose();
    super.dispose();
  }
}
