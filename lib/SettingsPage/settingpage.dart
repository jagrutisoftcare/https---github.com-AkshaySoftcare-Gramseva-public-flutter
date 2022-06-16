import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tax_app/Home/LoginPage.dart';
import 'package:tax_app/SettingsPage/ContactUs.dart';
import 'package:tax_app/language/app_localization.dart';

import 'ChangePassword.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  late SharedPreferences preferences;
  var username1;
  var token1;
  var gpid1;
  var gpname1;

  read() async {
    preferences = await SharedPreferences.getInstance();
    username1 = preferences.getString('username');
    token1 = preferences.getString('token');
    gpid1 = preferences.getString('gpid');
    gpname1 = preferences.getString('gpname');
  }

  Future<void> secureScreen() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  @override
  void initState() {
    secureScreen();
    super.initState();
    read();
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    await FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffefe6f7),
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Color(0xff5f259e),
        title: Text(
          AppLocalization.of(context)!.translate('settings'),
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
        ),
      ),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.all(0.0),
        child: ListView(
          children: [
            SizedBox(
              height: 8,
            ),
            Container(
              color: Colors.white,
              child: ListTile(
                leading: Icon(
                  Icons.lock,
                  size: 20,
                ),
                title: Text(
                  AppLocalization.of(context)!.translate('changepassword'),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => ChangePassword()));
                },
              ),
            ),
            SizedBox(height: 8),
            Container(
              color: Colors.white,
              child: ListTile(
                leading: Icon(
                  CupertinoIcons.power,
                  size: 20,
                ),
                title: Text(
                  AppLocalization.of(context)!.translate('logout'),
                ),
                onTap: () {
                  _logout();
                },
              ),
            ),
            SizedBox(height: 8),
            Container(
              color: Colors.white,
              child: ListTile(
                leading: Icon(
                  CupertinoIcons.phone,
                  size: 20,
                ),
                title: Text(
                  AppLocalization.of(context)!.translate('contactus'),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => ContactUsPage()));
                },
              ),
            )
          ],
        ),
      )),
    );
  }

  //log out popup
  void _logout() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(AppLocalization.of(context)!.translate('logout'),
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff5f259e),
                )),
            elevation: 0,
            content: Text(
                AppLocalization.of(context)!
                    .translate('areyousureyouwanttologout'),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
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
                    preferences.clear();
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                  child: Text(AppLocalization.of(context)!.translate('yes'),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff5f259e),
                      ))),
            ],
          );
        });
  }
}
