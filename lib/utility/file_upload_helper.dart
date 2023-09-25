// ignore_for_file: avoid_catches_without_on_clauses

import 'dart:developer';
import 'dart:io';
import '../core/configurations.dart';
import '../main.dart';
import '../presentation/common_widgets/common_bottomsheet.dart';
import '../presentation/common_widgets/common_loader.dart';
import 'file_utils.dart';

class FileManager {
  final ImagePicker _picker = ImagePicker();

  Future<void> showModelSheetForImage({
    int maxFileSize = 10 * 1024,
    List<String> allowedExtensions = const [],
    void Function(List<String>)? getFiles,
    bool isMultiImage = false,
    void Function(String?)? getFile,
    bool pickVideo = false,
    int fileCount = multiImageCount,
    int maxFileCount = multiImageCount,
    Function? setLoader,
    bool isAtTime = false,
  }) async {
    List<String> allowedExtensionFormats = allowedExtensions;
    if (allowedExtensionFormats.isEmpty) {
      if (pickVideo) {
        allowedExtensionFormats = videoFormats;
      } else {
        allowedExtensionFormats = imageFormats;
      }
    }
    commonBottomSheet(
      content: Wrap(
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Gallery'),
            onTap: () async {
              Navigator.pop(globalNavigatorKey.currentContext!);
              if (isMultiImage) {
                if (setLoader != null) {
                  setLoader();
                }
                List<String> imageList = await _multiImgFromGallery(
                  maxFileSize: maxFileSize,
                  allowedExtensions: allowedExtensionFormats,
                  count: fileCount,
                  maxFileCount: maxFileCount,
                  isAtTime: isAtTime,
                );
                if (getFiles != null) {
                  getFiles(imageList);
                }
              } else {
                if (setLoader != null) {
                  setLoader();
                }
                String pickedFile = await fromGallery(
                  isVideo: pickVideo,
                  maxFileSize: maxFileSize,
                  allowedExtensions: allowedExtensionFormats,
                );
                if (getFile != null) {
                  getFile(pickedFile);
                }
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_camera),
            title: const Text('Camera'),
            onTap: () async {
              Navigator.pop(globalNavigatorKey.currentContext!);
              if (isMultiImage) {
                if (setLoader != null) {
                  setLoader();
                }
                List<String> imageList = await _multiImgFromCamera(
                  maxFileSize: maxFileSize,
                  allowedExtensions: allowedExtensionFormats,
                  count: fileCount,
                  maxFileCount: maxFileCount,
                  isAtTime: isAtTime,
                );
                if (getFiles != null) {
                  getFiles(imageList);
                }
              } else {
                if (setLoader != null) {
                  setLoader();
                }
                String pickedFile = await fromCamera(
                  isVideo: pickVideo,
                  maxFileSize: maxFileSize,
                  allowedExtensions: allowedExtensionFormats,
                );
                if (getFile != null) {
                  getFile(pickedFile);
                }
              }
            },
          )
        ],
      ),
    );
  }

  Future<List<String>> _multiImgFromGallery({
    required int maxFileSize,
    required List<String> allowedExtensions,
    required int count,
    required int maxFileCount,
    required bool isAtTime,
  }) async {
    List<String> files = [];
    String formatErrorMsg =
        "The uploaded file is not supported.Please choose a "
        "${(allowedExtensions.join(', ')).toUpperCase()} format";
    try {
      setLoading(true);
      List<XFile> res1 = await _picker.pickMultiImage(imageQuality: 50);
      bool isFileSizeError = false;
      bool isFormateError = false;
      setLoading(false);
      if (res1.length > count) {
        res1.removeRange((res1.length - (res1.length - count)), res1.length);
        showSnackBar(
            message: isAtTime
                ? "At a time maximum of $maxFileCount photos are permitted"
                : "Maximum of $maxFileCount photos are permitted");
      }

      for (var element in res1) {
        var extension = element.path.split('.');
        if (allowedExtensions.isNotEmpty &&
            !allowedExtensions.contains(extension.last)) {
          isFormateError = true;
        } else {
          if (getFileSizeInMB(File(element.path)) > imageUploadLimit) {
            isFileSizeError = true;
          } else {
            files.add(element.path);
          }
        }
      }
      //consolidated toast
      if (isFileSizeError) showSnackBar(message: maxUploadImgSize5MB);
      if (isFormateError) showSnackBar(message: formatErrorMsg);

      return files;
    } catch (_) {
      return files;
    }
  }

  Future<List<String>> _multiImgFromCamera({
    required int maxFileSize,
    required List<String> allowedExtensions,
    required int count,
    required int maxFileCount,
    required bool isAtTime,
  }) async {
    //currently multi image from camera is not supported
    List<String> files = [];

    try {
      String pickedFile = await fromCamera(
        isVideo: false,
        maxFileSize: maxFileSize,
        allowedExtensions: allowedExtensions,
      );
      if (pickedFile.isNotEmpty) {
        files.add(pickedFile);
      }

      return files;
    } catch (_) {
      return files;
    }
  }

  Future<String> fromGallery({
    required bool isVideo,
    required int maxFileSize,
    required List<String> allowedExtensions,
  }) async {
    String file = '';

    String formatErrorMsg =
        "The uploaded file is not supported.Please choose a "
        "${(allowedExtensions.join(', ')).toUpperCase()} format";
    try {
      setLoading(true);
      XFile? xFile = isVideo
          ? await _picker.pickVideo(source: ImageSource.gallery)
          : await _picker.pickImage(
              source: ImageSource.gallery,
              imageQuality: 50,
            );
      setLoading(false);
      if (xFile != null) {
        var extension = xFile.path.split('.');
        log("Image Extension : ${extension.last}");
        log("Image Size(qual-50): ${getFileSizeInMB(File(xFile.path))} MB");

        if (allowedExtensions.isNotEmpty &&
            !allowedExtensions.contains(extension.last.toLowerCase())) {
          showSnackBar(message: formatErrorMsg);
          return file;
        }

        if (isVideo && getFileSizeInMB(File(xFile.path)) > videoUploadLimit) {
          showSnackBar(message: maxUploadImgSize20MB);
        } else if (!isVideo &&
            getFileSizeInMB(File(xFile.path)) > imageUploadLimit) {
          showSnackBar(message: maxUploadImgSize5MB);
        } else {
          file = xFile.path;
        }
      }
      return file;
    } catch (_) {
      return file;
    }
  }

  Future<String> fromCamera({
    required bool isVideo,
    required int maxFileSize,
    required List<String> allowedExtensions,
  }) async {
    String file = '';
    String formatErrorMsg =
        "The uploaded file is not supported.Please choose a "
        "${(allowedExtensions.join(', ')).toUpperCase()} format";
    try {
      setLoading(true);
      XFile? xFile = isVideo
          ? await _picker.pickVideo(source: ImageSource.camera)
          : await _picker.pickImage(
              source: ImageSource.camera,
              imageQuality: 50,
            );
      setLoading(false);
      if (xFile != null) {
        var extension = xFile.path.split('.');
        log("Image Extension : ${extension.last}");
        log("Image Size: ${getFileSizeInMB(File(xFile.path))} MB");

        if (allowedExtensions.isNotEmpty &&
            !allowedExtensions.contains(extension.last)) {
          showSnackBar(message: formatErrorMsg);
          return file;
        }

        if (isVideo && getFileSizeInMB(File(xFile.path)) > videoUploadLimit) {
          showSnackBar(message: maxUploadImgSize20MB);
        } else if (!isVideo &&
            getFileSizeInMB(File(xFile.path)) > imageUploadLimit) {
          showSnackBar(message: maxUploadImgSize5MB);
        } else {
          file = xFile.path;
        }
      }
      return file;
    } catch (_) {
      return file;
    }
  }

  void setLoading(bool loader) {
    if (loader) {
      progressDialogue();
    } else {
      Navigator.pop(globalNavigatorKey.currentContext!);
    }
  }
}
