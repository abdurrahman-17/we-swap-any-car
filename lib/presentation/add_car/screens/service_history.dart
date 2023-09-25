import 'dart:developer';
import 'dart:io';

import '../../../bloc/car_details/car_details_bloc.dart';
import '../../../core/configurations.dart';
import '../../../main.dart';
import '../../../model/car_model/car_model.dart';
import '../../../utility/file_upload_helper.dart';
import '../../../service/amplify_api_service.dart/amplify_api_manager.dart';
import '../../common_widgets/common_admin_support_button.dart';
import '../../common_widgets/common_bullet_points.dart';
import '../../common_widgets/common_divider.dart';
import '../../common_widgets/common_dropdown_popup.dart';
import '../../common_widgets/common_loader.dart';
import '../../common_widgets/common_popups.dart';
import '../../common_widgets/field_label.dart';
import '../../common_widgets/full_screen_image_viewer.dart';

class ServiceHistoryScreen extends StatefulWidget {
  static const String routeName = 'service_history_screen';
  const ServiceHistoryScreen({
    Key? key,
    this.carModel,
  }) : super(key: key);
  final CarModel? carModel;
  @override
  State<ServiceHistoryScreen> createState() => _ServiceHistoryScreenState();
}

class _ServiceHistoryScreenState extends State<ServiceHistoryScreen> {
  List<dynamic> imageList = [];
  int selectedIndex = -1;
  GlobalKey<FormState> formKey = GlobalKey();
  final TextEditingController _serviceRecordController =
      TextEditingController();
  final TextEditingController _mainDealerServiceController =
      TextEditingController();
  final TextEditingController _independentDealerServiceController =
      TextEditingController();

  final int serviceHistoryImageCount = 25;
  final ValueNotifier<double> _downloadCount = ValueNotifier<double>(0);

  void autoPopulate() {
    _serviceRecordController.text =
        widget.carModel?.serviceHistory?.record ?? '';
    _mainDealerServiceController.text =
        "${widget.carModel?.serviceHistory?.mainDealer ?? ''}";
    _independentDealerServiceController.text =
        "${widget.carModel?.serviceHistory?.independent ?? ''}";

    if (widget.carModel?.serviceHistory?.record == 'None') {
      selectedIndex = 0;
    } else if (widget.carModel?.serviceHistory?.record == 'Partial') {
      selectedIndex = 1;
    } else if (widget.carModel?.serviceHistory?.record == 'Full') {
      selectedIndex = 2;
    }
    if (widget.carModel?.serviceHistory?.images != null &&
        widget.carModel!.serviceHistory!.images!.isNotEmpty) {
      imageList = List.from(widget.carModel!.serviceHistory!.images!);
    }
  }

  @override
  void initState() {
    autoPopulate();
    log("${selectedIndex}df");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CarDetailsBloc, CarDetailsState>(
      listener: (context, state) {
        log(state.toString());
        if (state is UpdateCarInfoState &&
            state.carCreateStatus == CarCreateStatus.serviceHistory) {
          if (state.updateCarStatus == ProviderStatus.success) {
            Navigator.pop(context);
            CarModel? car = state.car;
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
        title: serviceHistoryAppBar,
        backWidget: const SizedBox(),
        actions: const [
          AdminSupportButton(),
        ],
        body: Stack(
          children: [
            CustomImageView(
              width: MediaQuery.of(context).size.width,
              svgPath: Assets.homeBackground,
              fit: BoxFit.fitWidth,
              alignment: Alignment.bottomCenter,
            ),
            SafeArea(
              child: Padding(
                padding: getPadding(left: 25.w, right: 25.w, top: 12.h),
                child: Column(
                  children: [
                    serviceRecordDetails(),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      child: Row(
                        children: [
                          Expanded(
                            child: CustomElevatedButton(
                              title: backButton,
                              onTap: () async {
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: GradientElevatedButton(
                              title: saveButton,
                              onTap: onTapSave,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget serviceRecordDetails() {
    return Expanded(
      child: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                msgServiceRecordDetailsLabel,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
                style: AppTextStyle.txtPTSansRegular14Black900,
              ),
              Padding(
                padding: getPadding(top: 24.h, bottom: 18.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: getPadding(top: 12.h),
                        child: FieldLabelWidget(
                          label: serviceRecordLabel,
                          style: AppTextStyle.txtPTSansRegular14Gray600,
                          isMandatory: true,
                        ),
                      ),
                    ),
                    Expanded(
                      child: CommonTextFormField(
                        controller: _serviceRecordController,
                        autoValidate: AutovalidateMode.onUserInteraction,
                        isDropDown: true,
                        readOnly: true,
                        hint: selectDropdownHint,
                        validator: (value) {
                          if ((value ?? '').isEmpty) {
                            return 'Record is required';
                          }
                          return null;
                        },
                        onTap: () async => await onTapServiceRecord(),
                      ),
                    ),
                  ],
                ),
              ),
              if (selectedIndex != 0 && selectedIndex != -1)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CommonDivider(thickness: 1),
                    Padding(
                      padding: getPadding(top: 10.h, bottom: 10.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const FieldLabelWidget(
                                  label: mainDealerLabel,
                                  isMandatory: true,
                                ),
                                SizedBox(height: 6.h),
                                CommonTextFormField(
                                  autoValidate:
                                      AutovalidateMode.onUserInteraction,
                                  inputCharLength: 3,
                                  controller: _mainDealerServiceController,
                                  hint:
                                      textFieldLabelEnterTheText + servicesHint,
                                  textInputType: TextInputType.number,
                                  validator: (value) {
                                    if ((value ?? '').isEmpty) {
                                      return 'Service is required';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const FieldLabelWidget(
                                  label: independentGarageLabel,
                                  isMandatory: true,
                                ),
                                SizedBox(height: 6.h),
                                CommonTextFormField(
                                  autoValidate:
                                      AutovalidateMode.onUserInteraction,
                                  inputCharLength: 3,
                                  controller:
                                      _independentDealerServiceController,
                                  hint:
                                      textFieldLabelEnterTheText + servicesHint,
                                  textInputType: TextInputType.number,
                                  validator: (value) {
                                    if ((value ?? '').isEmpty) {
                                      return 'Service is required';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      "Note: Enter '0' if there is no service provided",
                      style: AppTextStyle.txtPTSansRegular12Gray600,
                    ),
                    const CommonDivider(thickness: 1),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: getPadding(top: 15.h),
                        child: Text(
                          uploadReceipts.toUpperCase(),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: AppTextStyle.txtPTSansRegular14Black900,
                        ),
                      ),
                    ),
                    imageUploadSection(),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget imageUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 8.h, bottom: 13.h),
          child: GradientElevatedButton(
            title: imageList.isEmpty ? uploadPhotosAppBar : addMorePhotosAppBar,
            buttonGradient: imageList.length >= serviceHistoryImageCount
                ? disabledGradient
                : null,
            onTap: () => imageList.length >= serviceHistoryImageCount
                ? null
                : onTapImgCamera(),
          ),
        ),
        const BulletPoint(text: userCanUploadUpTo25Images),
        const BulletPoint(text: sizeShouldBeFiveMb),
        imagesGridView(),
      ],
    );
  }

  Widget imagesGridView() {
    return GridView.builder(
      shrinkWrap: true,
      padding: getPadding(top: 20.h, bottom: 20.h),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisExtent: getVerticalSize(95),
        crossAxisCount: 3,
        mainAxisSpacing: getHorizontalSize(5),
        crossAxisSpacing: getHorizontalSize(10),
      ),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: imageList.length,
      itemBuilder: (context, index) {
        return GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                FullScreenImageViewer.routeName,
                arguments: {
                  'imageList': imageList,
                  "isMultiImage": true,
                  "initialIndex": index,
                },
              );
            },
            child: imageView(imageList[index]!));
      },
    );
  }

  Widget imageView(dynamic image) {
    return Stack(
      children: [
        Container(
          height: getVerticalSize(79.h),
          width: double.infinity,
          margin: getMargin(bottom: 8.h),
          decoration: BoxDecoration(
            color: ColorConstant.kColorBlack,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: CustomImageView(
            file: image is File ? image : null,
            url: image is String ? image : null,
            radius: BorderRadius.circular(8.r),
            fit: BoxFit.contain,
          ),
        ),
        Positioned(
          top: 6.h,
          right: 8.w,
          child: InkWell(
            onTap: () {
              imageList.removeWhere((element) => element == image);
              setState(() {});
            },
            child: const Icon(
              Icons.delete,
              color: Colors.red,
              size: 18,
            ),
          ),
        )
      ],
    );
  }

  Future<void> onTapServiceRecord() async {
    final selectedServiceVal = await customPopup(
        content: CommonDropDownDialog(
      selectedIndex: selectedIndex,
      itemList: serviceRecordList,
    ));
    if (selectedServiceVal != null && selectedServiceVal != -1) {
      if (selectedIndex != selectedServiceVal) {
        setState(() {
          _serviceRecordController.text =
              serviceRecordList[selectedServiceVal as int];
          selectedIndex = selectedServiceVal;
          //clear old records
          _independentDealerServiceController.text = '';
          _mainDealerServiceController.text = '';
          imageList.clear();
        });
      }
    }
  }

  //image upload
  Future<void> onTapImgCamera() async {
    int fileCount = serviceHistoryImageCount - imageList.length > 5
        ? 5
        : serviceHistoryImageCount - imageList.length;

    FileManager().showModelSheetForImage(
      isMultiImage: true,
      //25 is the total image count
      maxFileCount: 5,
      fileCount: fileCount,
      isAtTime: true,
      getFiles: (values) async {
        _downloadCount.value = 0;
        showUploadProgress(total: values.length, progress: _downloadCount);
        for (final image in values) {
          final String imgUrl = await AmplifyApiManager.uploadImageToS3(
            File(image),
            progressFunction: (prog) {
              if (prog < 1) {
                _downloadCount.value = (_downloadCount.value).toInt() + prog;
              }
            },
          );
          final bool isNotExist = imageList
              .where((element) =>
                  element.toString().toLowerCase() ==
                  getEncodedUrl(imgUrl).toLowerCase())
              .isEmpty;
          if (isNotExist) {
            if (imgUrl.isNotEmpty) {
              imageList.add(getEncodedUrl(imgUrl));
            }
          }
          setState(() {});
          _downloadCount.value = _downloadCount.value.toInt() + 1;
        }
        Navigator.pop(globalNavigatorKey.currentContext!);
      },
    );
  }

  Future<void> onTapSave() async {
    final isValid = formKey.currentState!.validate();
    if (imageList.isNotEmpty && imageList.length > serviceHistoryImageCount) {
      showSnackBar(message: 'User can upload up to 25 images');
    } else {
      if (isValid) {
        final imgUrls = await uploadPhotoAndGetUrl();
        List<String> createStatus = widget.carModel?.createStatus ?? [];
        createStatus.add(convertEnumToString(CarCreateStatus.serviceHistory));

        final serviceJson = {
          '_id': widget.carModel?.id,
          'createStatus': createStatus.toSet().toList(),
          'serviceHistory': {
            'record': _serviceRecordController.text,
            if (_independentDealerServiceController.text.isNotEmpty)
              'independent':
                  int.parse(_independentDealerServiceController.text),
            if (_mainDealerServiceController.text.isNotEmpty)
              'mainDealer': int.parse(_mainDealerServiceController.text),
            'images': imgUrls,
          }
        };
        if (!mounted) return;
        BlocProvider.of<CarDetailsBloc>(context).add(
          UpdateCarInfoEvent(
            carInfoData: serviceJson,
            carCreateStatus: CarCreateStatus.serviceHistory,
          ),
        );
      }
    }
  }

  Future<List<String>> uploadPhotoAndGetUrl() async {
    progressDialogue();
    late List<String> uploadedReceiptImgUrls = [];
    await Future.wait(imageList.map((imageFile) async {
      if (imageFile is File) {
        final String imgUrl =
            await AmplifyApiManager.uploadImageToS3(imageFile);
        if (imgUrl.isNotEmpty) {
          uploadedReceiptImgUrls.add(getEncodedUrl(imgUrl));
        }
      } else {
        uploadedReceiptImgUrls.add(getEncodedUrl('$imageFile'));
      }
    }));
    Navigator.of(globalNavigatorKey.currentContext!).pop();
    return uploadedReceiptImgUrls;
  }
}
