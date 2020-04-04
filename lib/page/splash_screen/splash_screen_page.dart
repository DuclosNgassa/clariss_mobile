import 'dart:async';
import 'dart:io';

import 'package:clariss/custom_component/custom_linear_gradient.dart';
import 'package:clariss/global/global_styling.dart';
import 'package:clariss/localization/app_localizations.dart';
import 'package:clariss/page/navigation/navigation_page.dart';
import 'package:clariss/services/sharedpreferences_service.dart';
import 'package:clariss/util/global.dart';
import 'package:clariss/util/size_config.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SplashScreenPage extends StatefulWidget {
  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  SharedPreferenceService _sharedPreferenceService = new SharedPreferenceService();

  @override
  void initState() {
    super.initState();
    initPlatformState();
    _mockCheckForSession().then((status) {
      _navigateToHome();
    });
  }

  Future<bool> _mockCheckForSession() async {
    await Future.delayed(Duration(milliseconds: 5000), () {});

    return true;
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (BuildContext context) => NavigationPage(HOMEPAGE),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    GlobalStyling().init(context);

    return Scaffold(
      body: Container(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            CustomLinearGradient(
              myChild: new Container(),
            ),
            Positioned(
              top: SizeConfig.screenHeight * 0.20,
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.blockSizeHorizontal * 10),
                child: Text(
                  AppLocalizations.of(context)
                      .translate('clariss'),
                  style: TextStyle(
                      fontSize: SizeConfig.blockSizeHorizontal * 24,
                      fontFamily: 'Pacifico',
                      color: Colors.purpleAccent,
                      shadows: <Shadow>[
                        Shadow(
                            blurRadius: 18.0,
                            color: Colors.white,
                            offset: Offset.fromDirection(120, 12))
                      ]),
                ),
              ),
            ),
            Positioned(
              top: SizeConfig.screenHeight * 0.5,
              child: Shimmer.fromColors(
                period: Duration(milliseconds: 2000),
                baseColor: Colors.white,
                highlightColor: Colors.deepPurple,
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.blockSizeHorizontal * 10),
                  child: Text(
                    AppLocalizations.of(context)
                        .translate('splash_message1'),
                    style: TextStyle(
                        fontSize: SizeConfig.blockSizeHorizontal * 6,
                        fontFamily: 'Pacifico',
                        shadows: <Shadow>[
                          Shadow(
                              blurRadius: 18.0,
                              color: Colors.black87,
                              offset: Offset.fromDirection(120, 12))
                        ]),
                  ),
                ),
              ),
            ),
            Positioned(
              top: SizeConfig.screenHeight * 0.58,
              child: Shimmer.fromColors(
                period: Duration(milliseconds: 2000),
                baseColor: Colors.white,
                highlightColor: Colors.deepPurple,
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.blockSizeHorizontal * 10),
                  child: Text(
                    AppLocalizations.of(context).translate('splash_message2'),
                    style: TextStyle(
                        fontSize: SizeConfig.blockSizeHorizontal * 6,
                        fontFamily: 'Pacifico',
                        shadows: <Shadow>[
                          Shadow(
                            blurRadius: 18.0,
                            color: Colors.black87,
                            offset: Offset.fromDirection(120, 12),
                          ),
                        ]),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> initPlatformState() async {
    Map<String, dynamic> deviceData;

    try {
      if (Platform.isAndroid) {
        deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
        _sharedPreferenceService.save(DEVICE_ID, deviceData["id"]);
      } else if (Platform.isIOS) {
        deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
        _sharedPreferenceService.save(DEVICE_ID, deviceData["identifierForVendor"]);
      }
    } on Exception {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }

    if (!mounted) return;

  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'androidId': build.androidId,
      'systemFeatures': build.systemFeatures,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }
}
