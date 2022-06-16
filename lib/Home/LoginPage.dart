import 'dart:convert';

import 'package:connectivity/connectivity.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tax_app/language/app_localization.dart';
import 'Dashboard.dart';
import 'RegPage.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  Future<void> secureScreen() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  final _formkey1 = GlobalKey<FormState>();

  bool _obsuretext = true;
  void _toggle() {
    setState(() {
      _obsuretext = !_obsuretext;
    });
  }

  late final SharedPreferences preferences;
  TextEditingController txtusername = new TextEditingController();
  TextEditingController txtpassword = new TextEditingController();
  TextEditingController txtgranttype = new TextEditingController();

  _saveusername(username, token, gpid, gpname) async {
    preferences = await SharedPreferences.getInstance();
    final keyusername = 'username';
    final username1 = username;
    preferences.setString(keyusername, username1);

    final keytoken = 'token';
    final token1 = token;
    preferences.setString(keytoken, token1);

    final keygpid = 'gpid';
    final gpid1 = gpid;
    preferences.setString(keygpid, gpid1);

    final keygpname = 'gpname';
    final gpname1 = gpname;
    preferences.setString(keygpname, gpname1);
  }

  bool lbtn = true;
  @override
  void initState() {
    secureScreen();
    super.initState();
    _checkConnectivity();
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    await FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => _onbackpress(),
        child: Scaffold(
            bottomNavigationBar: Padding(
              padding: EdgeInsets.all(18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocalization.of(context)!.translate('newusers'),
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => RegPage()));
                    },
                    child: Text(
                      AppLocalization.of(context)!.translate('register'),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff5f259e),
                      ),
                    ),
                  )
                ],
              ),
            ),
            backgroundColor: Colors.white,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              elevation: 2,
              backgroundColor: Color(0xff5f259e),
              title: Text(
                AppLocalization.of(context)!.translate('login'),
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
              ),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Form(
                  key: _formkey1,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 20,
                        ),
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          shadowColor: Color(0xff5f259e),
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 15,
                                ),
                                TextFormField(
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(10)
                                  ],
                                  validator: (mobilevalue) {
                                    if (mobilevalue!.isEmpty) {
                                      return AppLocalization.of(context)!
                                          .translate('voicenumberrequired');
                                    } else if (mobilevalue.length < 10)
                                      return AppLocalization.of(context)!
                                          .translate(
                                              'enterthecorrectsoundnumber');
                                    else
                                      return null;
                                  },
                                  controller: txtusername,
                                  cursorColor: Color(0xff5f259e),
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        borderSide: BorderSide(
                                          width: 1,
                                          color: Color(0xff5f259e),
                                        )),
                                    prefixIcon: Icon(
                                      CupertinoIcons.phone,
                                      color: Color(0xff5f259e),
                                      size: 20,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4)),
                                        borderSide: BorderSide(
                                          width: 1,
                                          color: Color(0xff5f259e),
                                        )),
                                    labelText: AppLocalization.of(context)!
                                        .translate('voicenumber'),
                                    labelStyle: TextStyle(
                                      fontSize: 13,
                                      color: Color(0xff5f259e),
                                    ),
                                  ),
                                  keyboardType: TextInputType.phone,
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                TextFormField(
                                    validator: (value) {
                                      if (value!.trim().isEmpty) {
                                        return AppLocalization.of(context)!
                                            .translate('passwordrequired');
                                      } else
                                        return null;
                                    },
                                    obscureText: _obsuretext,
                                    controller: txtpassword,
                                    cursorColor: Color(0xff5f259e),
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          borderSide: BorderSide(
                                            width: 1,
                                            color: Color(0xff5f259e),
                                          )),
                                      prefixIcon: Icon(
                                        Icons.lock_outline,
                                        color: Color(0xff5f259e),
                                        size: 20,
                                      ),
                                      suffixIcon: IconButton(
                                          iconSize: 20,
                                          icon: _obsuretext
                                              ? Icon(Icons.visibility_off,
                                                  color: Color(0xff5f259e))
                                              : Icon(Icons.visibility,
                                                  color: Color(0xff5f259e)),
                                          onPressed: _toggle),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4)),
                                          borderSide: BorderSide(
                                            width: 1,
                                            color: Color(0xff5f259e),
                                          )),
                                      labelText: AppLocalization.of(context)!
                                          .translate('password'),
                                      labelStyle: TextStyle(
                                        fontSize: 13,
                                        color: Color(0xff5f259e),
                                      ),
                                    ),
                                    keyboardType: TextInputType.text),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  height: 60,
                                  width: double.infinity,
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                    ),
                                    onPressed: () {
                                      if (_formkey1.currentState!.validate()) {
                                        String userName =
                                            txtusername.text.toString();

                                        String password =
                                            txtpassword.text.toString();
                                        showDialog(
                                            barrierColor: Colors.transparent,
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (BuildContext context) {
                                              Future.delayed(
                                                  Duration(seconds: 0),
                                                  () async {
                                                var data = {
                                                  "contact": userName,
                                                  "password": password,
                                                };

                                                //write api code here
                                                var insurl =
                                                    'https://gramseva.in/api/customer/login';

                                                var response = await http.post(
                                                    Uri.parse(insurl),
                                                    body: data);

                                                var sts = json.decode(
                                                    response.body)['status'];

                                                if (sts == true) {
                                                  var token = json.decode(
                                                          response.body)['data']
                                                      ['accessToken'];

                                                  var gpid = json.decode(
                                                          response.body)['data']
                                                      ['gp_id'];
                                                  var gpname = json.decode(
                                                          response.body)['data']
                                                      ['gp_name'];
                                                  _saveusername(userName, token,
                                                      gpid, gpname);

                                                  Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              DashboardPage()));
                                                } else if (sts == false) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                          backgroundColor:
                                                              Color(0xff5f259e),
                                                          content: Text(
                                                            AppLocalization.of(
                                                                    context)!
                                                                .translate(
                                                                    'userisinvalid'),
                                                          )));
                                                  Navigator.pop(context);
                                                }
                                              });
                                              return Center(
                                                  child: Theme(
                                                data: Theme.of(context)
                                                    .copyWith(
                                                        accentColor:
                                                            Color(0xff5f259e)),
                                                child:
                                                    CircularProgressIndicator(
                                                  color: Color(0xff5f259e),
                                                ),
                                              ));
                                            });
                                      }
                                    },
                                    child: Ink(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          color: Color(0xff5f259e)),
                                      child: Container(
                                        alignment: Alignment.center,
                                        constraints: BoxConstraints(
                                            maxWidth: double.infinity,
                                            minHeight: 50),
                                        child: Text(
                                          AppLocalization.of(context)!
                                              .translate('login'),
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )));
  }

  // check connectivity
  _checkConnectivity() async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Color(0xff5f259e),
          content: Text(
            AppLocalization.of(context)!.translate('checkinternetconnectivity'),
          )));
    }
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
}
