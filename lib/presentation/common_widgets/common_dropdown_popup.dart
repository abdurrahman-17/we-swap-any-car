import '../../core/configurations.dart';
import 'common_divider.dart';

class CommonDropDownDialog extends StatefulWidget {
  const CommonDropDownDialog({
    super.key,
    required this.selectedIndex,
    required this.itemList,
  });
  final List<String> itemList;
  final int selectedIndex;
  @override
  State<CommonDropDownDialog> createState() => _CommonDropDownDialogState();
}

class _CommonDropDownDialogState extends State<CommonDropDownDialog> {
  int selectedIndexVal = -1;

  @override
  void initState() {
    super.initState();
    selectedIndexVal = widget.selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 263.w,
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: widget.itemList.length,
        separatorBuilder: (context, index) => const CommonDivider(),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              selectedIndexVal = index;
              Navigator.pop(context, selectedIndexVal);
            },
            child: Container(
              decoration: selectedIndexVal == index
                  ? BoxDecoration(
                      color: ColorConstant.kColorBlack,
                      borderRadius: BorderRadius.circular(100),
                    )
                  : null,
              padding: selectedIndexVal == index
                  ? getPadding(top: 11.h, bottom: 11.h, left: 27.w, right: 27.w)
                  : getPadding(top: 6.h, bottom: 6.h),
              child: Text(
                widget.itemList[index],
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
                style: AppTextStyle.regularTextStyle.copyWith(
                  fontSize: 16.sp,
                  color: selectedIndexVal == index
                      ? ColorConstant.kColorWhite
                      : ColorConstant.kColor7C7C7C,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
