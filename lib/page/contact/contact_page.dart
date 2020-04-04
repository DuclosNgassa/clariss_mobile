import 'package:clariss/form/contact_form.dart';
import 'package:clariss/global/global_color.dart';
import 'package:clariss/global/global_styling.dart';
import 'package:clariss/localization/app_localizations.dart';
import 'package:clariss/util/size_config.dart';
import 'package:flutter/material.dart';

class ContactPage extends StatefulWidget {
  @override
  _ContactPageState createState() => new _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    GlobalStyling().init(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('contact_us')),
        backgroundColor: GlobalColor.colorDeepPurple300,
      ),
      body: SafeArea(
        top: false,
        bottom: false,
        child: Padding(
          padding:
              EdgeInsets.symmetric(vertical: SizeConfig.blockSizeVertical * 5),
          child: CustomScrollView(
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildListDelegate(
                  [ContactForm(context)],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
