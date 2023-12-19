import 'dart:io';
import 'dart:convert';

import 'package:aws_cognito_app/Presentation/Models/Data/response_data.dart';
import 'package:aws_cognito_app/Presentation/Services/image_service.dart';
import 'package:aws_cognito_app/Presentation/Models/config_model.dart';
import 'package:aws_cognito_app/Presentation/Services/connection_service.dart';
import 'package:aws_cognito_app/Presentation/Services/http_service.dart';
import 'package:aws_cognito_app/Presentation/Services/s3_bucket_service.dart';
import 'package:aws_cognito_app/app_manager.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

const String defaultFileName = 'mock_restaurant.json';

Future<String> _getJsonFileName(String configFileName) async {
  String documentsPath = await getDocumentsDirectoryPath();
  String configFilePath = '$documentsPath/$configFileName';

  if (await File(configFilePath).exists()) {
    return configFileName;
  } else {
    File configFile = File(configFilePath);
    await configFile.create();
    await configFile.writeAsString(await getDefaultConfigFile());

    return defaultFileName;
  }
}

Future<String> _readJsonFile(String fileName) async {
  String documentsPath = await getDocumentsDirectoryPath();
  String filePath = '$documentsPath/$fileName';

  if (await File(filePath).exists()) {
    return await File(filePath).readAsString();
  } else {
    final configFile = File('$documentsPath/$fileName');
    String defaultConfigFile =
        await rootBundle.loadString('assets/json/$fileName');

    await configFile.writeAsString(jsonEncode(jsonDecode(defaultConfigFile)));
    return defaultConfigFile;
  }
}

resetConfigFile(String configFile) async {
  String documentsPath = await getDocumentsDirectoryPath();
  final config = File('$documentsPath/$configFile.json');
  String defaultConfigFile =
      await rootBundle.loadString('assets/json/$defaultFileName');

  await config.writeAsString(jsonEncode(jsonDecode(defaultConfigFile)));
  Map<String, dynamic> jsonData = await jsonDecode(defaultConfigFile);
  AppManager.config = ConfigModel.fromJson(jsonData);

  await postConfigFile(AppManager.userMail, AppManager.userID);
  await uploadFilesToS3_V2(true);

  String zipFilePath = '$documentsPath/images_$configFile.zip';
  File zipFile = File(zipFilePath);
  zipFile.delete().then((value) {
    debugPrint('Plik został usunięty');
  }).catchError((error) {
    debugPrint('Wystąpił błąd podczas usuwania pliku: $error');
  });
}

setConfigFile(
    String email, ResponseData responseData, String configFile) async {
  AppManager.config = responseData.configModel;
  AppManager.selectedConfig = configFile;
  AppManager.selectedConfigId = responseData.id;
}

downloadImages(String email, String userId) async {
  bool isConnected = await ConnectionService().checkInternetConnection();
  if (isConnected) {
    debugPrint('Użytkownik ma dostęp do internetu');
    var jsonData = await getRequest(email, userId);

    if (!kIsWeb) {
      await downloadAndExtractFilesFromS3_V2(userId);
    } else {
      await downloadAndExtractFilesFromS3_V2_Web_Version(userId);
    }
  } else {
    //TODO: HANDLE LOST CONNECTION
    debugPrint('Użytkownik nie ma dostępu do internetu');
  }
}

postConfigFile(String email, String id) async {
  bool isConnected = await ConnectionService().checkInternetConnection();
  if (isConnected) {
    await postRequest(email, id, AppManager.config);
  } else {
    //TODO: HANDLE LOST CONNECTION
    debugPrint('Użytkownik nie ma dostępu do internetu');
  }
}

Future<void> deleteConfigFiles() async {
  final directory = await getApplicationDocumentsDirectory();
  final files = directory.listSync();

  for (var file in files) {
    if (file is File && file.path.contains('config_')) {
      try {
        await file.delete();
        debugPrint('Usunięto plik: ${file.path}');
      } catch (e) {
        debugPrint('Błąd usuwania pliku ${file.path}: $e');
      }
    }
  }
}

Future<String> getDocumentsDirectoryPath() async {
  Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
  return appDocumentsDirectory.path;
}

Future<String> getDefaultConfigFile() async {
  String defaultConfigFile =
      await rootBundle.loadString('assets/json/$defaultFileName');

  return jsonEncode(jsonDecode(defaultConfigFile));
}
