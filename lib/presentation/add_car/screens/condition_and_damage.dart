import 'dart:developer';
import 'dart:io';

import '../../../bloc/car_details/car_details_bloc.dart';
import '../../../core/configurations.dart';
import '../../../main.dart';
import '../../../model/car_model/car_condition_damage_model.dart';
import '../../../service/amplify_api_service.dart/amplify_api_manager.dart';
import '../../../model/car_model/car_model.dart';
import '../../../utility/file_upload_helper.dart';
import '../../common_widgets/common_admin_support_button.dart';
import '../../common_widgets/common_bullet_points.dart';
import '../../common_widgets/common_divider.dart';
import '../../common_widgets/common_loader.dart';
import '../../common_widgets/common_popups.dart';
import '../../common_widgets/full_screen_image_viewer.dart';
import '../../common_widgets/switch_item.dart';

class ConditionAndDamageScreen extends StatefulWidget {
  static const String routeName = 'condition_and_damage_screen';
  const ConditionAndDamageScreen({Key? key, this.carModel}) : super(key: key);
  final CarModel? carModel;
  @override
  State<ConditionAndDamageScreen> createState() =>
      _ConditionAndDamageScreenState();
}

class _ConditionAndDamageScreenState extends State<ConditionAndDamageScreen> {
  final GlobalKey<FormState> formKey = GlobalKey();
  final TextEditingController _additionalInfoController =
      TextEditingController();

  bool scratches = false;
  bool dents = false;
  bool paintProblem = false;
  bool smokingInVehicle = false;
  bool brokenMissingItems = false;
  bool warningLightsDashboard = false;
  bool tyreProblem = false;
  bool scuffedAlloy = false;
  bool toolPack = false;
  bool lockWheelNut = false;
  List<dynamic> scratchImageList = [];
  List<dynamic> dentImageList = [];
  List<dynamic> paintImageList = [];
  List<dynamic> warningLightsImageList = [];
  List<dynamic> brokenImageList = [];
  List<dynamic> tyreImageList = [];
  List<dynamic> scuffedImageList = [];
  final ValueNotifier<double> _downloadCount = ValueNotifier<double>(0);

  void autoPopulate() {
    final ConditionAndDamage? conditionAndDamage =
        widget.carModel?.conditionAndDamage;
    if (conditionAndDamage?.scratches?.scratches != null &&
        conditionAndDamage!.scratches!.scratches!) {
      scratches = conditionAndDamage.scratches?.scratches ?? false;
      scratchImageList = List.from(conditionAndDamage.scratches?.images ?? []);
    }
    if (conditionAndDamage?.dents?.dents != null &&
        conditionAndDamage!.dents!.dents!) {
      dents = conditionAndDamage.dents?.dents ?? false;
      dentImageList = List.from(conditionAndDamage.dents?.images ?? []);
    }
    if (conditionAndDamage?.paintProblem?.paintProblem != null &&
        conditionAndDamage!.paintProblem!.paintProblem!) {
      paintProblem = conditionAndDamage.paintProblem?.paintProblem ?? false;
      paintImageList = List.from(conditionAndDamage.paintProblem?.images ?? []);
    }
    if (conditionAndDamage?.smokingInVehicle?.smokingInVehicle != null &&
        conditionAndDamage!.smokingInVehicle!.smokingInVehicle!) {
      smokingInVehicle =
          conditionAndDamage.smokingInVehicle?.smokingInVehicle ?? false;
    }
    if (conditionAndDamage?.brokenMissingItems?.brokenMissingItems != null &&
        conditionAndDamage!.brokenMissingItems!.brokenMissingItems!) {
      brokenMissingItems =
          conditionAndDamage.brokenMissingItems?.brokenMissingItems ?? false;
      brokenImageList =
          List.from(conditionAndDamage.brokenMissingItems?.images ?? []);
    }
    if (conditionAndDamage?.warningLightsDashboard?.warningLightsDashboard !=
            null &&
        conditionAndDamage!.warningLightsDashboard!.warningLightsDashboard!) {
      warningLightsDashboard =
          conditionAndDamage.warningLightsDashboard?.warningLightsDashboard ??
              false;
      warningLightsImageList =
          List.from(conditionAndDamage.warningLightsDashboard?.images ?? []);
    }
    if (conditionAndDamage?.tyreProblem?.tyreProblem != null &&
        conditionAndDamage!.tyreProblem!.tyreProblem!) {
      tyreProblem = conditionAndDamage.tyreProblem?.tyreProblem ?? false;
      tyreImageList = List.from(conditionAndDamage.tyreProblem?.images ?? []);
    }
    if (conditionAndDamage?.scuffedAlloy?.scuffedAlloy != null &&
        conditionAndDamage!.scuffedAlloy!.scuffedAlloy!) {
      scuffedAlloy = conditionAndDamage.scuffedAlloy?.scuffedAlloy ?? false;
      scuffedImageList =
          List.from(conditionAndDamage.scuffedAlloy?.images ?? []);
    }
    if (conditionAndDamage?.toolPack?.toolPack != null &&
        conditionAndDamage!.toolPack!.toolPack!) {
      toolPack = conditionAndDamage.toolPack?.toolPack ?? false;
    }
    if (conditionAndDamage?.lockWheelNut?.lockWheelNut != null &&
        conditionAndDamage!.lockWheelNut!.lockWheelNut!) {
      lockWheelNut = conditionAndDamage.lockWheelNut?.lockWheelNut ?? false;
    }
    _additionalInfoController.text = conditionAndDamage?.additionalInfo ?? '';
  }

  @override
  void initState() {
    autoPopulate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CarDetailsBloc, CarDetailsState>(
      listener: (context, state) {
        if (state is UpdateCarInfoState &&
            state.carCreateStatus == CarCreateStatus.conditionAndDamage) {
          if (state.updateCarStatus == ProviderStatus.success) {
            Navigator.pop(context);
            CarModel? car = state.car;
            Navigator.pop(context, {'carModel': car});
          } else if (state.updateCarStatus == ProviderStatus.error) {
            Navigator.pop(context);
            showSnackBar(message: state.errorMessage ?? '');
          } else {
            progressDialogue();
          }
        }
      },
      child: CustomScaffold(
        title: conditionAndDamageAppBar,
        resizeToAvoidBottomInset: true,
        backWidget: const SizedBox(),
        actions: const [
          AdminSupportButton(),
        ],
        body: Stack(
          children: [
            CustomImageView(
              width: MediaQuery.of(context).size.width,
              svgPath: Assets.homeBackground,
              alignment: Alignment.bottomCenter,
              fit: BoxFit.fitWidth,
            ),
            SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: Form(
                      key: formKey,
                      child: ScrollConfiguration(
                        behavior: MyBehavior(),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: getPadding(
                                  left: 25.w,
                                  right: 25.w,
                                  bottom: 12.h,
                                  top: 20.h,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SwitchItemWidget(
                                      label: scratchesAndScuffsLabel,
                                      switchValue: scratches,
                                      switchHeadValue: scratches,
                                      onChanged: (value) {
                                        if (!value) {
                                          scratchImageList.clear();
                                        }
                                        setState(() {
                                          scratches = value;
                                        });
                                      },
                                    ),
                                    if (scratches)
                                      imageUploadSection(
                                        scratchImageList,
                                        type: ConditionAndDamageTypes.scratch,
                                      ),
                                    CommonDivider(
                                        color: ColorConstant.kGreyColor),
                                    SwitchItemWidget(
                                      label: dentsLabel,
                                      switchValue: dents,
                                      switchHeadValue: dents,
                                      onChanged: (value) {
                                        if (!value) {
                                          dentImageList.clear();
                                        }
                                        setState(() {
                                          dents = value;
                                        });
                                      },
                                    ),
                                    if (dents)
                                      imageUploadSection(
                                        dentImageList,
                                        type: ConditionAndDamageTypes.dent,
                                      ),
                                    CommonDivider(
                                        color: ColorConstant.kGreyColor),
                                    SwitchItemWidget(
                                      label: paintWorkProblemLabel,
                                      switchValue: paintProblem,
                                      switchHeadValue: paintProblem,
                                      onChanged: (value) {
                                        if (!value) {
                                          paintImageList.clear();
                                        }
                                        setState(() {
                                          paintProblem = value;
                                        });
                                      },
                                    ),
                                    if (paintProblem)
                                      imageUploadSection(
                                        paintImageList,
                                        type: ConditionAndDamageTypes.paint,
                                      ),
                                    CommonDivider(
                                        color: ColorConstant.kGreyColor),
                                    SwitchItemWidget(
                                      label: smokingInVehicleLabel,
                                      switchValue: smokingInVehicle,
                                      switchHeadValue: smokingInVehicle,
                                      onChanged: (value) {
                                        setState(() {
                                          smokingInVehicle = value;
                                        });
                                      },
                                    ),
                                    CommonDivider(
                                        color: ColorConstant.kGreyColor),
                                    SwitchItemWidget(
                                      label: brokenMinorProblemLabel,
                                      switchValue: brokenMissingItems,
                                      switchHeadValue: brokenMissingItems,
                                      onChanged: (value) {
                                        if (!value) {
                                          brokenImageList.clear();
                                        }
                                        setState(() {
                                          brokenMissingItems = value;
                                        });
                                      },
                                    ),
                                    if (brokenMissingItems)
                                      imageUploadSection(
                                        brokenImageList,
                                        type: ConditionAndDamageTypes.broken,
                                      ),
                                    CommonDivider(
                                        color: ColorConstant.kGreyColor),
                                    SwitchItemWidget(
                                      label: warningLightOnDashboardLabel,
                                      switchValue: warningLightsDashboard,
                                      switchHeadValue: warningLightsDashboard,
                                      onChanged: (value) {
                                        if (!value) {
                                          warningLightsImageList.clear();
                                        }
                                        setState(() {
                                          warningLightsDashboard = value;
                                        });
                                      },
                                    ),
                                    if (warningLightsDashboard)
                                      imageUploadSection(
                                        warningLightsImageList,
                                        type: ConditionAndDamageTypes
                                            .warningLights,
                                      ),
                                  ],
                                ),
                              ),
                              const CommonDivider(
                                thickness: 8,
                              ),
                              Padding(
                                padding: getPadding(
                                  left: 30.w,
                                  right: 30.w,
                                  bottom: 10.h,
                                  top: 15.h,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      tyreWearOrDamageAppBar,
                                      style:
                                          AppTextStyle.txtPTSansBold14Gray900,
                                    ),
                                    SizedBox(height: getVerticalSize(15)),
                                    SwitchItemWidget(
                                      label: tyreProblemsLabel,
                                      switchValue: tyreProblem,
                                      switchHeadValue: tyreProblem,
                                      onChanged: (value) {
                                        if (!value) {
                                          tyreImageList.clear();
                                        }
                                        setState(() {
                                          tyreProblem = value;
                                        });
                                      },
                                    ),
                                    if (tyreProblem)
                                      imageUploadSection(
                                        tyreImageList,
                                        type: ConditionAndDamageTypes.tyre,
                                      ),
                                    CommonDivider(
                                        color: ColorConstant.kGreyColor),
                                    SwitchItemWidget(
                                      label: scuffedAlloysLabel,
                                      switchValue: scuffedAlloy,
                                      switchHeadValue: scuffedAlloy,
                                      onChanged: (value) {
                                        if (!value) {
                                          scuffedImageList.clear();
                                        }
                                        setState(() {
                                          scuffedAlloy = value;
                                        });
                                      },
                                    ),
                                    if (scuffedAlloy)
                                      imageUploadSection(
                                        scuffedImageList,
                                        type: ConditionAndDamageTypes.scuffed,
                                      ),
                                    CommonDivider(
                                        color: ColorConstant.kGreyColor),
                                    SwitchItemWidget(
                                      label: toolPackLabel,
                                      switchValue: toolPack,
                                      switchHeadValue: toolPack,
                                      onChanged: (value) {
                                        setState(() {
                                          toolPack = value;
                                        });
                                      },
                                    ),
                                    CommonDivider(
                                        color: ColorConstant.kGreyColor),
                                    SwitchItemWidget(
                                      label: lockingNutsLabel,
                                      switchValue: lockWheelNut,
                                      switchHeadValue: lockWheelNut,
                                      onChanged: (value) {
                                        setState(() {
                                          lockWheelNut = value;
                                        });
                                      },
                                    ),
                                    CommonDivider(
                                        color: ColorConstant.kGreyColor),
                                    Padding(
                                      padding:
                                          getPadding(top: 10.h, bottom: 10.h),
                                      child: Text(
                                        additionalInfoLabel,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                        style: AppTextStyle.smallTextStyle
                                            .copyWith(
                                          color: ColorConstant.kColor151515,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                    CommonTextFormField(
                                      controller: _additionalInfoController,
                                      minLines: 4,
                                      maxLines: 4,
                                      hint: maxFiveHundred,
                                      inputCharLength: 500,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: getPadding(
                      left: 25.w,
                      right: 25.w,
                      bottom: 12.h,
                      top: 12.h,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: CustomElevatedButton(
                            title: backButton,
                            onTap: () => Navigator.of(context).pop(),
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
          ],
        ),
      ),
    );
  }

  Widget imageUploadSection(
    List<dynamic> selectedList, {
    required ConditionAndDamageTypes type,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 8.h, bottom: 10.h),
              child: GradientElevatedButton(
                title: uploadPhotosAppBar,
                onTap: () => selectedList.length < 4
                    ? onTapImgCamera(
                        selectedList,
                        type: type,
                      )
                    : null,
                buttonGradient:
                    selectedList.length < 4 ? null : disabledGradient,
              ),
            ),
            const BulletPoint(text: userCanUploadFourImages),
            const BulletPoint(text: sizeShouldBeFiveMb),
          ],
        ),
        if (selectedList.isNotEmpty)
          GridView.builder(
            shrinkWrap: true,
            padding: getPadding(top: 20.h),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisExtent: getVerticalSize(70),
              crossAxisCount: 4,
              mainAxisSpacing: getHorizontalSize(5),
              crossAxisSpacing: getHorizontalSize(10),
            ),
            physics: const NeverScrollableScrollPhysics(),
            itemCount: selectedList.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      FullScreenImageViewer.routeName,
                      arguments: {
                        'imageList': selectedList,
                        'isMultiImage': true,
                        'initialIndex': index,
                      },
                    );
                  },
                  child: imageView("${selectedList[index]}", selectedList));
            },
          ),
      ],
    );
  }

  Widget imageView(String image, List<dynamic> selectedList) {
    log("imagess:$image");
    return Stack(
      children: [
        Container(
          height: getVerticalSize(59.h),
          width: double.infinity,
          margin: getMargin(bottom: 8.h),
          decoration: BoxDecoration(
            color: ColorConstant.kColorBlack,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: CustomImageView(
            file: !image.contains('https') ? File(image) : null,
            url: image.contains('https') ? image : null,
            radius: BorderRadius.circular(8.r),
            fit: BoxFit.contain,
          ),
        ),
        Positioned(
          top: 6.h,
          right: 8.w,
          child: InkWell(
            onTap: () {
              selectedList.removeWhere((element) => element == image);
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

  //image upload
  Future<void> onTapImgCamera(List<dynamic> selectedList,
      {required ConditionAndDamageTypes type}) async {
    if (selectedList.isNotEmpty && selectedList.length >= 4) {
      showSnackBar(message: 'User can upload up to 4 images');
    } else {
      FileManager().showModelSheetForImage(
        isMultiImage: true,
        fileCount: 4 - selectedList.length,
        maxFileCount: 4,
        getFiles: (values) async {
          _downloadCount.value = 0;
          showUploadProgress(total: values.length, progress: _downloadCount);
          for (final image in values) {
            final bool isNotExist = selectedList
                .where((element) =>
            element
                .toString()
                .split('/')
                .last == image
                .split('/')
                .last)
                .isEmpty;
            if (isNotExist) {
              final String imgUrl = await AmplifyApiManager.uploadImageToS3(
                File(image),
                progressFunction: (prog) {
                  if (prog < 1) {
                    _downloadCount.value =
                        (_downloadCount.value).toInt() + prog;
                  }
                },
              );
              if (isNotExist) {
                if (imgUrl.isNotEmpty) {
                  switch (type) {
                    case ConditionAndDamageTypes.scratch:
                      scratchImageList.add(getEncodedUrl(imgUrl));
                      break;
                    case ConditionAndDamageTypes.dent:
                      dentImageList.add(getEncodedUrl(imgUrl));
                      break;
                    case ConditionAndDamageTypes.paint:
                      paintImageList.add(getEncodedUrl(imgUrl));
                      break;
                    case ConditionAndDamageTypes.broken:
                      brokenImageList.add(getEncodedUrl(imgUrl));
                      break;
                    case ConditionAndDamageTypes.warningLights:
                      warningLightsImageList.add(getEncodedUrl(imgUrl));
                      break;
                    case ConditionAndDamageTypes.tyre:
                      tyreImageList.add(getEncodedUrl(imgUrl));
                      break;
                    case ConditionAndDamageTypes.scuffed:
                      scuffedImageList.add(getEncodedUrl(imgUrl));
                      break;
                    default:
                      break;
                  }
                }
              }
              setState(() {});
              _downloadCount.value = _downloadCount.value.toInt() + 1;
            }
          }
          Navigator.pop(globalNavigatorKey.currentContext!);
        },
      );
    }
  }

  String commonMsg(String item) {
    return "Upload images of $item";
  }

  Future<bool> validateFields() async {
    if (scratches) {
      if (scratchImageList.isEmpty) {
        showSnackBar(message: commonMsg("scratches & scuffs"));
        return false;
      } else if (scratchImageList.length > 4) {
        showSnackBar(
            message: "User can upload up to 4 scratch & scuff's images");
        return false;
      }
    }
    if (dents) {
      if (dentImageList.isEmpty) {
        showSnackBar(message: commonMsg("dents"));
        return false;
      } else if (dentImageList.length > 4) {
        showSnackBar(message: "User can upload up to 4 dent's images");
        return false;
      }
    }
    if (paintProblem) {
      if (paintImageList.isEmpty) {
        showSnackBar(message: commonMsg("paintwork problems"));
        return false;
      } else if (paintImageList.length > 4) {
        showSnackBar(
            message: "User can upload up to 4 paint issue part images");
        return false;
      }
    }
    if (brokenMissingItems) {
      if (brokenImageList.isEmpty) {
        showSnackBar(message: commonMsg("broken/missing parts"));
        return false;
      } else if (brokenImageList.length > 4) {
        showSnackBar(
            message: "User can upload up to 4 broken/missing part images");
        return false;
      }
    }
    if (tyreProblem) {
      if (tyreImageList.isEmpty) {
        showSnackBar(message: commonMsg("tyre problem"));
        return false;
      } else if (tyreImageList.length > 4) {
        showSnackBar(message: "User can upload up to 4 tyre's images");
        return false;
      }
    }
    if (scuffedAlloy) {
      if (scuffedImageList.isEmpty) {
        showSnackBar(message: commonMsg("scuffed alloys"));
        return false;
      } else if (scuffedImageList.length > 4) {
        showSnackBar(message: "User can upload up to 4 scuffed alloy's images");
        return false;
      }
    }
    if (warningLightsDashboard) {
      if (warningLightsImageList.isEmpty) {
        showSnackBar(message: commonMsg("warning lights"));
        return false;
      } else if (warningLightsImageList.length > 4) {
        showSnackBar(message: "User can upload up to 4 warning lights images");
        return false;
      }
    }
    await uploadAllSelectedPhotos();
    return true;
  }

  Future<void> uploadAllSelectedPhotos() async {
    progressDialogue();
    scratchImageList = await uploadPhotos(scratchImageList);
    dentImageList = await uploadPhotos(dentImageList);
    paintImageList = await uploadPhotos(paintImageList);
    brokenImageList = await uploadPhotos(brokenImageList);
    tyreImageList = await uploadPhotos(tyreImageList);
    scuffedImageList = await uploadPhotos(scuffedImageList);
    warningLightsImageList = await uploadPhotos(warningLightsImageList);
    if (!mounted) return;
    Navigator.pop(globalNavigatorKey.currentContext!);
  }

  //Upload Photos to s3 bucket
  Future<List<dynamic>> uploadPhotos(List<dynamic> imageList) async {
    late List<String> uploadedImgUrls = [];
    if (imageList.isNotEmpty) {
      _downloadCount.value = 0;
      await Future.wait(imageList.map((imageFile) async {
        if ("$imageFile".contains('https')) {
          uploadedImgUrls.add(getEncodedUrl("$imageFile"));
        } else {
          final String imgUrl =
              await AmplifyApiManager.uploadImageToS3(File("$imageFile"));
          if (imgUrl.isNotEmpty) {
            uploadedImgUrls.add(getEncodedUrl(imgUrl));
          }
        }
        _downloadCount.value++;
      }));
    }
    return uploadedImgUrls;
  }

  //save button tap
  Future<void> onTapSave() async {
    final bool response = await validateFields();
    if (response) {
      if (!mounted) return;
      List<String> createStatus = widget.carModel?.createStatus ?? [];
      createStatus.add(convertEnumToString(CarCreateStatus.conditionAndDamage));

      BlocProvider.of<CarDetailsBloc>(context).add(
        UpdateCarInfoEvent(
          carInfoData: {
            '_id': widget.carModel?.id,
            'createStatus': createStatus.toSet().toList(),
            'conditionAndDamage': {
              'scratches': {
                'scratches': scratches,
                'images': scratchImageList,
              },
              'dents': {
                'dents': dents,
                'images': dentImageList,
              },
              'paintProblem': {
                'paintProblem': paintProblem,
                'images': paintImageList,
              },
              'smokingInVehicle': {
                'smokingInVehicle': smokingInVehicle,
              },
              'brokenMissingItems': {
                'brokenMissingItems': brokenMissingItems,
                'images': brokenImageList,
              },
              'warningLightsDashboard': {
                'warningLightsDashboard': warningLightsDashboard,
                'images': warningLightsImageList,
              },
              'tyreProblem': {
                'tyreProblem': tyreProblem,
                'images': tyreImageList,
              },
              'scuffedAlloy': {
                'scuffedAlloy': scuffedAlloy,
                'images': scuffedImageList,
              },
              'toolPack': {
                'toolPack': toolPack,
              },
              'lockWheelNut': {
                'lockWheelNut': lockWheelNut,
              },
              'additionalInfo': _additionalInfoController.text,
            },
          },
          carCreateStatus: CarCreateStatus.conditionAndDamage,
        ),
      );
    }
  }
}
