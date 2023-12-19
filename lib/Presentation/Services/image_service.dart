import 'dart:io';

import 'package:aws_cognito_app/app_manager.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:archive/archive.dart';

class ImageService {
  ImageService();

  addImageToZip(Uint8List imageData, String name) {
    AppManager.imagesByBytes[name] = imageData;
  }

  Future<void> createAndSaveZip(String configFile) async {
    Archive archive = _buildArchive();

    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    String zipFilePath = '$appDocPath/images_$configFile.zip';

    File zipFile = File(zipFilePath);
    zipFile.writeAsBytesSync(ZipEncoder().encode(archive)!);
  }

  Future<void> readImagesFromZip(String configFile) async {
    ZipDecoder zipDecoder = ZipDecoder();
    AppManager.imagesByBytes = {};

    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    String zipFilePath = '$appDocPath/images_$configFile.zip';

    File zipFile = File(zipFilePath);

    try {
      List<int> zipData = await zipFile.readAsBytes();
      Archive archive = zipDecoder.decodeBytes(zipData);
      populateImagesFromArchive(archive);
    } catch (e) {
      await _createEmptyZip(appDocDir, configFile);
    }
  }

  Future<void> _createEmptyZip(Directory appDocPath, String configFile) async {
    Archive archive = Archive();
    String zipFilePath = '${appDocPath.path}/images_$configFile.zip';

    File zipFile = File(zipFilePath);
    zipFile.writeAsBytesSync(ZipEncoder().encode(archive)!);
  }

  Archive _buildArchive() {
    Archive archive = Archive();
    AppManager.imagesByBytes.forEach((name, imageData) {
      ArchiveFile file = ArchiveFile(name, imageData.length, imageData);
      archive.addFile(file);
    });
    return archive;
  }

  populateImagesFromArchive(Archive archive) {
    for (ArchiveFile file in archive) {
      List<int> imageData = file.content as List<int>;
      AppManager.imagesByBytes[file.name] = Uint8List.fromList(imageData);
    }
  }
}
