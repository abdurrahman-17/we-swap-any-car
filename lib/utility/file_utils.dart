// ignore_for_file: avoid_catches_without_on_clauses
import 'dart:developer';
import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';

import '../core/configurations.dart';
export 'package:image_picker/image_picker.dart';

//pick image from Gallery or Camera
Future<File?> imagePicker({required ImageSource imageSource}) async {
  try {
    XFile? pickedFile = await ImagePicker().pickImage(source: imageSource);
    if (pickedFile != null) {
      log(pickedFile.name);
      return File(pickedFile.path);
    }
    return null;
  } catch (e) {
    log("exception_pickUserProfileImage : $e");
    return null;
  }
}

//get file name from [File]
extension FileExtension on FileSystemEntity {
  String get name {
    return path.split("/").last;
  }
}

///this function return the size of the file in [MB/KB]
double getFileSizeInMB(File file, {bool isInKB = false}) {
  int bytes = file.lengthSync();
  final kb = bytes / 1024;
  final mb = bytes / (1024 * 1024);
  return isInKB
      ? double.parse(kb.toStringAsFixed(2))
      : double.parse(mb.toStringAsFixed(2));
}

//getTemporaryDirectoryPath [for Android eg: /data/user/0/com.app.wsac/cache]
Future<String> getTemporaryDirectoryPath() async {
  final Directory tempDir = await getTemporaryDirectory();
  return tempDir.path;
}

///image cropper function
Future<String?> imageCropper({required String filePath}) async {
  try {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
      sourcePath: filePath,
      cropStyle: CropStyle.circle,
      aspectRatioPresets: [CropAspectRatioPreset.square],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Image Cropper',
          toolbarColor: ColorConstant.kPrimaryDarkRed,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(title: 'Image Cropper', doneButtonTitle: "Crop")
      ],
    );
    return croppedImage?.path;
  } catch (e, stack) {
    sentryExceptionCapture(throwable: e, stackTrace: stack);
    return null;
  }
}
