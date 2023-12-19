import 'package:aws_cognito_app/Presentation/Models/config_model.dart';
import 'package:aws_cognito_app/Presentation/Services/layout_service.dart';

class CategoryData {
  final Category category;
  final LayoutService layoutService;

  CategoryData(this.category, this.layoutService);
}
