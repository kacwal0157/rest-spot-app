import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive_io.dart';
import 'package:aws_cognito_app/Presentation/Services/image_service.dart';
import 'package:aws_cognito_app/app_manager.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:convert';

Future<String> _getPresignedURL(bool isGet) async {
  String action = isGet ? 'get' : 'put';
  String userID = AppManager.userID;
  String url =
      'https://lq0hjcqtve.execute-api.eu-central-1.amazonaws.com/presigned?fileName=$userID.zip&action=$action';

  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    return response.body;
  } else {
    return 'Nie udało się uzyskać presigned URL.';
  }
}

Future<String> _getPresignedURL_V2(bool isGet, String userID) async {
  String action = isGet ? 'get' : 'put';
  String url =
      'https://lq0hjcqtve.execute-api.eu-central-1.amazonaws.com/presigned?fileName=$userID.zip&action=$action';

  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    return response.body;
  } else {
    return 'Nie udało się uzyskać presigned URL.';
  }
}

Future<void> uploadFilesToS3(bool sendEmpty) async {
  String presignedURL = await _getPresignedURL(false);
  Archive mainArchive = Archive();

  if (!sendEmpty) {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    List<FileSystemEntity> zipFiles = appDocDir.listSync().where((entity) {
      return entity is File && entity.path.contains('.zip');
    }).toList();

    for (var zipFile in zipFiles) {
      Archive zipArchive = Archive();
      ZipDecoder zipDecoder = ZipDecoder();

      List<int> zipData = await (zipFile as File).readAsBytes();
      String zipFileName = zipFile.uri.pathSegments.last;

      Archive innerArchive = zipDecoder.decodeBytes(zipData);
      for (ArchiveFile innerFile in innerArchive) {
        List<int> innerFileData = innerFile.content as List<int>;
        zipArchive.addFile(
            ArchiveFile(innerFile.name, innerFileData.length, innerFileData));
      }

      mainArchive.addFile(ArchiveFile(
          zipFileName, zipArchive.length, ZipEncoder().encode(zipArchive)));
    }
  }

  await _putRecordToAWS(presignedURL, mainArchive);
}

Future<void> uploadFilesToS3_V2(bool sendEmpty) async {
  String presignedURL = await _getPresignedURL(false);
  Archive mainArchive = Archive();

  if (!sendEmpty) {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    final zipFiles = appDocDir
        .listSync(recursive: true)
        .where((entity) {
          return entity is File && entity.path.contains('/images/');
        })
        .map((e) => File(e.path))
        .toList();

    var encoder = ZipFileEncoder();
    encoder.create('${appDocDir.path}/images.zip');

    for (var zipFile in zipFiles) {
      encoder.addFile(zipFile);
    }

    encoder.close();
    await _putRecordToAWS_V2(
        presignedURL, File('${appDocDir.path}/images.zip').readAsBytesSync());
  }
}

Future<void> uploadFilesToS3_Web_V2(bool sendEmpty) async {
  String presignedURL = await _getPresignedURL(false);
  Archive archive = new Archive();
  if (!sendEmpty) {
    for (var key in AppManager.storage.images.keys) {
      archive.addFile(
          createArchiveFile(key, AppManager.storage.getImageBase64(key)));
    }

    final Uint8List zipBytes =
        Uint8List.fromList(ZipEncoder().encode(archive)!);

    await _putRecordToAWS_V2(presignedURL, zipBytes);
  }
}

ArchiveFile createArchiveFile(String fileName, String base64String) {
  List<int> bytes = decodeBase64ToBytes(base64String);
  return ArchiveFile(fileName, bytes.length, bytes);
}

List<int> decodeBase64ToBytes(String base64String) {
  return base64Decode(base64String);
}

Future<void> downloadAndExtractFilesFromS3(String configFile) async {
  String presignedURL = await _getPresignedURL(true);
  final response = await http.get(Uri.parse(presignedURL));

  if (response.statusCode == 200) {
    debugPrint('Pliki zostały pomyślnie pobrane z S3 Bucket.');
    Archive mainArchive = ZipDecoder().decodeBytes(response.bodyBytes);
    Directory appDocDir = await getApplicationDocumentsDirectory();

    for (ArchiveFile zipFile in mainArchive) {
      List<int> zipData = zipFile.content as List<int>;
      Archive innerArchive = ZipDecoder().decodeBytes(zipData);

      ImageService().populateImagesFromArchive(innerArchive);
      for (ArchiveFile innerFile in innerArchive) {
        List<int> innerFileData = innerFile.content as List<int>;
        File newFile = File('${appDocDir.path}/images_$configFile.zip');

        await newFile.writeAsBytes(innerFileData, flush: true);
      }
    }
  } else {
    debugPrint('Error: ${response.statusCode}');
  }
}

Future<void> downloadAndExtractFilesFromS3_V2(String userID) async {
  String presignedURL = await _getPresignedURL_V2(true, userID);
  final response = await http.get(Uri.parse(presignedURL));

  if (response.statusCode == 200) {
    debugPrint('Pliki zostały pomyślnie pobrane z S3 Bucket.');
    Archive mainArchive = ZipDecoder().decodeBytes(response.bodyBytes);
    Directory appDocDir = await getApplicationDocumentsDirectory();

    await Directory('${appDocDir.path}/images').create(recursive: true);
    for (ArchiveFile innerFile in mainArchive) {
      List<int> innerFileData = innerFile.content as List<int>;
      File newFile = File('${appDocDir.path}/images/${innerFile.name}');

      await newFile.writeAsBytes(innerFileData, flush: true);
    }
  } else {
    debugPrint('Error: ${response.statusCode}');
  }
}

Future<void> downloadAndExtractFilesFromS3_V2_Web_Version(String userID) async {
  String presignedURL = await _getPresignedURL_V2(true, userID);
  final response = await http.get(Uri.parse(presignedURL));

  if (response.statusCode == 200) {
    debugPrint('Pliki zostały pomyślnie pobrane z S3 Bucket.');
    Archive mainArchive = ZipDecoder().decodeBytes(response.bodyBytes);
    for (ArchiveFile innerFile in mainArchive) {
      List<int> innerFileData = innerFile.content as List<int>;
      String base64String = base64Encode(innerFileData);

      saveData(innerFile.name, base64String);
    }
  } else {
    debugPrint('Error: ${response.statusCode}');
  }
}

Future<void> saveData(String key, dynamic value) async {
  AppManager.storage.setItem(key, value);
}

Future<void> _putRecordToAWS(String presignedURL, Archive mainArchive) async {
  final response = await http.put(Uri.parse(presignedURL),
      body: ZipEncoder().encode(mainArchive)!);

  if (response.statusCode == 200) {
    debugPrint('Pliki zostały pomyślnie wysłane do S3 Bucket.');
  } else {
    debugPrint('Error: ${response.statusCode}');
  }
}

Future<void> _putRecordToAWS_V2(
    String presignedURL, Uint8List fileStream) async {
  final response = await http.put(Uri.parse(presignedURL), body: fileStream);

  if (response.statusCode == 200) {
    debugPrint('Pliki zostały pomyślnie wysłane do S3 Bucket.');
  } else {
    debugPrint('Error: ${response.statusCode}');
  }
}
