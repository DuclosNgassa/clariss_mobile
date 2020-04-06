import 'package:clariss/model/category.dart';
import 'package:clariss/model/category_wrapper.dart';
import 'package:clariss/services/category_service.dart';
import 'package:flutter/cupertino.dart';

class CategoryManager {
  BuildContext context;
  CategoryService _categorieService = new CategoryService();
  List<Category> _categoryList = new List();
  List<CategoryWrapper> _categoryWrapperList = new List();

  CategoryManager(this.context); // context required to translate categories later

  Stream<List<CategoryWrapper>> get categoryWrapperList async* {
    _categoryList = await _categorieService.fetchMockCategories();

    _categoryWrapperList = buildParentCategoriesMock(_categoryList);

    yield _categoryWrapperList;
  }

  List<CategoryWrapper> buildParentCategoriesMock(List<Category> categories) {
      for (var _parentCategorie in categories) {
        if (_parentCategorie.parentid == null) {
          CategoryWrapper _categoryWrapper = new CategoryWrapper();
          _categoryWrapper.parentCategory = _parentCategorie;
          for (Category childCategory in categories) {
            if (childCategory.parentid == _parentCategorie.id) {
              _categoryWrapper.childCategories.add(childCategory);
            }
          }
          _categoryWrapperList.add(_categoryWrapper);
        }
      }
      _categoryWrapperList
          .sort((a, b) => a.parentCategory.id.compareTo(b.parentCategory.id));
    return _categoryWrapperList;
  }
}
