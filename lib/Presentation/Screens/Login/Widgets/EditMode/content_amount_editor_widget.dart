import 'package:aws_cognito_app/Presentation/Declarations/Constants/constant_functions.dart';
import 'package:aws_cognito_app/Presentation/Models/config_model.dart';
import 'package:aws_cognito_app/app_manager.dart';
import 'package:flutter/material.dart';

class ContentAmountEditorWidget extends StatefulWidget {
  const ContentAmountEditorWidget(
      {super.key, required this.category, required this.pageCallback});

  final Category? category;
  final Function pageCallback;

  @override
  State<ContentAmountEditorWidget> createState() =>
      _ContentAmountEditorWidgetState();
}

class _ContentAmountEditorWidgetState extends State<ContentAmountEditorWidget> {
  int contentCount = 0;
  List<Category> categories = AppManager.config.categories;

  @override
  void initState() {
    super.initState();
    contentCount = _getContent();
  }

  @override
  Widget build(BuildContext context) {
    var currentRoute =
        AppManager.currentRoute == '/main' ? 'Strona główna' : 'Okno kategorii';

    return AlertDialog(
      title: const Text('Edytor zawartości'),
      actions: [
        TextButton(
          child: const Text('Zrobione'),
          onPressed: () {
            AppManager.configService.editContentAmount(categories);
            Navigator.of(context).pop();
          },
        ),
      ],
      content: SizedBox(
        height: 150,
        width: 100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Obecna strona: $currentRoute'),
            Text('Ilość kategorii na stronie: $contentCount \n'),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _updateContent(true);
                    });
                  },
                  child: const Icon(Icons.add),
                ),
                const SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (contentCount > 0) {
                        contentCount--;
                      }

                      _updateContent(false);
                    });
                  },
                  child: const Icon(Icons.remove),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _getContent() {
    switch (AppManager.currentRoute) {
      case '/main':
        return categories.length;
      case '/card':
        return categories
            .firstWhere((element) => element.id == widget.category!.id)
            .dishes
            .length;
      default:
        return 0;
    }
  }

  _updateContent(bool isAdding) {
    var content = contentCount;

    switch (AppManager.currentRoute) {
      case '/main':
        if (isAdding) {
          var rows = AppManager.config.categoryLayout['numberInRow']! + 1;
          var cols = AppManager.config.categoryLayout['numberInCol']! + 1;

          if (categories.length + 1 <= rows * cols) {
            categories.add(getEmptyCategory());
            content++;
          } else {
            showDialog(
                context: context,
                builder: (context) => _getErrorMessage(context,
                    "Maksymalna ilość kategorii osiągnięta.\n\nAby dodać nowe kategorie, zwiększ ilość kolumn lub rzędów w narzędziu edycyjnym 'Edytor układu'"));
          }
        } else {
          if (categories.length - 1 >= 0) {
            categories.removeLast();
          } else {
            showDialog(
                context: context,
                builder: (context) => _getErrorMessage(
                    context, "Minimalna ilość kategorii osiągnięta."));
          }
        }
        break;
      case '/card':
        final category = categories
            .firstWhere((element) => element.id == widget.category!.id);

        if (isAdding) {
          category.dishes.add(getEmptyDish());
          content++;
        } else {
          if (category.dishes.length - 1 >= 0) {
            category.dishes.removeLast();
          } else {
            showDialog(
                context: context,
                builder: (context) => _getErrorMessage(
                    context, "Minimalna ilość dań osiągnięta."));
          }
        }
        break;
    }

    setState(() {
      contentCount = content;
    });

    widget.pageCallback();
  }
}

_getErrorMessage(BuildContext context, String error) {
  return AlertDialog(
    title: const Text('Błąd!'),
    actions: [
      TextButton(
        child: const Text('Rozumiem'),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    ],
    content: SizedBox(
      height: 100,
      width: 300,
      child: Text(error),
    ),
  );
}
