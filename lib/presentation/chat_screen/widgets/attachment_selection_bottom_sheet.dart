// import '../../../core/configurations.dart';
// import '../../../main.dart';
// import '../../../utility/file_upload_helper.dart';
// import '../../common_widgets/common_bottomsheet.dart';

// void showModelSheetForChatAttachment({
//   int maxFileSize = 10 * 1024,
//   List<String> allowedExtensions = const [],
//   void Function(String?, AttachmentType)? getFile,
// }) {
//   commonBottomSheet(
//     content: Wrap(
//       children: <Widget>[
//         ListTile(
//           leading: const Icon(Icons.photo_camera),
//           title: const Text('Camera'),
//           onTap: () async {
//             Navigator.pop(globalNavigatorKey.currentContext!);

//             String pickedFile = await FileManager()
//                 .imgFromCamera(false, maxFileSize, allowedExtensions);
//             if (getFile != null) {
//               getFile(pickedFile, AttachmentType.image);
//             }
//           },
//         ),
//         ListTile(
//           leading: const Icon(Icons.photo_library),
//           title: const Text('Photos'),
//           onTap: () async {
//             Navigator.pop(globalNavigatorKey.currentContext!);

//             String pickedFile = await FileManager()
//                 .imgFromGallery(false, maxFileSize, allowedExtensions);
//             if (getFile != null && pickedFile.isNotEmpty) {
//               getFile(pickedFile, AttachmentType.image);
//             }
//           },
//         ),
//         // ListTile(
//         //   leading: const Icon(Icons.video_call),
//         //   title: const Text('Video'),
//         //   onTap: () async {
//         //     Navigator.pop(globalNavigatorKey.currentContext!);

//         //     String pickedFile = await FileManager()
//         //         .imgFromGallery(true, maxFileSize, allowedExtensions);
//         //     if (getFile != null) {
//         //       getFile(pickedFile, AttachmentType.video);
//         //     }
//         //   },
//         // ),
//         // ListTile(
//         //   leading: const Icon(Icons.file_present_rounded),
//         //   title: const Text('Document'),
//         //   onTap: () async {
//         //     Navigator.pop(globalNavigatorKey.currentContext!);
//         //     String pickedFile = await FileManager().filePicker();
//         //     if (getFile != null) {
//         //       log(pickedFile);
//         //       getFile(pickedFile, AttachmentType.document);
//         //     }
//         //   },
//         // ),
//       ],
//     ),
//   );
// }
