// ignore_for_file: use_build_context_synchronously

import 'package:aws_cognito_app/Presentation/Config/config_prefs.dart';
import 'package:aws_cognito_app/Presentation/Config/data_fetcher.dart';
import 'package:aws_cognito_app/Presentation/Routes/routes.dart';
import 'package:aws_cognito_app/app_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfigSelectPage extends StatefulWidget {
  const ConfigSelectPage({super.key});

  @override
  State<ConfigSelectPage> createState() => _ConfigSelectPageState();
}

class _ConfigSelectPageState extends State<ConfigSelectPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left,
            color: Colors.black,
            size: 40.0,
          ),
          onPressed: () => Get.toNamed(Routes.getSelectPageRoute()),
        ),
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Wybierz konfigurację do edycji:',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _getConfigContainer(1, true),
                    _getConfigContainer(2, true),
                    _getConfigContainer(3, true),
                  ],
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: TextButton(
              child: const Text('Reset',
                  style: TextStyle(
                    fontSize: 20.0,
                  )),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Reset edycji'),
                    content: SizedBox(
                      width: 500,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: 3,
                        itemBuilder: (context, index) {
                          int num = index + 1;
                          return GestureDetector(
                            child: _getConfigContainer(num, false),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text('Potwierdzenie'),
                                  content: const Text(
                                      'Czy napewno chcesz zresetować ten zapis?'),
                                  actions: [
                                    TextButton(
                                      child: const Text('Tak'),
                                      onPressed: () async {
                                        Get.toNamed(
                                            Routes.getLoadingPageRoute());
                                        await resetConfigFile('config_$num');

                                        Get.back();
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: const Text('Nie'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    actions: [
                      TextButton(
                        child: const Text('Zrobione'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _getConfigContainer(int configNumber, bool loadSave) {
    return GestureDetector(
      onTap: loadSave
          ? () async {
              Get.toNamed(Routes.getLoadingPageRoute());
              await setConfigFile(
                AppManager.userMail,
                AppManager.responses[configNumber - 1],
                'config_$configNumber',
              );

              Get.toNamed(
                Routes.getRestaurantPageRoute(),
                arguments: {
                  'editMode': true,
                  'configFile': 'config_$configNumber',
                },
              );
            }
          : null,
      child: loadSave
          ? Column(
              children: [
                _getContainer(
                  Text(
                    'Edycja $configNumber',
                    style: const TextStyle(
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                SizedBox(
                  width: 25,
                  height: 25,
                  child: Checkbox(
                    value: _getActiveConfig(configNumber),
                    onChanged: (value) {
                      showDialog(
                          context: context,
                          builder: (context) => _getConfigDialog(configNumber));
                    },
                  ),
                )
              ],
            )
          : _getContainer(
              Text(
                'Zapis $configNumber',
                style: const TextStyle(
                  color: Colors.white,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
    );
  }

  Widget _getContainer(Widget child) {
    return Container(
      alignment: Alignment.center,
      height: 150,
      width: 150,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
      decoration: BoxDecoration(
        border: Border.all(
            color: Colors.black, style: BorderStyle.solid, width: 3.0),
        color: Colors.grey,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      child: child,
    );
  }

  bool _getActiveConfig(int configNumber) {
    return 'config_$configNumber' == AppManager.selectedConfig ? true : false;
  }

  AlertDialog _getConfigDialog(int configNumber) {
    return AlertDialog(
      title: const Text('Potwierdzenie'),
      content: const Text('Czy napewno chcesz wybrać ten zapis jako aktywny?'),
      actions: [
        TextButton(
          child: const Text('Tak'),
          onPressed: () async {
            Get.toNamed(Routes.getLoadingPageRoute());
            await setConfigFile(AppManager.userMail,
                AppManager.responses[configNumber - 1], 'config_$configNumber');
            await ConfigPrefs().saveSelectedRecord('config_$configNumber');
            Get.back();
            Navigator.of(context).pop();
            setState(() {});
          },
        ),
        TextButton(
          child: const Text('Nie'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
