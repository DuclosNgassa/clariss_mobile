
import 'category.dart';

class CategoryWrapper {
  Category parentCategory;
  List<Category> childCategories;

  CategoryWrapper(){
    childCategories = new List();
  }
}
