import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tax_app/Activity/HeadActivity.dart';
import 'package:tax_app/Complaint/AddComplaint.dart';
import 'package:tax_app/E_Bill/E_BillPage.dart';
import 'package:tax_app/HouseTax/HouseTax.dart';
import 'package:tax_app/MobileRecharge/MobileRechargePage.dart';
import 'package:tax_app/Payment/PaymentHistory.dart';
import 'package:tax_app/SettingsPage/NotificatinPage.dart';
import 'package:tax_app/SettingsPage/settingpage.dart';
import 'package:tax_app/language/app_localization.dart';
import 'package:tax_app/language/current_data.dart';
import 'package:tax_app/language/default_data.dart';

//use dependency for firebase
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:package_info/package_info.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Future<void> secureScreen() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  static const PLAY_STORE_URL =
      'https://play.google.com/store/apps/details?id=com.gramseva.gramtax';

  late SharedPreferences preferences;
  // ignore: unused_field
  bool _center = true;
  // ignore: unused_field
  bool _text = false;
  var username1;
  var token1;
  var gpid1;
  var gpname1;
  List compiddatalist = [];

  read() async {
    preferences = await SharedPreferences.getInstance();
    username1 = preferences.getString('username');
    token1 = preferences.getString('token');
    gpid1 = preferences.getString('gpid');
    gpname1 = preferences.getString('gpname');
  }

  //get computer id list
  getCompIdList() async {
    preferences = await SharedPreferences.getInstance();
    username1 = preferences.getString('username');
    token1 = preferences.getString('token');
    gpid1 = preferences.getString('gpid');

    var response = await Dio().get('https://gramseva.in/api/customer/get_list',
        options: Options(headers: {"Authorization": "Bearer $token1"}));

    var compidlist = response.data['result'];

    return compidlist;
  }

  @override
  void initState() {
    secureScreen();
    read();
    try {
      versionCheck(context);
    } catch (e) {
      print(e);
    }
    _checkConnectivity();
    super.initState();
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    await FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
  }

  final DefaultData defaultData = DefaultData();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onbackpress(),
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Color(0xffefe6f7),
          appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 2,
            backgroundColor: Color(0xff5f259e),
            title: Text(
              AppLocalization.of(context)!.translate('gramseva'),
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
            ),
            actions: [
              /*  IconButton(
                  icon: Icon(CupertinoIcons.refresh),
                  onPressed: () {
                    // _checkConnectivity();
                    read();
                    this.getCompIdList().then((data) {
                      setState(() {
                        compiddatalist = data;

                        if (compiddatalist.length == 0) {
                          setState(() {
                            _center = false;
                            _text = true;
                          });
                        }
                      });
                    });
                  }),*/
              //change password option inside setting option

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Consumer<CurrentData>(
                    builder: (context, currentData, child) {
                      return Container(
                        width: 100,
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          color: const Color(0xff5f259e),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: DropdownButton<String>(
                          value: currentData.defineCurrentLanguage(context),
                          icon: const Icon(
                            Icons.arrow_downward,
                            color: Colors.white,
                          ),
                          iconSize: 20,
                          elevation: 0,
                          style: const TextStyle(color: Colors.white),
                          underline: Container(
                            height: 1,
                          ),
                          dropdownColor: const Color(0xff5f259e),
                          onChanged: (newValue) {
                            currentData.changeLocale(newValue!);
                          },
                          items: defaultData.languagesListDefault
                              .map<DropdownMenuItem<String>>(
                            (String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            },
                          ).toList(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NotificationPage()));
                  },
                  icon: Icon(Icons.notifications_active_outlined)),

              IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SettingPage()));
                  },
                  icon: Icon(Icons.settings)),
            ],
          ),
          body: SafeArea(
              child: Padding(
            padding: EdgeInsets.all(8.0),
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 4 / 5,
              children: [
                Card(
                  shadowColor: Color(0xff5f259e),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0)),
                  elevation: 2,
                  child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        HeadActivity()));
                          },
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Center(
                                  child: Icon(
                                    CupertinoIcons.tv,
                                    size: 50,
                                    color: Color(0xff5f259e),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Container(
                                    alignment: Alignment.bottomCenter,
                                    child: Text(
                                      AppLocalization.of(context)!
                                          .translate('undertaking'),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ))),
                ),
                Card(
                  shadowColor: Color(0xff5f259e),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0)),
                  elevation: 2,
                  child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HouseTaxPage()));
                          },
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Center(
                                  child: Icon(
                                    CupertinoIcons.home,
                                    size: 50,
                                    color: Color(0xff5f259e),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Container(
                                    alignment: Alignment.bottomCenter,
                                    child: Text(
                                      AppLocalization.of(context)!
                                          .translate('homestead'),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ))),
                ),
                Card(
                  shadowColor: Color(0xff5f259e),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0)),
                  elevation: 2,
                  child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        MobileRechargePage()));
                          },
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Center(
                                  child: Icon(
                                    Icons.phone_android_outlined,
                                    size: 50,
                                    color: Color(0xff5f259e),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Container(
                                    alignment: Alignment.bottomCenter,
                                    child: Text(
                                      AppLocalization.of(context)!
                                          .translate('mobilerecharge'),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ))),
                ),
                Card(
                  shadowColor: Color(0xff5f259e),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0)),
                  elevation: 2,
                  child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        EBillPage()));
                          },
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Center(
                                  child: Icon(
                                    CupertinoIcons.square_list,
                                    size: 50,
                                    color: Color(0xff5f259e),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Container(
                                    alignment: Alignment.bottomCenter,
                                    child: Text(
                                      AppLocalization.of(context)!
                                          .translate('electricitybill'),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ))),
                ),
                Card(
                  shadowColor: Color(0xff5f259e),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0)),
                  elevation: 2,
                  child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        AddComplaintPage()));
                          },
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Center(
                                  child: Icon(
                                    CupertinoIcons.doc,
                                    size: 50,
                                    color: Color(0xff5f259e),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Container(
                                    alignment: Alignment.bottomCenter,
                                    child: Text(
                                      AppLocalization.of(context)!
                                          .translate('complaintregistration'),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ))),
                ),
                Card(
                  shadowColor: Color(0xff5f259e),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0)),
                  elevation: 2,
                  child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        PaymentHistoryPage()));
                          },
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Center(
                                  child: Icon(
                                    Icons.payment_outlined,
                                    size: 50,
                                    color: Color(0xff5f259e),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Container(
                                    alignment: Alignment.bottomCenter,
                                    child: Text(
                                      AppLocalization.of(context)!
                                          .translate('paymentinformation'),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ))),
                ),
              ],
            ),
          ))),
    );
  }

  _onbackpress() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            elevation: 0,
            content: Text(
                AppLocalization.of(context)!
                    .translate('areyousureyouwanttoquit'),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff5f259e),
                )),
            actions: [
              // ignore: deprecated_member_use
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(AppLocalization.of(context)!.translate('no'),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff5f259e),
                      ))),
              // ignore: deprecated_member_use
              FlatButton(
                  onPressed: () {
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  },
                  child: Text(AppLocalization.of(context)!.translate('yes'),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff5f259e),
                      )))
            ],
          );
        });
  }

  // check version
  versionCheck(context) async {
    //Get Current installed version of app
    final PackageInfo info = await PackageInfo.fromPlatform();
    double currentVersion =
        double.parse(info.version.trim().replaceAll(".", ""));
    print(currentVersion);

    //Get Latest version info from firebase config
    final RemoteConfig remoteConfig = await RemoteConfig.instance;

    try {
      // Using default duration to force fetching from remote server.
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 0),
        minimumFetchInterval: Duration.zero,
      ));

      await remoteConfig.fetchAndActivate();
      remoteConfig.getString('force_update_current_version');
      print("fetch from firebase " +
          remoteConfig.getString('force_update_current_version'));
      double newVersion =
          double.parse(remoteConfig.getString('force_update_current_version'));
      print("currentversion");
      print(currentVersion);
      print("newversion");
      print(newVersion);
      if (newVersion > currentVersion) {
        _showVersionDialog(context);
      }
    } on PlatformException catch (exception) {
      // Fetch throttled.
      print(exception);
    } catch (exception) {
      print('Unable to fetch remote config. Cached or default values will be '
          'used');
    }
  }

  //show dialog box
  _showVersionDialog(context) async {
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String title =
            AppLocalization.of(context)!.translate('newupdateavailable');
        String message = AppLocalization.of(context)!
            .translate('thereisanewerversionofappavailablepleaseupdateitnow');
        String btnLabel = AppLocalization.of(context)!.translate('updatenow');
        String btnLabelCancel = AppLocalization.of(context)!.translate('later');
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text(btnLabel),
              onPressed: () => _launchURL(PLAY_STORE_URL),
            ),
            FlatButton(
              child: Text(btnLabelCancel),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
        // ignore: unnecessary_new
      },
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  //check internet
  _checkConnectivity() async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Color(0xff5f259e),
          content: Text(AppLocalization.of(context)!
              .translate('checkinternetconnectivity'))));
    }
  }
}
