import 'dart:async';

import 'package:clariss/bloc/category_manager.dart';
import 'package:clariss/custom_component/categories_card_component.dart';
import 'package:clariss/global/global_color.dart';
import 'package:clariss/global/global_styling.dart';
import 'package:clariss/localization/app_localizations.dart';
import 'package:clariss/model/category.dart';
import 'package:clariss/model/category_wrapper.dart';
import 'package:clariss/util/notification.dart';
import 'package:clariss/util/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final globalKey = new GlobalKey<ScaffoldState>();
  GlobalKey<RefreshIndicatorState> refreshKey;

  String _searchLabel;

  List<Category> categories = new List();

  List<Category> parentCategories = new List();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    GlobalStyling().init(context);

    _searchLabel = AppLocalizations.of(context).translate('search');

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        height: SizeConfig.screenHeight,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: SizeConfig.blockSizeVertical,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: SizeConfig.blockSizeHorizontal * 4,
                  ),
                  Expanded(
                    child: _buildSearchInput(),
                  ),
                  SizedBox(
                    width: SizeConfig.blockSizeHorizontal * 2,
                  ),
                  buildSearchButton(),
                  SizedBox(
                    width: SizeConfig.blockSizeHorizontal * 4,
                  ),
                ],
              ),
              Container(
                  height: SizeConfig.screenHeight * 0.74,
                  child: _buildCategoryListCard()),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: SizeConfig.blockSizeVertical),
        child: FloatingActionButton(
          backgroundColor: Colors.purpleAccent,
          onPressed: () => _changeShowPictures(),
          tooltip: 'Booking',
          child: Icon(
            Icons.calendar_today,
            size: SizeConfig.safeBlockHorizontal * 10,
          ),
        ),
      ),
    );
  }

  Container buildSearchButton() {
    return Container(
      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
      child: IconButton(
        icon: Icon(
          Icons.search,
          color: GlobalColor.colorDeepPurple400,
        ),
        iconSize: SizeConfig.blockSizeHorizontal * 11,
        tooltip: AppLocalizations.of(context).translate('to_search'),
        onPressed: _openSearchPage,
      ),
    );
  }

  Widget _buildCategoryListCard() {
    CategoryManager _categoryManager = CategoryManager(context);

    return RefreshIndicator(
      key: refreshKey,
      onRefresh: () async {
        await _invalidatePostCache();
      },
      child: StreamBuilder<List<CategoryWrapper>>(
        stream: _categoryManager.categoryWrapperList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length > 0) {
              return Container(
                padding: EdgeInsets.only(
                  top: SizeConfig.blockSizeVertical * 2,
                  left: SizeConfig.blockSizeHorizontal * 2,
                  right: SizeConfig.blockSizeHorizontal * 2,
                ),
                child: CategoryCardComponentPage(
                  categoryList: snapshot.data,
                ),
              );
            } else {
              return new Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.blockSizeHorizontal * 3,
                    vertical: SizeConfig.blockSizeVertical * 2,
                  ),
                  child: Text(
                    AppLocalizations.of(context).translate('no_post_found'),
                  ),
                ),
              );
            }
          } else if (snapshot.hasError) {
            MyNotification.showInfoFlushbar(
                context,
                AppLocalizations.of(context).translate('error'),
                AppLocalizations.of(context).translate('error_loading'),
                Icon(
                  Icons.info_outline,
                  size: 28,
                  color: Colors.redAccent,
                ),
                Colors.redAccent,
                3);
          }
          return new CupertinoActivityIndicator(
            radius: SizeConfig.safeBlockHorizontal * 5,
          );
        },
      ),
    );
  }

  Widget _buildSearchInput() {
    return Container(
      decoration: BoxDecoration(
          color: GlobalColor.colorWhite,
          borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 2),
        child: TextFormField(
          onTap: () => _openSearchPage(),
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.grey.withOpacity(.8)),
            hintText: AppLocalizations.of(context).translate("search"),
          ),
        ),
      ),
    );
  }

  _openSearchPage() {
    //TODO implements me
  }

  _changeShowPictures() async {
    setState(() {});
  }

  Future<void> _invalidatePostCache() async {
    //TODO implememts me
    setState(() {});
  }
}
