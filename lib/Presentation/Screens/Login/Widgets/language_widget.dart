import 'package:aws_cognito_app/Presentation/Services/language_service.dart';
import 'package:aws_cognito_app/app_manager.dart';
import 'package:flutter/material.dart';
import 'package:flag/flag.dart';

class LanguageWidget extends StatefulWidget {
  const LanguageWidget(
      {super.key,
      required this.languageService,
      required this.pageCallback});

  final LanguageService languageService;
  final Function pageCallback;

  @override
  State<LanguageWidget> createState() => _LanguageWidget();
}

class _LanguageWidget extends State<LanguageWidget> {
  @override
  Widget build(BuildContext context) {
    var languageCodes = AppManager.config.supportedLanguages;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: _getFlags(languageCodes),
    );
  }

  _getFlags(List<String> langCodes)
  {
    List<Widget> widgets = [];
    for(var code = 0; code < langCodes.length; code++)
    {
      widgets.add(_getLanguageFlag(langCodes[code]));
    }

    return widgets;
  }

  _getLanguageFlag(String langCode)
  {
    Flag countryFlag = Flag.fromString(langCode);

    return Container(
          padding: const EdgeInsets.only(right: 10),
          child: IconButton(
            onPressed: () {
              widget.languageService.changeLanguage(langCode);
              widget.pageCallback();
            },
            icon: countryFlag,
            iconSize: 20,
          ),
        );
  }
}
