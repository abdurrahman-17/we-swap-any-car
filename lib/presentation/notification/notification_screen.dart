import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wsac/presentation/common_widgets/custom_text_widget.dart';
import '../../bloc/user/user_bloc.dart';
import '../../core/configurations.dart';
import '../../core/locator.dart';
import '../../model/notification/notification_model.dart';
import '../../model/user/user_model.dart';
import '../../repository/notification_repo.dart';
import '../common_widgets/common_loader.dart';

class NotificationScreen extends StatefulWidget {
  static const String routeName = 'notification_screen';
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  int pageCount = 100;
  bool _isFirst = false;
  UserModel? currentUser;
  final List<DocumentSnapshot> _products = [];
  List<NotificationModel> notificationData = [];
  final StreamController<List<DocumentSnapshot>> _streamController =
      StreamController<List<DocumentSnapshot>>();
  ScrollController notificationScrollController = ScrollController();
  final ValueNotifier<bool> _refreshLoader = ValueNotifier<bool>(false);

  @override
  void initState() {
    initialData();
    Locator.instance
        .get<NotificationRepo>()
        .retrieveNotificationInfo(userId: currentUser!.userId!)
        .listen((data) => onChangeData(data.docChanges));
    super.initState();
  }

  @override
  void dispose() {
    notificationScrollController.removeListener(() {});
    super.dispose();
  }

  //Initial Notification List
  void initialData() async {
    currentUser = context.read<UserBloc>().currentUser;
    _isFirst = true;
    var querySnapshot = await Locator.instance
        .get<NotificationRepo>()
        .getNotificationList(
            userId: currentUser!.userId!, pageLimit: pageCount);
    assignData(querySnapshot);
    requestNextData();
    //stream listener
  }

  //Pagination Data
  void requestNextData() {
    notificationScrollController.addListener(() async {
      if (notificationScrollController.offset ==
              notificationScrollController.position.maxScrollExtent &&
          notificationData.length >= pageCount) {
        _refreshLoader.value = true;
        var querySnapshot = await Locator.instance
            .get<NotificationRepo>()
            .getNotificationList(
                userId: currentUser!.userId!,
                pageLimit: pageCount,
                lastDoc: _products[_products.length - 1]);
        assignData(querySnapshot);
        _refreshLoader.value = false;
      }
    });
  }

  //Assigning The Data
  void assignData(QuerySnapshot querySnapshot) {
    _isFirst = false;
    _products.addAll(querySnapshot.docs);
    _streamController.add(_products);
    for (var element in querySnapshot.docs) {
      Map<String, dynamic> map = element.data() as Map<String, dynamic>;
      notificationData.add(NotificationModel.fromJson(map));
    }
  }

  void onChangeData(List<DocumentChange> documentChanges) {
    bool isChange = false;
    for (var productChange in documentChanges) {
      if (productChange.type == DocumentChangeType.removed) {
        int indexWhere = _products.indexWhere((product) {
          return productChange.doc.id == product.id;
        });
        _products.removeAt(indexWhere);
        notificationData.removeAt(indexWhere);
        isChange = true;
      } else if (productChange.type == DocumentChangeType.added && !_isFirst) {
        if (notificationScrollController.hasClients &&
            notificationScrollController.offset !=
                notificationScrollController.position.minScrollExtent) {
          notificationScrollController.position
              .jumpTo(notificationScrollController.position.minScrollExtent);
        }
        _products.insert(0, productChange.doc);
        Map<String, dynamic> map =
            productChange.doc.data() as Map<String, dynamic>;
        notificationData.insert(0, NotificationModel.fromJson(map));
        isChange = true;
      } else {
        if (productChange.type == DocumentChangeType.modified) {
          int indexWhere = _products.indexWhere((product) {
            return productChange.doc.id == product.id;
          });

          if (indexWhere >= 0) {
            _products[indexWhere] = productChange.doc;
            Map<String, dynamic> map =
                productChange.doc.data() as Map<String, dynamic>;
            notificationData[indexWhere] = NotificationModel.fromJson(map);
          }
          isChange = true;
        }
      }
    }

    if (isChange) {
      _streamController.add(_products);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: notificationAppBar,
      body: Stack(
        children: [
          CustomImageView(
            svgPath: Assets.homeBackground,
            fit: BoxFit.fill,
            alignment: Alignment.bottomCenter,
            width: MediaQuery.of(context).size.width,
          ),
          SafeArea(
            child: StreamBuilder<List<DocumentSnapshot>>(
              stream: _streamController.stream,
              builder: (BuildContext context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  return notificationData.isNotEmpty
                      ? ListView.separated(
                          shrinkWrap: true,
                          controller: notificationScrollController,
                          physics: const BouncingScrollPhysics(),
                          padding: getPadding(
                            top: 10.h,
                            bottom: 10.h,
                            left: 20.w,
                            right: 20.w,
                          ),
                          itemCount: notificationData.length,
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 10.h),
                          itemBuilder: (context, index) {
                            return notificationTextWidget(
                                notificationData[index].message!);
                          },
                        )
                      : const CenterText(text: "No Notifications");
                }

                return ListView.separated(
                  shrinkWrap: true,
                  padding: getPadding(
                    top: 10.h,
                    bottom: 10.h,
                    left: 20.w,
                    right: 20.w,
                  ),
                  itemCount: 8,
                  separatorBuilder: (__, _) => SizedBox(height: 10.h),
                  itemBuilder: (_, __) {
                    return shimmerLoader(
                      Container(
                        padding: getPadding(
                          top: 12.h,
                          bottom: 12.h,
                          left: 17.w,
                          right: 17.w,
                        ),
                        height: 50,
                        decoration: BoxDecoration(
                          color: ColorConstant.kColorWhite,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          ValueListenableBuilder<bool>(
              valueListenable: _refreshLoader,
              builder: (BuildContext context, bool value, Widget? child) {
                return value
                    ? const Center(child: CircularLoader())
                    : const SizedBox();
              })
        ],
      ),
    );
  }

  Widget notificationTextWidget(String text) {
    return Container(
      padding: getPadding(
        top: 12.h,
        bottom: 12.h,
        left: 17.w,
        right: 17.w,
      ),
      decoration: BoxDecoration(
        color: ColorConstant.kColorWhite,
        border: Border.all(color: ColorConstant.kColorE4E4E4),
        borderRadius: BorderRadius.circular(25.r),
      ),
      child: Text(
        text,
        style: AppTextStyle.regularTextStyle
            .copyWith(color: ColorConstant.kColor7C7C7C),
      ),
    );
  }
}
