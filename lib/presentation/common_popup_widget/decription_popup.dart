import '../../core/configurations.dart';
import '../../model/car_model/car_model.dart';
import '../common_widgets/field_label.dart';

class DescriptionPopupWidget extends StatefulWidget {
  const DescriptionPopupWidget({Key? key, this.car}) : super(key: key);
  final CarModel? car;

  @override
  State<DescriptionPopupWidget> createState() => _DescriptionPopupWidgetState();
}

class _DescriptionPopupWidgetState extends State<DescriptionPopupWidget> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _comanyDescriptionController =
      TextEditingController();

  @override
  void initState() {
    _titleController.text =
        widget.car?.additionalInformation?.attentionGraber ?? notApplicable;
    _descriptionController.text =
        widget.car?.additionalInformation?.description ?? notApplicable;
    _comanyDescriptionController.text =
        widget.car?.additionalInformation?.companyDescription ?? notApplicable;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: getPadding(bottom: 9),
            child: const FieldLabelWidget(label: attentionGrabberLabel),
          ),
          CommonTextFormField(
            controller: _titleController,
            readOnly: true,
          ),
          Padding(
            padding: getPadding(top: 18, bottom: 9),
            child: const FieldLabelWidget(label: descriptionLabel),
          ),
          CommonTextFormField(
            readOnly: true,
            minLines: 5,
            maxLines: 12,
            controller: _descriptionController,
          ),
          if (widget.car?.userType != UserType.private.name)
            Padding(
              padding: getPadding(top: 18, bottom: 9),
              child: const FieldLabelWidget(label: companyDescriptionLabel),
            ),
          if (widget.car?.userType != UserType.private.name)
            CommonTextFormField(
              readOnly: true,
              minLines: 5,
              maxLines: 5,
              controller: _comanyDescriptionController,
            ),
          SizedBox(height: 18.h),
          Align(
            child: CustomElevatedButton(
              title: closeButton,
              width: size.width / 2,
              onTap: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}
