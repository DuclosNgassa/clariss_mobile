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

    Category categoryCoiffure = new Category();
    categoryCoiffure.title = "Coiffure";
    categoryCoiffure.id = 1;
    categoryCoiffure.imageUrl = "assets/images/hair.jpg";

    Category categoryCoiffureHomme = new Category();
    categoryCoiffureHomme.title = "Coiffure Homme";
    categoryCoiffureHomme.id = 11;
    categoryCoiffureHomme.parentid = 1;

    Category categoryCoiffureFemme = new Category();
    categoryCoiffureFemme.title = "Coiffure Femme";
    categoryCoiffureFemme.id = 12;
    categoryCoiffureFemme.parentid = 1;

    Category categoryCoiffureTeintureHomme = new Category();
    categoryCoiffureTeintureHomme.title = "Teinture Homme";
    categoryCoiffureTeintureHomme.id = 13;
    categoryCoiffureTeintureHomme.parentid = 1;

    Category categoryCoiffureTeintureFemme = new Category();
    categoryCoiffureTeintureFemme.title = "Teinture femme";
    categoryCoiffureTeintureFemme.id = 14;
    categoryCoiffureTeintureFemme.parentid = 1;

    Category categoryCoiffureToutSoins = new Category();
    categoryCoiffureToutSoins.title = "Tous les soins";
    categoryCoiffureToutSoins.id = 15;
    categoryCoiffureToutSoins.parentid = 1;

    Category categoryManicure = new Category();
    categoryManicure.title = "Manicure / Pedicure";
    categoryManicure.id = 2;
    categoryManicure.imageUrl = "assets/images/nails.jpg";

    Category categoryCosmetque = new Category();
    categoryCosmetque.title = "Cosmetique";
    categoryCosmetque.id = 3;
    categoryCosmetque.imageUrl = "assets/images/cosmetique.jpg";

    Category categoryMassage = new Category();
    categoryMassage.title = "Massage";
    categoryMassage.id = 4;
    categoryMassage.imageUrl = "assets/images/massage.jpg";

    Category categoryWellness = new Category();
    categoryWellness.title = "Bien-être";
    categoryWellness.id = 5;
    categoryWellness.imageUrl = "assets/images/wellness.jpg";

    Category categoryFitness = new Category();
    categoryFitness.title = "Fitness";
    categoryFitness.id = 6;
    categoryFitness.imageUrl = "assets/images/fitness.jpg";

    _categoriesMock
      ..add(categoryCoiffure)
      ..add(categoryCoiffureFemme)
      ..add(categoryCoiffureHomme)
      ..add(categoryCoiffureTeintureHomme)
      ..add(categoryCoiffureTeintureFemme)
      ..add(categoryCoiffureToutSoins)
      ..add(categoryManicure)
      ..add(categoryCosmetque)
      ..add(categoryMassage)
      ..add(categoryWellness)
      ..add(categoryFitness);

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
