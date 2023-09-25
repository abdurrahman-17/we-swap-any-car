import '../../../bloc/car_details/car_details_bloc.dart';
import '../../../bloc/user/user_bloc.dart';
import '../../../model/user/user_model.dart';
import '../../../core/configurations.dart';
import '../../../model/car_model/car_model.dart';
import '../../common_widgets/common_admin_support_button.dart';
import '../../common_widgets/common_loader.dart';
import '../../common_widgets/field_label.dart';

class AddInformationScreen extends StatefulWidget {
  static const String routeName = 'add_information_screen';

  const AddInformationScreen({
    Key? key,
    this.carModel,
  }) : super(key: key);
  final CarModel? carModel;

  @override
  State<AddInformationScreen> createState() => _AddInformationScreenState();
}

class _AddInformationScreenState extends State<AddInformationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController attentionGraberController =
      TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController companyDescriptionController =
      TextEditingController();
  UserModel? user;

  @override
  void initState() {
    user = context.read<UserBloc>().currentUser;
    autoPopulateData();
    super.initState();
  }

  void autoPopulateData() {
    attentionGraberController.text =
        widget.carModel?.additionalInformation?.attentionGraber ?? '';
    descriptionController.text =
        widget.carModel?.additionalInformation?.description ?? '';
    companyDescriptionController.text =
        widget.carModel?.additionalInformation?.companyDescription ??
            user?.trader?.companyDescription ??
            '';
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CarDetailsBloc, CarDetailsState>(
      listener: (context, state) {
        if (state is UpdateCarInfoState &&
            state.carCreateStatus == CarCreateStatus.additionalInformation) {
          if (state.updateCarStatus == ProviderStatus.success) {
            Navigator.pop(context);
            CarModel? car = state.car;
            car?.hpiAndMot = widget.carModel?.hpiAndMot;
            Navigator.of(context).pop({'carModel': car});
          } else if (state.updateCarStatus == ProviderStatus.error) {
            Navigator.pop(context);
            showSnackBar(message: state.errorMessage ?? '');
          } else {
            progressDialogue();
          }
        }
      },
      child: CustomScaffold(
        title: addInfoAppBar,
        backWidget: const SizedBox(),
        actions: const [
          AdminSupportButton(),
        ],
        body: Form(
          key: _formKey,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomImageView(
                width: getHorizontalSize(size.width),
                svgPath: Assets.homeBackground,
                alignment: Alignment.bottomCenter,
                fit: BoxFit.fill,
              ),
              SafeArea(
                child: Padding(
                  padding: getPadding(
                    left: 25.w,
                    right: 25.w,
                    top: 10.h,
                    bottom: 12.h,
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: getPadding(top: 16.h, bottom: 6.h),
                                child: const FieldLabelWidget(
                                  label: attentionGrabberLabel,
                                ),
                              ),
                              CommonTextFormField(
                                inputCharLength: 30,
                                controller: attentionGraberController,
                                hint: attentionGrabberHint,
                                textInputType: TextInputType.text,
                                maxLines: 1,
                              ),
                              Padding(
                                padding: getPadding(top: 16.h, bottom: 6.h),
                                child: const FieldLabelWidget(
                                  label: descriptionLabel,
                                ),
                              ),
                              CommonTextFormField(
                                inputCharLength: 250,
                                hint: descriptionHint,
                                textInputType: TextInputType.multiline,
                                maxLines: 5,
                                minLines: 5,
                                controller: descriptionController,
                              ),
                              if (user!.userType !=
                                  convertEnumToString(UserType.private))
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          getPadding(top: 16.h, bottom: 6.h),
                                      child: Text(
                                        aboutCompany,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                        style: AppTextStyle
                                            .txtPTSansRegular14Gray600,
                                      ),
                                    ),
                                    CommonTextFormField(
                                      autoValidate:
                                          AutovalidateMode.onUserInteraction,
                                      inputCharLength: 250,
                                      hint: maxTwoFifty,
                                      maxLength: 250,
                                      textInputType: TextInputType.multiline,
                                      maxLines: 5,
                                      minLines: 5,
                                      controller: companyDescriptionController,
                                      textInputAction: TextInputAction.done,
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: CustomElevatedButton(
                              title: backButton,
                              onTap: () async => Navigator.of(context).pop(),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: GradientElevatedButton(
                              title: saveButton,
                              onTap: () => onTapSave(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onTapSave() {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      List<String> createStatus = widget.carModel?.createStatus ?? [];
      createStatus
          .add(convertEnumToString(CarCreateStatus.additionalInformation));
      BlocProvider.of<CarDetailsBloc>(context).add(
        UpdateCarInfoEvent(
          carInfoData: {
            '_id': widget.carModel?.id,
            'createStatus': createStatus.toSet().toList(),
            'additionalInformation': {
              'attentionGraber': attentionGraberController.text,
              'description': descriptionController.text,
              'companyDescription': companyDescriptionController.text
            },
          },
          carCreateStatus: CarCreateStatus.additionalInformation,
        ),
      );
    }
  }
}
