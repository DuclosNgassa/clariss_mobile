import 'package:clariss/global/global_styling.dart';
import 'package:clariss/model/category.dart';
import 'package:clariss/model/category_wrapper.dart';
import 'package:clariss/util/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'category_card.dart';

class CategoryCardComponentPage extends StatefulWidget {
  final List<CategoryWrapper> categoryList;

  CategoryCardComponentPage({this.categoryList});

  @override
  CategoryCardComponentState createState() => CategoryCardComponentState();
}

class CategoryCardComponentState extends State<CategoryCardComponentPage> {
  List<CategoryWrapper> categoryListItems = new List();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    GlobalStyling().init(context);

    return buildCategoryListView();
  }

  Widget buildCategoryListView() {
    return ListView.builder(
        itemCount: widget.categoryList.length,
        // Important code
        itemBuilder: (context, index) {
          return CategoryCard(widget.categoryList.elementAt(index));
        });
  }
}
