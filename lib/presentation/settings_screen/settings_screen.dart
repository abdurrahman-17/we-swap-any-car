import '../../bloc/user/user_bloc.dart';
import '../../core/configurations.dart';
import '../../model/user/user_model.dart';
import '../common_widgets/switch_item.dart';

class SettingsPage extends StatefulWidget {
  static const String routeName = "settings_screen";
  const SettingsPage({
    super.key,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notificationStatus = false;
  UserModel? user;

  @override
  void initState() {
    user = context.read<UserBloc>().currentUser;
    notificationStatus = user?.notifications == "enabled" ? true : false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UpdateUserNotificationSettingsState) {
          if (state.updateNotificationSettingsStatus ==
              ProviderStatus.success) {
            final String status =
                state.user?.notifications == "enabled" ? onLabel : offLabel;
            showSnackBar(message: '$notificationUpdateSuccessMsg $status');
          } else if (state.updateNotificationSettingsStatus ==
              ProviderStatus.error) {
            showSnackBar(message: notificationUpdateFailedMsg);
            setState(() {
              notificationStatus = notificationStatus ? false : true;
            });
          }
        }
      },
      child: CustomScaffold(
        title: settingsAppBar,
        body: Stack(
          children: [
            CustomImageView(
              svgPath: Assets.homeBackground,
              fit: BoxFit.fill,
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width,
            ),
            Padding(
              padding: getPadding(
                left: 30.w,
                right: 30.w,
                top: 20.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SwitchItemWidget(
                    switchLeftLabel: onLabel,
                    switchRightLabel: offLabel,
                    textStyle: AppTextStyle.txtPTSansBold14Bluegray900,
                    label: notification,
                    switchValue: notificationStatus,
                    onChanged: (value) {
                      setState(() {
                        notificationStatus = value;
                      });
                      if (value) {
                        BlocProvider.of<UserBloc>(context).add(
                            UpdateUserNotificationSettingsEvent(
                                status: "enabled", userId: user!.userId!));
                      } else {
                        BlocProvider.of<UserBloc>(context).add(
                            UpdateUserNotificationSettingsEvent(
                                status: "disabled", userId: user!.userId!));
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
