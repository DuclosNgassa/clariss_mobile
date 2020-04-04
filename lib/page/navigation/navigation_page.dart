import 'package:clariss/custom_component/custom_shape_clipper.dart';
import 'package:clariss/global/global_color.dart';
import 'package:clariss/global/global_styling.dart';
import 'package:clariss/localization/app_localizations.dart';
import 'package:clariss/page/help/info_page.dart';
import 'package:clariss/page/home/home_page.dart';
import 'package:clariss/util/size_config.dart';
import 'package:flutter/material.dart';

class NavigationPage extends StatefulWidget {
  int _selectedIndex = 0;

  NavigationPage(this._selectedIndex);

  @override
  _NavigationPageState createState() => new _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  bool showPictures = false;
  static bool isLogedIn = false;

  int _localSelectedIndex = 0;
  String userEmail;

  @override
  void initState() {
    _localSelectedIndex = widget._selectedIndex;
    if (_localSelectedIndex > 0) {
      isLogedIn = true;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    GlobalStyling().init(context);

    return new Scaffold(
      //backgroundColor: Colors.purple,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  ClipPath(
                    clipper: CustomShapeClipper(),
                    child: Container(
                      height: SizeConfig.screenHeight / 4,
                      decoration: BoxDecoration(
                        gradient: new LinearGradient(
                          colors: [
                            Colors.purpleAccent,
                            Colors.purpleAccent,
                          ],
                          begin: const FractionalOffset(1.0, 1.0),
                          end: const FractionalOffset(0.2, 0.2),
                          stops: [0.0, 1.0],
                          tileMode: TileMode.clamp,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin:
                        EdgeInsets.only(top: SizeConfig.safeBlockVertical * 7),
                    constraints: BoxConstraints.expand(
                        height: SizeConfig.safeBlockVertical * 90),
                    child: _widgetOptions.elementAt(_localSelectedIndex),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text(
                AppLocalizations.of(context).translate('home')), //Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            title: Text(AppLocalizations.of(context).translate('my_favorits')),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            title: Text(AppLocalizations.of(context).translate('my_booking')),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            title: Text(AppLocalizations.of(context).translate('account')),
          ),
        ],
        type: BottomNavigationBarType.fixed,
        currentIndex: _localSelectedIndex,
        selectedItemColor: GlobalColor.colorDeepPurple400,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }

  Future onSelectNotification(String payload) {
    debugPrint("payload : $payload");
    showDialog(
      context: context,
      builder: (_) => new AlertDialog(
        title: new Text('Notification'),
        content: new Text('$payload'),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _localSelectedIndex = index;
    });
  }

  List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    InfoPage(),
    InfoPage(),
    InfoPage(),
  ];
}
