import '../../../core/configurations.dart';
import '../../../model/technical_details/manufacturer.dart';
import '../../common_widgets/common_divider.dart';
import '../../common_widgets/custom_checkbox.dart';

class ManufacturerModelsWidget extends StatefulWidget {
  const ManufacturerModelsWidget({
    Key? key,
    this.onListChanged,
    required this.brandModels,
  }) : super(key: key);
  final ValueChanged<List<BrandModel>>? onListChanged;
  final List<BrandModel>? brandModels;

  @override
  State<ManufacturerModelsWidget> createState() =>
      _ManufacturerModelsWidgetState();
}

class _ManufacturerModelsWidgetState extends State<ManufacturerModelsWidget> {
  List<BrandModel> selectModelListedItemIndexes = [];
  bool isSelectedAll = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: ColorConstant.kColorADADAD.withOpacity(0.4),
        ),
        color: ColorConstant.kColorWhite,
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: widget.brandModels!.length,
        padding: getPadding(top: 6.h, bottom: 6.h),
        separatorBuilder: (context, index) => const CommonDivider(),
        itemBuilder: (_, int index) {
          final item = widget.brandModels![index];
          return Padding(
            padding: getPadding(left: 20.w, right: 20.w),
            child: CustomCheckboxWithLabel(
              label: widget.brandModels![index].name ?? '',
              value:
                  selectModelListedItemIndexes.contains(item) || isSelectedAll,
              onChanged: (_) {
                if (selectModelListedItemIndexes.contains(item)) {
                  // unselect
                  selectModelListedItemIndexes.remove(item);
                } else {
                  // select
                  selectModelListedItemIndexes.add(item);
                }
                widget.onListChanged!(selectModelListedItemIndexes);
              },
            ),
          );
        },
      ),
    );
  }
}
