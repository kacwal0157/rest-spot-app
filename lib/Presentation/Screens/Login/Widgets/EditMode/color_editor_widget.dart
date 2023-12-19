import 'package:aws_cognito_app/app_manager.dart';
import 'package:flutter/material.dart';
import 'package:aws_cognito_app/Presentation/Models/hex_color.dart';
import 'package:flex_color_picker/flex_color_picker.dart';

class ColorEditorWidget extends StatefulWidget {
  const ColorEditorWidget({super.key});

  @override
  State<ColorEditorWidget> createState() => _ColorEditorWidgetState();
}

class _ColorEditorWidgetState extends State<ColorEditorWidget> {
  List<Color> defaultRecentColors = List.filled(8, Colors.blueGrey.shade100);
  Color selectedColor = Colors.white;
  Map<String, bool> isSelected = {
    'layout': true,
    'font': false,
  };

  @override
  Widget build(BuildContext context) {
    selectedColor = isSelected['layout']!
        ? HexColor(AppManager.config.mainColor)
        : HexColor(AppManager.config.fontColor);
    return AlertDialog(
      title: const Text('Edytor kolorów'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          RichText(
              text: TextSpan(
                  style: const TextStyle(fontSize: 18, color: Colors.black),
                  children: [
                const TextSpan(text: 'Obecnie używasz koloru: '),
                TextSpan(
                    text: ColorTools.nameThatColor(selectedColor),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: selectedColor,
                        shadows:
                            ColorTools.nameThatColor(selectedColor) != 'White'
                                ? null
                                : [
                                    const Shadow(
                                      color: Colors.black,
                                      offset: Offset(1, 1),
                                      blurRadius: 2,
                                    ),
                                  ],
                        fontStyle: FontStyle.italic)),
                const TextSpan(text: '\nKliknij aby go edytować. \n')
              ])),
          ToggleButtons(
              isSelected: isSelected.values.toList(),
              selectedColor: Colors.white,
              color: Colors.blue,
              fillColor: Colors.lightBlue.shade500,
              splashColor: Colors.lightBlue.shade100,
              highlightColor: Colors.black,
              textStyle: const TextStyle(fontWeight: FontWeight.bold),
              renderBorder: true,
              borderColor: Colors.grey,
              borderWidth: 1.5,
              borderRadius: BorderRadius.circular(10),
              selectedBorderColor: Colors.lightBlue.shade800,
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Text('Układ', style: TextStyle(fontSize: 18)),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text('Czcionka', style: TextStyle(fontSize: 18)),
                ),
              ],
              onPressed: (int newIndex) {
                setState(() {
                  int index = 0;
                  for (final key in isSelected.keys) {
                    isSelected[key] = index == newIndex;
                    index++;
                  }
                });
              }),
          const SizedBox(height: 20.0),
          ColorIndicator(
            width: 50,
            height: 50,
            borderRadius: 4,
            color: selectedColor,
            hasBorder: true,
            borderColor: ColorTools.nameThatColor(selectedColor) != 'White'
                ? Colors.white
                : Colors.black,
            onSelectFocus: false,
            onSelect: () async {
              final Color colorBeforeDialog = selectedColor;
              final bool dialogResult = await _colorPickerDialog();
              if (!dialogResult) {
                setState(() {
                  selectedColor = colorBeforeDialog;
                });
              }
            },
          ),
          Text(
              '\nKod koloru: ${ColorTools.materialNameAndCode(selectedColor)}'),
        ],
      ),
      actions: [
        TextButton(
          child: const Text('Akceptuj'),
          onPressed: () {
            AppManager.configService.editColors();
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Anuluj'),
          onPressed: () {
            AppManager.config.mainColor = AppManager.currentColor;
            AppManager.config.fontColor = AppManager.currentFontColor;
            AppManager.mainPageCallback();

            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  Future<bool> _colorPickerDialog() async {
    return ColorPicker(
      heading: Text(
        'Wybierz kolor',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
      wheelSubheading: Text(
        'Wybierz kolor i jego odcień',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      opacitySubheading: Text(
        'Przeźroczystość',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      recentColorsSubheading: Text(
        'Poprzednie kolory',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      borderRadius: 4,
      elevation: 0,
      spacing: 6,
      runSpacing: 10,
      hasBorder: false,
      enableShadesSelection: true,
      enableOpacity: true,
      showColorName: false,
      showColorCode: true,
      colorCodeHasColor: true,
      crossAxisAlignment: CrossAxisAlignment.center,
      columnSpacing: 20,
      showRecentColors: true,
      maxRecentColors: 8,
      recentColors: defaultRecentColors,
      subheading: Text(
        'Wybierz odcień koloru',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      color: selectedColor,
      pickerTypeLabels: const <ColorPickerType, String>{
        ColorPickerType.primary: 'Główne',
        ColorPickerType.accent: 'Dodatkowe',
        ColorPickerType.wheel: 'Dowolny',
      },
      pickersEnabled: const <ColorPickerType, bool>{
        ColorPickerType.both: false,
        ColorPickerType.primary: true,
        ColorPickerType.accent: true,
        ColorPickerType.bw: false,
        ColorPickerType.custom: false,
        ColorPickerType.wheel: true,
      },
      actionButtons: const ColorPickerActionButtons(
        okButton: false,
        closeButton: false,
        dialogActionButtons: true,
        dialogActionIcons: true,
        dialogOkButtonType: ColorPickerActionButtonType.text,
        dialogCancelButtonType: ColorPickerActionButtonType.text,
        dialogActionOrder: ColorPickerActionButtonOrder.okIsLeft,
        dialogCancelButtonLabel: 'Anuluj',
        dialogOkButtonLabel: 'Akceptuj',
      ),
      copyPasteBehavior: const ColorPickerCopyPasteBehavior(
        editFieldCopyButton: true,
        copyButton: true,
        pasteButton: true,
        copyFormat: ColorPickerCopyFormat.hexAARRGGBB,
      ),
      onColorChanged: (Color color) {
        setState(() {
          selectedColor = color;

          isSelected['layout']!
              ? AppManager.config.mainColor =
                  ColorTools.colorCode(selectedColor)
              : AppManager.config.fontColor =
                  ColorTools.colorCode(selectedColor);
        });
      },
    ).showPickerDialog(
      context,
      transitionBuilder: (BuildContext context, Animation<double> a1,
          Animation<double> a2, Widget widget) {
        final double curvedValue =
            Curves.easeInOutBack.transform(a1.value) - 1.0;
        return Transform(
          transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
          child: Opacity(
            opacity: a1.value,
            child: widget,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
      constraints:
          const BoxConstraints(minHeight: 550, minWidth: 500, maxWidth: 600),
    );
  }
}
