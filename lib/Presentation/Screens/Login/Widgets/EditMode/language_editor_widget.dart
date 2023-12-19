import 'package:aws_cognito_app/app_manager.dart';
import 'package:flutter/material.dart';

class LanguageEditorWidget extends StatefulWidget {
  const LanguageEditorWidget({super.key});

  @override
  State<LanguageEditorWidget> createState() => _LanguageEditorWidgetState();
}

class _LanguageEditorWidgetState extends State<LanguageEditorWidget> {
  List<String> selectedLanguages =
      List.from(AppManager.config.supportedLanguages);

  final Map<String, String> availableLanguages = {
    'Polski': 'PL',
    'Angielski': 'GB',
    'Niemiecki': 'DE',
    'Hiszpański': 'ES',
  };

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Wybierz obsługiwane języki'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: availableLanguages.entries.map((language) {
          return CheckboxListTile(
              title: Text(language.key),
              value: selectedLanguages.contains(language.value),
              onChanged: (value) {
                setState(() {
                  if (value!) {
                    selectedLanguages.add(language.value);
                  } else {
                    selectedLanguages.remove(language.value);
                  }
                });
              });
        }).toList(),
      ),
      actions: [
        TextButton(
          child: const Text('Akcpetuj'),
          onPressed: () => _handleButtonAction(true),
        ),
        TextButton(
          child: const Text('Anuluj'),
          onPressed: () => _handleButtonAction(false),
        ),
      ],
    );
  }

  _handleButtonAction(bool saveChanges) {
    if (saveChanges) {
      AppManager.configService.editSupportedLanguages(selectedLanguages);
    } else {
      setState(() {
        selectedLanguages = AppManager.currentLanguages;
        AppManager.config.supportedLanguages = AppManager.currentLanguages;
      });
    }
    AppManager.mainPageCallback();
    Navigator.of(context).pop();
  }
}
