import 'package:flutter/services.dart';

import '../../core/configurations.dart';
import '../../model/car_model/car_added_accessories.dart';
import '../../bloc/car_details/car_details_bloc.dart';
import '../../model/car_model/car_model.dart';
import '../common_widgets/common_divider.dart';
import '../common_widgets/common_loader.dart';
import '../common_widgets/custom_checkbox.dart';

class AddExtraPopup extends StatefulWidget {
  const AddExtraPopup({
    Key? key,
    this.callBack,
    this.carModel,
    this.fromEdit = false,
  }) : super(key: key);

  final CarModel? carModel;
  final void Function(dynamic)? callBack;
  final bool fromEdit;

  @override
  State<AddExtraPopup> createState() => _AddExtraPopupState();
}

class _AddExtraPopupState extends State<AddExtraPopup> {
  final TextEditingController addItemController = TextEditingController();
  List<ListedItem> listedExtraItems = [];
  List<ListedItem> selectedListedExtraItems = [];
  List<NotListedItem> selectedNotListedExtraItems = [];

  @override
  void initState() {
    if (widget.carModel?.addedAccessories != null) {
      selectedListedExtraItems =
          List.from(widget.carModel?.addedAccessories?.listedItems ?? []);
      selectedNotListedExtraItems =
          List.from(widget.carModel?.addedAccessories?.notListedItems ?? []);
    }
    BlocProvider.of<CarDetailsBloc>(context).add(GetCarAccessoriesEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          addExtraItems,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.left,
          style: AppTextStyle.txtPTSansBold14,
        ),
        Flexible(
          child: AspectRatio(
            aspectRatio: 1.25,
            child: Padding(
              padding: getPadding(top: 15),
              child: ScrollConfiguration(
                behavior: MyBehavior(),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      BlocBuilder<CarDetailsBloc, CarDetailsState>(
                        builder: (context, state) {
                          if (state is GetCarAccessoriesState) {
                            if (state.accessoriesStatus ==
                                ProviderStatus.success) {
                              listedExtraItems = state.accessoryList;
                              return ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: listedExtraItems.length,
                                itemBuilder: (context, index) {
                                  final value = listedExtraItems[index];
                                  return CustomCheckboxWithLabel(
                                    label: value.name ?? '',
                                    isGradientCheckBox: true,
                                    value: selectedListedExtraItems
                                        .where((element) =>
                                            element.name == value.name)
                                        .toList()
                                        .isNotEmpty,
                                    onChanged: (_) {
                                      if (selectedListedExtraItems
                                          .where((element) =>
                                              element.name == value.name)
                                          .toList()
                                          .isNotEmpty) {
                                        selectedListedExtraItems.remove(
                                            selectedListedExtraItems
                                                .where((element) =>
                                                    element.name == value.name)
                                                .first);
                                      } else {
                                        selectedListedExtraItems.add(value);
                                      }
                                    },
                                  );
                                },
                                separatorBuilder: (context, index) =>
                                    CommonDivider(
                                  color: ColorConstant.kColorCECECE,
                                ),
                              );
                            } else if (state.accessoriesStatus ==
                                ProviderStatus.error) {
                              return const Center(
                                child: Text(errorOccurredWhileFetch),
                              );
                            }
                          }
                          return ListView.separated(
                            itemCount: 4,
                            shrinkWrap: true,
                            itemBuilder: (context, index) => shimmerLoader(
                              Container(
                                height: getVerticalSize(40.h),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: ColorConstant.kColorWhite,
                                  borderRadius: BorderRadius.circular(5.r),
                                ),
                              ),
                            ),
                            separatorBuilder: (context, index) => CommonDivider(
                              color: ColorConstant.kColorCECECE,
                            ),
                          );
                        },
                      ),
                      CommonDivider(color: ColorConstant.kColorCECECE),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: selectedNotListedExtraItems.length,
                        itemBuilder: (context, index) {
                          final value = selectedNotListedExtraItems[index];
                          return CustomCheckboxWithLabel(
                            label: value.name ?? '',
                            isRemove: true,
                            isGradientColor: true,
                            value: selectedNotListedExtraItems.contains(value),
                            onChanged: (_) {
                              selectedNotListedExtraItems.remove(value);
                              setState(() {});
                            },
                          );
                        },
                        separatorBuilder: (context, index) => CommonDivider(
                          color: ColorConstant.kColorCECECE,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: getPadding(top: 10.h),
            child: Text(
              youCanAddNotListed,
              style: AppTextStyle.txtPTSansRegular14,
              textAlign: TextAlign.left,
            ),
          ),
        ),
        Padding(
          padding: getPadding(bottom: 19.h, top: 7.h),
          child: CommonTextFormField(
            borderRadius: 7.r,
            controller: addItemController,
            inputFormatters: [
              LengthLimitingTextInputFormatter(30),
            ],
            suffixIcon: GestureDetector(
              onTap: () {
                final notListedItem =
                    NotListedItem(name: addItemController.text.trim());
                if (selectedNotListedExtraItems
                        .where((element) =>
                            (element.name ?? '').toLowerCase() ==
                            (notListedItem.name ?? '').toLowerCase())
                        .toList()
                        .isNotEmpty ||
                    listedExtraItems
                        .where((element) =>
                            (element.name ?? '').toLowerCase() ==
                            (notListedItem.name ?? '').toLowerCase())
                        .toList()
                        .isNotEmpty) {
                  showSnackBar(message: 'Item already exists');
                } else if (addItemController.text.trim().isNotEmpty) {
                  selectedNotListedExtraItems.add(notListedItem);
                  selectedNotListedExtraItems.sort(
                    (a, b) => (a.name ?? '')
                        .toLowerCase()
                        .compareTo((b.name ?? '').toLowerCase()),
                  );
                  addItemController.text = '';
                  setState(() {});
                } else {
                  showSnackBar(message: 'Add valid item');
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: ColorConstant.kColorBlack,
                  borderRadius: BorderRadius.circular(3.r),
                ),
                padding: getPadding(all: 9),
                margin: getMargin(
                  top: 6.h,
                  bottom: 6.h,
                  right: 3.w,
                  left: 3.w,
                ),
                child: CustomImageView(
                  svgPath: Assets.whitePlus,
                  height: getSize(6),
                  width: getSize(6),
                ),
              ),
            ),
            textInputAction: TextInputAction.done,
          ),
        ),
        Row(
          children: [
            Expanded(
              child: CustomElevatedButton(
                title: cancelButton,
                onTap: () async => Navigator.pop(context),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: GradientElevatedButton(
                title: addExtrasButton,
                onTap: () async {
                  widget.carModel!.addedAccessories!.listedItems =
                      selectedListedExtraItems + [];
                  widget.carModel!.addedAccessories!.notListedItems =
                      selectedNotListedExtraItems + [];
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
