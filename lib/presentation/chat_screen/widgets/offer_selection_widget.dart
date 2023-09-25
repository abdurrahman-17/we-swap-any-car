import '../../../core/configurations.dart';

class OfferSelectionRadioWidget extends StatefulWidget {
  const OfferSelectionRadioWidget({
    Key? key,
    required this.callBack,
    required this.offerOptions,
    required this.selectedOption,
  }) : super(key: key);
  final Function callBack;
  final List<String> offerOptions;
  final String selectedOption;
  @override
  State<OfferSelectionRadioWidget> createState() =>
      _OfferSelectionRadioWidgetState();
}

class _OfferSelectionRadioWidgetState extends State<OfferSelectionRadioWidget> {
  String selectedOption = "";

  final textStyle = AppTextStyle.hintTextStyle.copyWith(
    color: ColorConstant.gray600,
  );
  void selectLogistic(String value) {
    setState(() {
      selectedOption = value;
    });
    widget.callBack(selectedOption);
  }

  @override
  void initState() {
    selectedOption = widget.selectedOption;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final item in widget.offerOptions)
          Row(
            children: [
              OfferRadioButton(
                onChanged: (value) {
                  selectLogistic(value);
                },
                value: item,
                groupValue: selectedOption,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                item,
                style: textStyle,
              )
            ],
          ),
      ],
    );
  }
}

///radio
class OfferRadioButton extends StatefulWidget {
  final String value;
  final String? groupValue;
  final void Function(String) onChanged;
  const OfferRadioButton({
    Key? key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<OfferRadioButton> createState() => _OfferRadioButtonState();
}

class _OfferRadioButtonState extends State<OfferRadioButton> {
  @override
  Widget build(BuildContext context) {
    bool selected = (widget.value == widget.groupValue);

    return InkWell(
      onTap: () => widget.onChanged(widget.value),
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
              colors: selected
                  ? kPrimaryGradientColor
                  : [ColorConstant.kColorWhite, ColorConstant.kColorWhite]),
          border: Border.all(
            color: Colors.grey,
          ),
        ),
        child: Center(
          child: Icon(
            Icons.done,
            size: 15,
            color: ColorConstant.kColorWhite,
          ),
        ),
      ),
    );
  }
}
