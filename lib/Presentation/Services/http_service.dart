import 'dart:convert';

import 'package:aws_cognito_app/Presentation/Config/data_fetcher.dart';
import 'package:aws_cognito_app/Presentation/Models/Data/response_data.dart';
import 'package:aws_cognito_app/Presentation/Models/config_model.dart';
import 'package:aws_cognito_app/Presentation/Services/s3_bucket_service.dart';
import 'package:aws_cognito_app/app_manager.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'package:flutter/foundation.dart';

Future<void> postRequest(
    String emial, String id, ConfigModel configModel) async {
  var url = '${AppManager.url}/save?email=$emial&id=$id';
  final data = {"email": emial, "id": id, "data": configModel};
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${AppManager.awsToken}'
  };

  final response =
      await http.post(Uri.parse(url), headers: headers, body: jsonEncode(data));

  if (response.statusCode == 201) {
    debugPrint('Data sent');
    if (kIsWeb) {
      await uploadFilesToS3_Web_V2(false);
    } else {
      await uploadFilesToS3_V2(false);
    }
  } else {
    debugPrint('Error: ${response.statusCode}');
  }
}

Future<Map<String, dynamic>> getRequest(String email, String id) async {
  var url = '${AppManager.url}/get?email=$email&id=$id';
  final headers = {'Authorization': 'Bearer ${AppManager.awsToken}'};

  final response = await http.get(Uri.parse(url), headers: headers);
  Map<String, dynamic> config = <String, dynamic>{};

  if (response.statusCode == 200) {
    final responseData = await jsonDecode(utf8.decode(response.bodyBytes));

    for (Map<String, dynamic> data in responseData) {
      if (data['id'] == id) {
        AppManager.userID = id;
        config = data['data'];
      }
    }
  } else {
    debugPrint('Error: ${response.statusCode}');
  }

  return config;
}

Future<List<ResponseData>> getUserMetadata(String email) async {
  List<ResponseData> dataList = [];

  var url = '${AppManager.url}/get?email=$email';
  final headers = {'Authorization': 'Bearer ${AppManager.awsToken}'};

  final response = await http.get(Uri.parse(url), headers: headers);
  if (response.statusCode == 200) {
    List<dynamic> responseData =
        await jsonDecode(utf8.decode(response.bodyBytes));

    if (responseData.isEmpty) {
      await createAWSRecords(email);

      var url = '${AppManager.url}/get?email=$email';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        responseData = await jsonDecode(response.body);
      }
    }

    for (Map<String, dynamic> data in responseData) {
      var configModel = ConfigModel.fromJson(data['data']);
      if (AppManager.userMail == '') {
        AppManager.userMail = data['email'];
      }
      dataList.add(ResponseData(data['id'], configModel));
    }

    if (!kIsWeb) {
      await deleteConfigFiles();
    }
  } else {
    debugPrint('Error: ${response.statusCode}');
  }

  return dataList;
}

Future<void> createAWSRecords(String emial) async {
  var url = '${AppManager.url}/save?email=$emial';
  var config = await getDefaultConfigFile();

  for (int records = 0; records < 3; records++) {
    final data = {
      "email": emial,
      "id": const Uuid().v4(),
      "data": jsonDecode(config)
    };

    final response = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json'}, body: jsonEncode(data));

    if (response.statusCode == 201) {
      debugPrint("Data created");
    } else {
      debugPrint('Error: ${response.statusCode}');
    }
  }
}
