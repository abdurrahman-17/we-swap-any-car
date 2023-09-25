import '../../core/configurations.dart';

class ProgressBagde extends StatefulWidget {
  const ProgressBagde({
    Key? key,
    this.status,
    this.size,
    this.hasWhiteBorder = false,
  }) : super(key: key);
  final ProgressStatus? status;
  final double? size;
  final bool hasWhiteBorder;

  @override
  State<ProgressBagde> createState() => _ProgressBagdeState();
}

class _ProgressBagdeState extends State<ProgressBagde> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorConstant.kColorWhite,
        borderRadius: BorderRadius.circular(100.r),
      ),
      padding: widget.hasWhiteBorder ? getPadding(all: 2) : null,
      child: Container(
        decoration: BoxDecoration(
          color: widget.status != null
              ? widget.status == ProgressStatus.error ||
                      widget.status == ProgressStatus.cancel
                  ? ColorConstant.kColorC2512E
                  : widget.status == ProgressStatus.loading
                      ? ColorConstant.kColor0075FF
                      : ColorConstant.kColor95C926
              : ColorConstant.kColorCECECE,
          borderRadius: BorderRadius.circular(100.r),
        ),
        width: widget.size ?? getSize(21),
        height: widget.size ?? getSize(21),
        padding: getPadding(all: 5),
        child: widget.status != null
            ? CustomImageView(
                svgPath: widget.status == ProgressStatus.error
                    ? Assets.progressError
                    : widget.status == ProgressStatus.loading
                        ? Assets.progressLoading
                        : widget.status == ProgressStatus.cancel
                            ? Assets.progressCancel
                            : Assets.progressCheck,
                color: ColorConstant.kColorWhite,
                height: getSize(7),
                width: getSize(7),
              )
            : null,
      ),
    );
  }
}
