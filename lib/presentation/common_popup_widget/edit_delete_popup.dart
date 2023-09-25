import '../../core/configurations.dart';
import '../../main.dart';
import '../../model/car_model/car_model.dart';
import '../add_car/add_car_stepper_screen.dart';
import '../common_widgets/common_divider.dart';
import '../common_widgets/common_popups.dart';
import '../delete_questionnaire/delete_questionnaire_initial_screen.dart';

class EditDeletePopup extends StatefulWidget {
  const EditDeletePopup({Key? key, this.car}) : super(key: key);
  final CarModel? car;

  @override
  State<EditDeletePopup> createState() => _EditDeletePopupState();
}

class _EditDeletePopupState extends State<EditDeletePopup> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(
              context,
              AddCarStepperScreen.routeName,
              arguments: {'carModel': widget.car},
            );
          },
          child: Row(
            children: [
              Expanded(
                child: Text(
                  editPostMenu,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: AppTextStyle.txtPTSansRegular16Gray600,
                ),
              ),
              CustomImageView(
                color: ColorConstant.kColor7B7B7B,
                svgPath: Assets.editBox,
                height: getSize(18),
              ),
            ],
          ),
        ),
        Padding(
          padding: getPadding(top: 5.h, bottom: 5.h),
          child: CommonDivider(
            indent: 10,
            endIndent: 10,
            color: ColorConstant.kColorE4E4E4,
          ),
        ),
        InkWell(
          onTap: () async {
            Navigator.pop(context);
            bool result = await confirmationPopup(
              title: confirmButton,
              message: deletePostConfirm,
              isQuestion: true,
            );
            if (result) {
              Navigator.pushReplacementNamed(
                globalNavigatorKey.currentContext!,
                DeleteQuestionnaireInitialScreen.routeName,
                arguments: {
                  'carId': widget.car!.id,
                  'userId': widget.car!.userId!,
                  'surveyType': SurveyType.deletePost,
                },
              );
            }
          },
          child: Row(
            children: [
              Expanded(
                child: Text(
                  deletePostMenu,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: AppTextStyle.txtPTSansRegular16Gray600,
                ),
              ),
              CustomImageView(
                svgPath: Assets.trashIcon,
                fit: BoxFit.scaleDown,
                color: ColorConstant.kColor7B7B7B,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
