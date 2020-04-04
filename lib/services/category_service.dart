import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:clariss/global/global_url.dart';
import 'package:clariss/localization/app_localizations.dart';
import 'package:clariss/services/sharedpreferences_service.dart';
import 'package:clariss/util/global.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../model/category.dart';
import '../model/category_tile.dart';

class CategoryService {
  SharedPreferenceService _sharedPreferenceService =
      new SharedPreferenceService();

  Future<List<Category>> fetchMockCategories() async {
    List<Category> _categoriesMock = new List();

    Category categoryHair = new Category();
    categoryHair.title = "Hair";
    categoryHair.id = 1;
    categoryHair.imageUrl = "assets/images/hair.jpg";

    Category categoryNails = new Category();
    categoryNails.title = "Nails";
    categoryNails.id = 2;
    categoryNails.imageUrl = "assets/images/nails.jpg";

    Category categoryHair1 = new Category();
    categoryHair1.title = "Hair1";
    categoryHair1.id = 3;
    categoryHair1.imageUrl = "assets/images/hair.jpg";

    Category categoryNails1 = new Category();
    categoryNails1.title = "Nails1";
    categoryNails1.id = 4;
    categoryNails1.imageUrl = "assets/images/nails.jpg";

    Category categoryHair2 = new Category();
    categoryHair2.title = "Hair2";
    categoryHair2.id = 5;
    categoryHair2.imageUrl = "assets/images/hair.jpg";

    Category categoryNails2 = new Category();
    categoryNails2.title = "Nails2";
    categoryNails2.id = 6;
    categoryNails2.imageUrl = "assets/images/nails.jpg";

    _categoriesMock
    ..add(categoryHair)
    ..add(categoryNails)
    ..add(categoryHair1)
    ..add(categoryNails1)
    ..add(categoryHair2)
    ..add(categoryNails2);

    return _categoriesMock;
  }

  Future<List<Category>> fetchCategories() async {
    String cacheTimeString =
        await _sharedPreferenceService.read(CATEGORIE_LIST_CACHE_TIME);

    if (cacheTimeString != null) {
      DateTime cacheTime = DateTime.parse(cacheTimeString);
      DateTime actualDateTime = DateTime.now();

      if (actualDateTime.difference(cacheTime) > Duration(days: 1)) {
        return fetchCategoriesFromServer();
      } else {
        return fetchCategoriesFromCache();
      }
    } else {
      return fetchCategoriesFromServer();
    }
  }

  Future<List<Category>> fetchCategoriesFromServer() async {
    final response = await http.Client().get(URL_CATEGORIES);
    if (response.statusCode == HttpStatus.ok) {
      Map<String, dynamic> mapResponse = json.decode(response.body);
      if (mapResponse["result"] == "ok") {
        final categories = mapResponse["data"].cast<Map<String, dynamic>>();
        final categorieList = await categories.map<Category>((json) {
          return Category.fromJson(json);
        }).toList();

        //Cache translated categories
        String jsonCategorie = jsonEncode(categorieList);
        _sharedPreferenceService.save(CATEGORIE_LIST, jsonCategorie);

        DateTime cacheTime = DateTime.now();
        _sharedPreferenceService.save(
            CATEGORIE_LIST_CACHE_TIME, cacheTime.toIso8601String());

        return categorieList;
      } else {
        return [];
      }
    } else {
      return fetchCategoriesFromCache();
    }
  }

  Future<List<Category>> fetchCategoriesFromCache() async {
    String listCategoryFromSharePrefs =
        await _sharedPreferenceService.read(CATEGORIE_LIST);
    if (listCategoryFromSharePrefs != null) {
      Iterable iterablePost = jsonDecode(listCategoryFromSharePrefs);
      final categorieList = await iterablePost.map<Category>((categorie) {
        return Category.fromJsonPref(categorie);
      }).toList();
      return categorieList;
    } else {
      return fetchCategoriesFromServer();
    }
  }

  Future<List<CategoryTile>> mapCategorieToCategorieTile(
      List<Category> categories) async {
    List<CategoryTile> categorieTiles = new List();
    List<Category> parentCategories = new List();

    for (var item in categories) {
      if (item.parentid == null) {
        parentCategories.add(item);
      }
    }

    for (var parent in parentCategories) {
      CategoryTile parentTile = new CategoryTile(parent.title, parent.id);
      parentTile.children = new List<CategoryTile>();
      parentTile.icon = parent.imageUrl;
      for (var child in categories) {
        if (child.parentid == parentTile.id) {
          CategoryTile childTile = new CategoryTile(child.title, child.id);
          childTile.parentid = parentTile.id;
          parentTile.children.add(childTile);
        }
      }

      parentTile.children
          .sort((child1, child2) => child1.title.compareTo(child2.title));

      categorieTiles.add(parentTile);
    }

    return categorieTiles;
  }

  Future<Category> fetchCategorieByID(int id) async {
    final response = await http.Client().get('$URL_CATEGORIES_BY_ID$id');
    if (response.statusCode == HttpStatus.ok) {
      final responseBody = await json.decode(response.body);
      return convertResponseToCategorie(responseBody);
    } else {
      throw Exception(
          'Failed to save a Categorie. Error: ${response.toString()}');
    }
  }

  Category convertResponseToCategorie(Map<String, dynamic> json) {
    if (json["data"] == null) {
      return null;
    }

    return Category(
      id: json["data"]["id"],
      title: json["data"]["title"],
      parentid: json["data"]["parentid"],
      imageUrl: json["data"]["icon"],
    );
  }

  Category translateCategory(Category categorie, BuildContext context) {
    Category translatedcategorie = categorie;
    translatedcategorie.title =
        AppLocalizations.of(context).translate(categorie.title);
    return translatedcategorie;
  }

  List<Category> translateCategories(
      List<Category> categories, BuildContext context) {
    List<Category> translatedcategories = new List();
    categories.forEach((categorie) =>
        translatedcategories.add(translateCategory(categorie, context)));

    return translatedcategories;
  }
}
