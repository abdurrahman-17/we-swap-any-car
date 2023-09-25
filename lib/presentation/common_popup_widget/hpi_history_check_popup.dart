import 'package:wsac/presentation/common_widgets/common_divider.dart';

import '../../../core/configurations.dart';
import '../../model/car_detail_model/hpi_history_result_model.dart';

class HpiHistoryCheckPopup extends StatefulWidget {
  const HpiHistoryCheckPopup({
    Key? key,
    required this.hpiHistoryCheckPoints,
  }) : super(key: key);

  final List<HPIHistoryResultModel> hpiHistoryCheckPoints;

  @override
  State<HpiHistoryCheckPopup> createState() => _HpiHistoryCheckPopupState();
}

class _HpiHistoryCheckPopupState extends State<HpiHistoryCheckPopup> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            historyCheckResultLabel,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.left,
            style: AppTextStyle.txtPTSansBold14,
          ),
          Padding(
            padding: getPadding(top: 15.h, bottom: 15.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: widget.hpiHistoryCheckPoints
                  .asMap()
                  .map((i, checkResult) => MapEntry(
                      i,
                      Column(children: [
                        Container(
                          width: size.width,
                          padding: getPadding(top: 6.h, bottom: 6.h),
                          child: Row(
                            children: [
                              Icon(
                                Icons.warning_rounded,
                                color: ColorConstant.kColorEACE76,
                                size: getSize(18),
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: Text(
                                  checkResult.message!,
                                  style: AppTextStyle.regularTextStyle.copyWith(
                                      color: ColorConstant.kColor535353),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (i != widget.hpiHistoryCheckPoints.length - 1)
                          CommonDivider(color: ColorConstant.kColorCECECE)
                      ])))
                  .values
                  .toList(),
            ),
          ),
          Center(
            child: CustomElevatedButton(
              width: getHorizontalSize(166.w),
              title: closeButton,
              onTap: () async {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
