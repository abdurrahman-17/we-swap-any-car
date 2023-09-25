import '../../core/configurations.dart';

class FilterExpansionTile extends StatelessWidget {
  const FilterExpansionTile({
    super.key,
    required this.title,
    this.subTitle,
    this.children,
    required this.initiallyExpanded,
    required this.onExpansionChanged,
    this.locationIndex = -1,
  });
  final String title;
  final String? subTitle;
  final Widget? children;
  final bool initiallyExpanded;
  final void Function(bool)? onExpansionChanged;
  final int locationIndex;

  @override
  Widget build(BuildContext context) {
    ///locationIndex is currently 3
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        key: locationIndex == 3 ? null : UniqueKey(),
        initiallyExpanded: initiallyExpanded,
        onExpansionChanged: onExpansionChanged,
        tilePadding: const EdgeInsets.all(0),
        childrenPadding: const EdgeInsets.all(0),
        title: Text(
          title.toUpperCase(),
          style: AppTextStyle.regularTextStyle.copyWith(
            fontWeight: FontWeight.w700,
            color: ColorConstant.kColor353333,
          ),
        ),
        children: [
          if (subTitle != null)
            Align(
              alignment: Alignment.centerLeft,
              child: Text(subTitle!, style: AppTextStyle.smallTextStyle),
            ),
          if (children != null) children!,
        ],
      ),
    );
  }
}

class CommonExpansionTile extends StatelessWidget {
  const CommonExpansionTile({
    super.key,
    required this.title,
    required this.childrens,
    required this.initiallyExpanded,
    required this.onExpansionChanged,
  });
  final String title;
  final List<Widget> childrens;
  final bool initiallyExpanded;
  final void Function(bool)? onExpansionChanged;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        key: UniqueKey(),
        initiallyExpanded: initiallyExpanded,
        onExpansionChanged: onExpansionChanged,
        iconColor: ColorConstant.black90090,
        tilePadding: const EdgeInsets.all(0),
        childrenPadding: const EdgeInsets.all(0),
        title: Text(
          title.toUpperCase(),
          style: AppTextStyle.regularTextStyle.copyWith(
            color: ColorConstant.kColor353333,
          ),
        ),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: childrens,
          )
        ],
      ),
    );
  }
}
