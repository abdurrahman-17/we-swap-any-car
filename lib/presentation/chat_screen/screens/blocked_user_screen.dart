import 'dart:developer';

import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../bloc/user/user_bloc.dart';
import '../../../core/configurations.dart';
import '../../../core/locator.dart';
import '../../../main.dart';
import '../../../model/chat_model/chat_group/chat_group_model.dart';
import '../../../model/user/user_model.dart';
import '../../../repository/chat_repo.dart';
import '../../../utility/debouncer.dart';
import '../../common_widgets/common_loader.dart';
import '../../common_widgets/common_popups.dart';
import '../../common_widgets/custom_text_widget.dart';
import '../widgets/chat_item_widget.dart';

class BlockedUsersScreen extends StatefulWidget {
  static const String routeName = 'blocked_users';
  const BlockedUsersScreen({super.key});

  @override
  State<BlockedUsersScreen> createState() => _BlockedUsersScreenState();
}

class _BlockedUsersScreenState extends State<BlockedUsersScreen> {
  final TextEditingController textEditingController = TextEditingController();
  final ValueNotifier<bool> searchValue = ValueNotifier<bool>(false);
  final _debouncer = Debouncer();
  bool clear = false;
  Stream<List<ChatGroupModel>>? blockedChatsListStream;
  List<ChatGroupModel> recentChats = [];

  String userIdOrAdminUserId = '';

  @override
  void initState() {
    UserModel? currentUserData = context.read<UserBloc>().currentUser;
    if (currentUserData?.userType == convertEnumToString(UserType.private)) {
      userIdOrAdminUserId = currentUserData?.userId ?? '';
    } else {
      userIdOrAdminUserId = currentUserData?.trader?.adminUserId ?? '';
    }

    blockedChatsListStream = Locator.instance
        .get<ChatRepo>()
        .retrieveBlockedChats(userId: userIdOrAdminUserId);
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
    return CustomScaffold(
      backgroundColor: ColorConstant.kBackgroundColor,
      title: chatBlockedUserAppBar,
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
              stream: blockedChatsListStream,
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
                                  setState(() => clear = false);
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
                                    return SizedBox(
                                      height: size.height / 1.5,
                                      child: const CenterText(
                                          text: "No blocked users"),
                                    );
                                  }

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

                                      return Slidable(
                                        key: const ValueKey(0),
                                        endActionPane: ActionPane(
                                          extentRatio: 0.3,
                                          motion: const DrawerMotion(),
                                          children: [
                                            SlidableAction(
                                              onPressed: (_) async =>
                                                  onTapUnblock(chatGroupItem),
                                              backgroundColor:
                                                  Colors.transparent,
                                              foregroundColor: ColorConstant
                                                  .kPrimaryLightRed,
                                              icon: Icons.check_circle_outlined,
                                              padding: const EdgeInsets.all(2),
                                              label: unblockTiitle,
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
                                            onTap: () {},
                                            unreadWidget: const CustomImageView(
                                              height: 18,
                                              width: 18,
                                              svgPath: Assets.blockIcon,
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
    );
  }

  Future<void> onTapUnblock(ChatGroupModel chatGroupItem) async {
    bool result = await confirmationPopup(
      title: unblockTiitle,
      message: areYouSureWantToUnblockThisUser,
      messageTextAlign: TextAlign.center,
      isQuestion: true,
    );
    if (result) {
      progressDialogue();

      await Locator.instance.get<ChatRepo>().unblockChat(
            userId: userIdOrAdminUserId,
            groupId: chatGroupItem.groupId!,
            oppositeUserId: chatGroupItem.groupUsers[0] == userIdOrAdminUserId
                ? "${chatGroupItem.groupUsers[1]}"
                : "${chatGroupItem.groupUsers[0]}",
          );

      Navigator.pop(globalNavigatorKey.currentContext!);
    }
  }

  @override
  void dispose() {
    _debouncer.dispose();
    textEditingController.dispose();
    super.dispose();
  }
}
