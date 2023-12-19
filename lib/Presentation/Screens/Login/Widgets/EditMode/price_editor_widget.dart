import 'package:aws_cognito_app/app_manager.dart';
import 'package:flutter/material.dart';

class PriceEditorWidget extends StatefulWidget {
  final String text;
  final String categoryID;
  final String dishID;
  final String currency;
  final Function pageCallback;

  const PriceEditorWidget(
      {super.key,
      required this.text,
      required this.categoryID,
      required this.dishID,
      required this.currency,
      required this.pageCallback});

  @override
  State<PriceEditorWidget> createState() => _PriceEditorWidgetState();
}

class _PriceEditorWidgetState extends State<PriceEditorWidget> {
  late TextEditingController _textEditingController;
  String _errorMessage = '';
  bool _error = false;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController(text: widget.text);
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  void _resetEditMode() {
    setState(() {
      _errorMessage = '';
      _error = false;
    });
  }

  void _saveChanges() {
    String updatedText = _textEditingController.text;

    if (_validateInput(updatedText)) {
      _resetEditMode();

      double newPrice = double.parse(updatedText);
      String price = newPrice.toStringAsFixed(2);

      AppManager.configService
          .editDishPrice(widget.categoryID, widget.dishID, double.parse(price));
      widget.pageCallback();
    } else {
      AppManager.configService
          .editDishPrice(widget.categoryID, widget.dishID, 0.00);
      widget.pageCallback();
    }
  }

  bool _validateInput(String text) {
    if (text.isEmpty) {
      setState(() {
        _errorMessage = 'Wprowadź wartość';
        _error = true;
      });
      return false;
    }

    try {
      double.parse(text);
    } catch (e) {
      setState(() {
        _errorMessage = 'Wprowadź prawidłową liczbę';
        _error = true;
      });
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
        controller: _textEditingController,
        autofocus: false,
        decoration: InputDecoration(
            border: const UnderlineInputBorder(),
            errorText: _error ? _errorMessage : null,
            focusColor: Colors.white,
            label: const Text('Cena')),
        style: const TextStyle(
          color: Colors.black,
        ),
        onChanged: (value) {
          _saveChanges();
        });
  }
}
