import '../../core/configurations.dart';
import '../../model/car_model/car_exterior_grade.dart';
import '../common_widgets/common_divider.dart';

class ExteriorGradeDropDown extends StatefulWidget {
  const ExteriorGradeDropDown({
    super.key,
    this.selectedIndex,
    required this.itemList,
  });
  final List<ExteriorGrade> itemList;
  final int? selectedIndex;
  @override
  State<ExteriorGradeDropDown> createState() => _ExteriorGradeDropDownState();
}

class _ExteriorGradeDropDownState extends State<ExteriorGradeDropDown> {
  int selectedIndexVal = 0;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 263.w,
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: widget.itemList.length,
        separatorBuilder: (context, index) => CommonDivider(
          color: ColorConstant.kColorCECECE,
        ),
        itemBuilder: (context, index) {
          final item = widget.itemList[index];
          return GestureDetector(
            onTap: () {
              selectedIndexVal = index;
              Navigator.pop(context, selectedIndexVal);
            },
            child: Container(
              decoration:
                  widget.selectedIndex != null && widget.selectedIndex == index
                      ? BoxDecoration(
                          color: ColorConstant.kColorBlack,
                          borderRadius: BorderRadius.circular(100),
                        )
                      : null,
              padding: widget.selectedIndex != null &&
                      widget.selectedIndex == index
                  ? getPadding(top: 11.h, bottom: 11.h, left: 27.w, right: 27.w)
                  : getPadding(top: 6.h, bottom: 6.h),
              child: Text(
                item.grade ?? '',
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
                style: AppTextStyle.regularTextStyle.copyWith(
                  fontSize: 16.sp,
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
