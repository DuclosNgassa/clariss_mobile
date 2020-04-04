import 'package:clariss/global/global_styling.dart';
import 'package:clariss/model/category.dart';
import 'package:clariss/util/size_config.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CategoryCard extends StatefulWidget {
  final Category _category;

  CategoryCard(this._category);

  @override
  _CategoryCardState createState() => _CategoryCardState(_category);
}

class _CategoryCardState extends State<CategoryCard> {
  Category _category;
  String renderUrl;

  _CategoryCardState(this._category);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    GlobalStyling().init(context);

    return Stack(children: <Widget>[
      InkWell(
        onTap: null,
        child: _buildCategoryCard(),
      ),
    ]);
  }

  Widget _buildCategoryCard() {
    // A new container
    // The height and width are arbitrary numbers for styling.
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: SizeConfig.blockSizeHorizontal,
          vertical: SizeConfig.blockSizeVertical),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Stack(
            children: <Widget>[
              _buildCategoryImage(_category.imageUrl),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryImage(String imageUrl) {
    return ExpandableNotifier(
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
                  color: Colors.indigoAccent,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          width: SizeConfig.screenWidth,
                          height: SizeConfig.screenHeight * 0.25,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image: AssetImage(_category.imageUrl),
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
    );
  }

  buildItem(String label) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Text(label),
    );
  }

  buildList() {
    return Column(
      children: <Widget>[
        for (var i in [1, 2, 3, 4]) buildItem("Item ${i}"),
      ],
    );
  }

}
