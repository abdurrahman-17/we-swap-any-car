import '../../core/configurations.dart';
import '../common_widgets/common_divider.dart';

class CommonDropDownPopup extends StatefulWidget {
  const CommonDropDownPopup(
      {super.key, required this.selectedIndex, required this.itemList});
  final List<String> itemList;
  final int? selectedIndex;
  @override
  State<CommonDropDownPopup> createState() => _CommonDropDownPopupState();
}

class _CommonDropDownPopupState extends State<CommonDropDownPopup> {
  late int selectedIndexVal = 0;
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
              decoration: widget.selectedIndex == index
                  ? BoxDecoration(
                      color: ColorConstant.kColorBlack,
                      borderRadius: BorderRadius.circular(100),
                    )
                  : null,
              padding: widget.selectedIndex == index
                  ? getPadding(top: 11.h, bottom: 11.h, left: 27.w, right: 27.w)
                  : getPadding(top: 6.h, bottom: 6.h),
              child: Text(
                widget.itemList[index],
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
                style: AppTextStyle.regularTextStyle.copyWith(
                  color: widget.selectedIndex == index
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
