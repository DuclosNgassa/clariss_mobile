import 'package:clariss/global/global_styling.dart';
import 'package:clariss/model/category.dart';
import 'package:clariss/model/category_wrapper.dart';
import 'package:clariss/util/size_config.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CategoryCard extends StatefulWidget {
  final CategoryWrapper _categoryWrapper;

  CategoryCard(this._categoryWrapper);

  @override
  _CategoryCardState createState() => _CategoryCardState(_categoryWrapper);
}

class _CategoryCardState extends State<CategoryCard> {
  CategoryWrapper _categoryWrapper;
  String renderUrl;

  _CategoryCardState(this._categoryWrapper);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    GlobalStyling().init(context);

    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: SizeConfig.blockSizeHorizontal,
          vertical: SizeConfig.blockSizeVertical),
      child: _buildCategoryCard(),
    );
  }

  Widget _buildCategoryCard() {
    return Stack(
      children: <Widget>[
        Positioned(
          child: ExpandableNotifier(
            child: ScrollOnExpand(
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: <Widget>[
                    ExpandablePanel(
                      theme: const ExpandableThemeData(
                        headerAlignment: ExpandablePanelHeaderAlignment.center,
                        tapBodyToExpand: true,
                        tapBodyToCollapse: true,
                        hasIcon: false,
                      ),
                      header: Container(
                        color: Colors.transparent,
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                width: SizeConfig.screenWidth,
                                height: SizeConfig.screenHeight * 0.25,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: AssetImage(_categoryWrapper
                                        .parentCategory.imageUrl),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      expanded: buildList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: SizeConfig.screenHeight * 0.125,
          right: SizeConfig.blockSizeHorizontal * 10,
          child: Text(
            _categoryWrapper.parentCategory.title,
            style: GlobalStyling.styleTitleWhite,
          ),
        )
      ],
    );
  }

  buildItem(String label) {
    return Padding(
      padding: EdgeInsets.only(
          left: SizeConfig.blockSizeHorizontal * 2),
      child: ListTile(
        title: Text(label),
      ),
    );
  }

  buildList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        for (Category childCategory in _categoryWrapper.childCategories)
          buildItem(childCategory.title),
      ],
    );
  }
}
