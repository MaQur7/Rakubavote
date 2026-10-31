import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

/// Takes a photo with the camera where the device has one supported (Android
/// tablets); on laptops it opens a file chooser for a photo taken elsewhere.
/// Photos are scaled down to keep the encrypted database small.
Future<Uint8List?> capturePhoto({bool preferCamera = true}) async {
  final picker = ImagePicker();
  final camera = preferCamera && picker.supportsImageSource(ImageSource.camera);
  final file = await picker.pickImage(
    source: camera ? ImageSource.camera : ImageSource.gallery,
    maxWidth: 600,
    maxHeight: 600,
    imageQuality: 80,
  );
  return file?.readAsBytes();
}

Future<Uint8List?> pickImageFile() => capturePhoto(preferCamera: false);

Future<String?> pickCsvText() async {
  final f = await FilePicker.pickFile(type: FileType.custom, allowedExtensions: ['csv', 'txt']);
  if (f == null) return null;
  return utf8.decode(await f.readAsBytes(), allowMalformed: true);
}

Future<String?> pickFolder() => FilePicker.getDirectoryPath();
