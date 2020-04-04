import 'package:clariss/util/size_config.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

class FaqPage extends StatefulWidget {
  @override
  _FaqPageState createState() => new _FaqPageState();
}

class _FaqPageState extends State<FaqPage> with TickerProviderStateMixin {
  final scaffoldKey = new GlobalKey<ScaffoldState>();

/*
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    GlobalStyling().init(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('how_it_works')),
        backgroundColor: GlobalColor.colorDeepPurple400,
      ),
      body: buildListTile(),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  Widget buildListTile() {
    return Column(
      children: <Widget>[
        Expanded(
          child: buildListFaq(),
        ),
        Divider(
          height: SizeConfig.blockSizeVertical * 2,
        ),
        Container(
          width: SizeConfig.screenWidth * 0.9,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: SizeConfig.blockSizeVertical * 2),
            child: CustomButton(
              fillColor: GlobalColor.colorDeepPurple400,
              splashColor: Colors.white,
              iconColor: Colors.white,
              text: AppLocalizations.of(context).translate('other_questions') +
                  ' ' +
                  AppLocalizations.of(context).translate('contact_us'),
              textStyle: GlobalStyling.styleButtonWhite,
              onPressed: () => showContactPage(),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildListFaq() {
    return ListView(
      children: <Widget>[
        ExpansionTile(
          title: Text(
            AppLocalizations.of(context).translate('faq1'),
            style: GlobalStyling.styleTitleBlack,
          ),
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 2),
              child: Text(
                AppLocalizations.of(context).translate('resp1'),
                style: GlobalStyling.styleNormalBlack,
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: Text(
            AppLocalizations.of(context).translate('faq2'),
            style: GlobalStyling.styleTitleBlack,
          ),
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 2),
              child: Text(
                AppLocalizations.of(context).translate('resp2'),
                style: GlobalStyling.styleNormalBlack,
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: Text(
            AppLocalizations.of(context).translate('faq3'),
            style: GlobalStyling.styleTitleBlack,
          ),
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 2),
              child: Text(
                AppLocalizations.of(context).translate('resp3'),
                style: GlobalStyling.styleNormalBlack,
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: Text(
            AppLocalizations.of(context).translate('faq4'),
            style: GlobalStyling.styleTitleBlack,
          ),
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 2),
              child: Text(
                AppLocalizations.of(context).translate('resp4'),
                style: GlobalStyling.styleNormalBlack,
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: Text(
            AppLocalizations.of(context).translate('faq5'),
            style: GlobalStyling.styleTitleBlack,
          ),
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 2),
              child: Text(
                AppLocalizations.of(context).translate('resp5'),
                style: GlobalStyling.styleNormalBlack,
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: Text(
            AppLocalizations.of(context).translate('faq6'),
            style: GlobalStyling.styleTitleBlack,
          ),
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 2),
              child: Text(
                AppLocalizations.of(context).translate('resp6'),
                style: GlobalStyling.styleNormalBlack,
              ),
            ),
          ],
        ),
      ],
    );
  }

  showContactPage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return ContactPage();
        },
      ),
    );
  }
*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Expandable Demo"),
      ),
      body: ExpandableTheme(
        data:
            const ExpandableThemeData(iconColor: Colors.blue, useInkWell: true),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: <Widget>[
            Card3(),
          ],
        ),
      ),
    );
  }
}

class Card3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return ExpandableNotifier(
      child: Padding(
        padding: const EdgeInsets.all(10),
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
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              width: SizeConfig.screenWidth,
                              height: SizeConfig.screenHeight * 0.25,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: AssetImage("assets/images/hair.jpg"),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  expanded: buildList(),
                ),
              ],
            ),
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
