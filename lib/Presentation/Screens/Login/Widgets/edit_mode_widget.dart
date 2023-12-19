import 'package:aws_cognito_app/Presentation/Declarations/Constants/constant_enums.dart';
import 'package:aws_cognito_app/Presentation/Models/config_model.dart';
import 'package:aws_cognito_app/Presentation/Routes/routes.dart';
import 'package:aws_cognito_app/Presentation/Screens/Login/Widgets/EditMode/color_editor_widget.dart';
import 'package:aws_cognito_app/Presentation/Screens/Login/Widgets/EditMode/content_amount_editor_widget.dart';
import 'package:aws_cognito_app/Presentation/Screens/Login/Widgets/EditMode/font_editor_widget.dart';
import 'package:aws_cognito_app/Presentation/Screens/Login/Widgets/EditMode/language_editor_widget.dart';
import 'package:aws_cognito_app/Presentation/Screens/Login/Widgets/EditMode/table_layout_widget.dart';
import 'package:aws_cognito_app/app_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class EditModeWidget extends StatefulWidget {
  const EditModeWidget({
    super.key,
    required this.pageCallback,
    required this.editingPage,
    this.category,
  });

  final Function pageCallback;
  final EditingPage editingPage;
  final Category? category;

  @override
  State<EditModeWidget> createState() => _EditModeWidgetState();
}

class _EditModeWidgetState extends State<EditModeWidget> {
  Widget _getButtonWidget(IconData labelIcon, EditWidget editWidget) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        height: 70,
        width: 70,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor:
                editWidget == EditWidget.contentEditor && AppManager.isEditMode
                    ? Colors.blue
                    : Colors.black,
            alignment: Alignment.center,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          onPressed: editWidget == EditWidget.contentEditor
              ? () {
                  setState(() {
                    AppManager.isEditMode = !AppManager.isEditMode;
                  });
                  widget.pageCallback();
                }
              : () {
                  _changeAppManagerState(editWidget);
                  widget.pageCallback();
                },
          child: Icon(labelIcon, size: 40),
        ),
      ),
    );
  }

  void _changeAppManagerState(EditWidget editWidget) async {
    if (editWidget == EditWidget.contentEditor) {
      return;
    } else if (editWidget == EditWidget.saveChanges) {
      Get.toNamed(Routes.getLoadingPageRoute());
      await AppManager.configService.updateConfigFile(widget.pageCallback);
      Get.toNamed(Routes.getConfigSelectPageRoute());
    } else {
      showDialog(
        context: context,
        builder: (context) {
          switch (editWidget) {
            case EditWidget.tableLayout:
              return const TableLayoutWidget();
            case EditWidget.fontEditor:
              return const FontEditorWidget();
            case EditWidget.colorEditor:
              return const ColorEditorWidget();
            case EditWidget.languageEditor:
              return const LanguageEditorWidget();
            case EditWidget.contentAmountEditor:
              return ContentAmountEditorWidget(
                category: widget.category,
                pageCallback: widget.pageCallback,
              );
            case EditWidget.contentEditor:
              break;
            case EditWidget.saveChanges:
              break;
          }
          throw ArgumentError('Argument Error');
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: 100,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue[200],
          border: const Border(
            right: BorderSide(
              color: Colors.black,
              width: 3.0,
            ),
          ),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Column(
                children: _getChildren(),
              ),
            ),
            widget.editingPage == EditingPage.main
                ? Positioned(
                  bottom: 0,
                  left: 14,
                  child: _getButtonWidget(
                      Icons.check_circle_outline_rounded,
                      EditWidget.saveChanges),
                )
                : Container(),
          ],
        ),
      ),
    );
  }

  List<Widget> _getChildren() {
    final List<Widget> widgets = [];

    switch (widget.editingPage) {
      case EditingPage.main:
        widgets.addAll(
          [
            _getButtonWidget(
                Icons.pivot_table_chart_rounded, EditWidget.tableLayout),
            _getButtonWidget(Icons.text_fields_sharp, EditWidget.fontEditor),
            _getButtonWidget(Icons.color_lens_rounded, EditWidget.colorEditor),
            _getButtonWidget(Icons.language_rounded, EditWidget.languageEditor),
            _getButtonWidget(
                Icons.add_to_photos_rounded, EditWidget.contentAmountEditor),
            _getButtonWidget(
                AppManager.isEditMode
                    ? Icons.edit_rounded
                    : Icons.edit_off_rounded,
                EditWidget.contentEditor),
          ],
        );
        break;
      case EditingPage.card:
        widgets.addAll(
          [
            _getButtonWidget(
                Icons.add_to_photos_rounded, EditWidget.contentAmountEditor),
            _getButtonWidget(
                AppManager.isEditMode
                    ? Icons.edit_rounded
                    : Icons.edit_off_rounded,
                EditWidget.contentEditor),
          ],
        );
        break;
    }

    return widgets;
  }
}
