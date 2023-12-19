import 'package:aws_cognito_app/app_manager.dart';
import 'package:flutter/material.dart';

class FontEditorWidget extends StatefulWidget {
  const FontEditorWidget({super.key});

  @override
  State<FontEditorWidget> createState() => _FontEditorWidgetState();
}

class _FontEditorWidgetState extends State<FontEditorWidget> {
  String selectedFont = AppManager.config.fontFamily;
  double selectedSize = AppManager.config.fontSize;
  double selectedSecondarySize = AppManager.config.secondaryFontSize;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edytor czcionki'),
      actions: [
        TextButton(
          child: const Text('Akceptuj'),
          onPressed: () {
            AppManager.configService.editMainFont();
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Anuluj'),
          onPressed: () {
            AppManager.config.fontFamily = AppManager.currentFont;
            AppManager.config.fontSize = AppManager.currentFontSize;
            AppManager.config.secondaryFontSize =
                AppManager.currentSecondaryFontSize;

            AppManager.mainPageCallback();
            Navigator.of(context).pop();
          },
        ),
      ],
      content: SizedBox(
        width: 500,
        height: 300,
        child: Column(
          children: [
            const Text("\nWybierz czcionkę, który chcesz używać"),
            DropdownButton<String>(
              value: selectedFont,
              onChanged: (String? newValue) {
                setState(() {
                  selectedFont = newValue!;

                  AppManager.config.fontFamily = selectedFont;
                  AppManager.mainPageCallback();
                });
              },
              items: ['CormorantGaramond', 'Montserrat', 'Poppins', 'RobotoCondensed']
                  .map((String font) {
                return DropdownMenuItem<String>(
                  value: font,
                  child: Text(font),
                );
              }).toList(),
            ),
            const SizedBox(height: 40.0),
            const Text("Wybierz rozmiar głównej czcionki"),
            Row(
              children: [
                Expanded(
                  child: Slider(
                    value: selectedSize,
                    min: 30.0,
                    max: 70.0,
                    onChanged: (double value) {
                      setState(() {
                        selectedSize = value;

                        AppManager.config.fontSize = selectedSize;
                        AppManager.mainPageCallback();
                      });
                    },
                  ),
                ),
                Text(
                  selectedSize.toStringAsFixed(1),
                  style: const TextStyle(fontSize: 18.0),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            const Text("Wybierz rozmiar dodatkowej czcionki"),
            Row(
              children: [
                Expanded(
                  child: Slider(
                    value: selectedSecondarySize,
                    min: 20.0,
                    max: 30.0,
                    onChanged: (double value) {
                      setState(() {
                        selectedSecondarySize = value;

                        AppManager.config.secondaryFontSize =
                            selectedSecondarySize;
                        AppManager.mainPageCallback();
                      });
                    },
                  ),
                ),
                Text(
                  selectedSecondarySize.toStringAsFixed(1),
                  style: const TextStyle(fontSize: 18.0),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
