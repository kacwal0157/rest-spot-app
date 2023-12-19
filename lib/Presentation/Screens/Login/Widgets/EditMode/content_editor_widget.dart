import 'package:aws_cognito_app/Presentation/Declarations/Constants/constant_enums.dart';
import 'package:aws_cognito_app/Presentation/Models/config_model.dart';
import 'package:aws_cognito_app/Presentation/Screens/Login/Widgets/EditMode/name_editor_widget.dart';
import 'package:aws_cognito_app/Presentation/Screens/Login/Widgets/EditMode/price_editor_widget.dart';
import 'package:aws_cognito_app/Presentation/Screens/Login/Widgets/image_functions_interface.dart';
import 'package:aws_cognito_app/Presentation/Screens/Login/Widgets/image_widget.dart';

import 'package:aws_cognito_app/Presentation/Services/config_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' as foundation;

import 'package:aws_cognito_app/Presentation/Screens/Login/Widgets/mobile_image_functions.dart';
import 'package:aws_cognito_app/Presentation/Screens/Login/Widgets/web_image_functions.dart';

class ContentEditorWidget extends StatefulWidget {
  const ContentEditorWidget(
      {super.key,
      required this.contentPage,
      required this.pageCallback,
      required this.imagePage,
      required this.configService,
      this.category,
      this.dish});

  final ConfigService configService;
  final ContentPage contentPage;
  final Function pageCallback;
  final ImagePage imagePage;
  final Category? category;
  final Dish? dish;

  @override
  State<ContentEditorWidget> createState() => _ContentEditorWidgetState();
}

class _ContentEditorWidgetState extends State<ContentEditorWidget> {
  _getPageContent(ContentPage contentPage) {
    switch (contentPage) {
      case ContentPage.main:
        return 'Główny napis';
      case ContentPage.category:
        return 'Kategoria';
      case ContentPage.dish:
        return 'Potrawa';
      case ContentPage.ingredient:
        return 'Składniki';
    }
  }

  Future<void> pickFileMobile() async {
    final source = await ImageWidgetFunctions().showImageSource(
        context, widget.imagePage, widget.category, widget.dish);
    if (source == null) return;

    ImageWidgetFunctions().pickImage(source, widget.pageCallback,
        widget.imagePage, widget.category, widget.dish, imageCache);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        height: 300,
        padding: const EdgeInsets.all(5.0),
        width: 350,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                child:
                    const Icon(Icons.add_photo_alternate_rounded, size: 100.0),
                onTap: () async {
                  ImageFunctionInterface imageFunction = foundation.kIsWeb
                      ? WebImageWidgetFunctions()
                      : MobileImageWidgetFunctions();

                  imageFunction.uploadImage(
                      context,
                      widget.pageCallback,
                      widget.imagePage,
                      widget.category,
                      widget.dish,
                      imageCache);
                },
              ),
              const SizedBox(height: 50.0),
              NameEditorWidget(
                  contentPage: widget.contentPage,
                  pageContent: _getPageContent(widget.contentPage),
                  category: widget.category,
                  dish: widget.dish),
              widget.contentPage == ContentPage.dish
                  ? NameEditorWidget(
                      contentPage: ContentPage.ingredient,
                      pageContent: _getPageContent(ContentPage.ingredient),
                      category: widget.category,
                      dish: widget.dish)
                  : Container(),
              widget.dish != null
                  ? PriceEditorWidget(
                      text: widget.dish!.price.toStringAsFixed(2),
                      categoryID: widget.category!.id,
                      dishID: widget.dish!.id,
                      currency: widget.dish!.currency,
                      pageCallback: widget.pageCallback)
                  : Container(),
            ],
          ),
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
    );
  }
}
