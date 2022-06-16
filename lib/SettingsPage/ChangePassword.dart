import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tax_app/Home/LoginPage.dart';
import 'package:tax_app/language/app_localization.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formkey5 = GlobalKey<FormState>();

  late final SharedPreferences preferences;

  TextEditingController oldpswdController = TextEditingController();
  TextEditingController newpswd1Controller = TextEditingController();
  TextEditingController newpswd2Controller = TextEditingController();

  bool _obsuretext1 = true;
  void _toggle1() {
    setState(() {
      _obsuretext1 = !_obsuretext1;
    });
  }

  bool _obsuretext2 = true;
  void _toggle2() {
    setState(() {
      _obsuretext2 = !_obsuretext2;
    });
  }

  bool _obsuretext3 = true;
  void _toggle3() {
    setState(() {
      _obsuretext3 = !_obsuretext3;
    });
  }

  var username1;
  var token2;
  read() async {
    preferences = await SharedPreferences.getInstance();
    username1 = preferences.getString('username');
    token2 = preferences.getString('token');
  }

  Future<void> secureScreen() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  @override
  void initState() {
    secureScreen();
    _checkConnectivity();
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
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Color(0xff5f259e),
        title: Text(
          AppLocalization.of(context)!.translate('changepassword'),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formkey5,
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
                              obscureText: _obsuretext1,
                              keyboardType: TextInputType.text,
                              cursorColor: Color(0xff5f259e),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Color(0xff5f259e),
                                    )),
                                suffixIcon: IconButton(
                                    iconSize: 20,
                                    icon: _obsuretext1
                                        ? Icon(Icons.visibility_off,
                                            color: Color(0xff5f259e)
                                                .withOpacity(0.8))
                                        : Icon(Icons.visibility,
                                            color: Color(0xff5f259e)
                                                .withOpacity(0.8)),
                                    onPressed: _toggle1),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Color(0xff5f259e),
                                    )),
                                labelText: AppLocalization.of(context)!
                                    .translate('previouspassword'),
                                labelStyle: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xff5f259e),
                                ),
                              ),
                              controller: oldpswdController,
                              validator: (val) {
                                if (val!.trim().isEmpty)
                                  return AppLocalization.of(context)!
                                      .translate('passwordrequired');
                                else if (val.length < 8)
                                  return AppLocalization.of(context)!.translate(
                                      'passwordmustbenolessthancharacters');
                                return null;
                              }),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                              obscureText: _obsuretext2,
                              keyboardType: TextInputType.text,
                              cursorColor: Color(0xff5f259e),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Color(0xff5f259e),
                                    )),
                                suffixIcon: IconButton(
                                    iconSize: 20,
                                    icon: _obsuretext2
                                        ? Icon(Icons.visibility_off,
                                            color: Color(0xff5f259e)
                                                .withOpacity(0.8))
                                        : Icon(Icons.visibility,
                                            color: Color(0xff5f259e)
                                                .withOpacity(0.8)),
                                    onPressed: _toggle2),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Color(0xff5f259e),
                                    )),
                                labelText: AppLocalization.of(context)!
                                    .translate('newpassword'),
                                labelStyle: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xff5f259e),
                                ),
                              ),
                              controller: newpswd1Controller,
                              validator: (val) {
                                if (val!.trim().isEmpty)
                                  return AppLocalization.of(context)!
                                      .translate('passwordrequired');
                                else if (val.length < 8)
                                  return AppLocalization.of(context)!.translate(
                                      'passwordmustbenolessthancharacters');
                                return null;
                              }),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                              obscureText: _obsuretext3,
                              keyboardType: TextInputType.text,
                              cursorColor: Color(0xff5f259e),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Color(0xff5f259e),
                                    )),
                                suffixIcon: IconButton(
                                    iconSize: 20,
                                    icon: _obsuretext3
                                        ? Icon(Icons.visibility_off,
                                            color: Color(0xff5f259e)
                                                .withOpacity(0.8))
                                        : Icon(Icons.visibility,
                                            color: Color(0xff5f259e)
                                                .withOpacity(0.8)),
                                    onPressed: _toggle3),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Color(0xff5f259e),
                                    )),
                                labelText: AppLocalization.of(context)!
                                    .translate('propernewpassword'),
                                labelStyle: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xff5f259e),
                                ),
                              ),
                              controller: newpswd2Controller,
                              validator: (val) {
                                if (val!.trim().isEmpty)
                                  return AppLocalization.of(context)!
                                      .translate('passwordrequired');
                                else if (val.length < 8)
                                  return AppLocalization.of(context)!.translate(
                                      'passwordmustbenolessthancharacters');
                                return null;
                              }),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // ignore: deprecated_member_use
                              FlatButton(
                                color: Color(0xff5f259e),
                                textColor: Colors.white,
                                padding: EdgeInsets.all(8.0),
                                splashColor: Colors.blueAccent,
                                onPressed: () async {
                                  _checkConnectivity();
                                  if (_formkey5.currentState!.validate()) {
                                    token2 = preferences.getString('token');
                                    String oldpw =
                                        oldpswdController.text.toString();
                                    String newpw1 =
                                        newpswd1Controller.text.toString();
                                    String newpw2 =
                                        newpswd2Controller.text.toString();

                                    showDialog(
                                        barrierColor: Colors.transparent,
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) {
                                          Future.delayed(Duration(seconds: 1),
                                              () async {
                                            var data = {
                                              "old_password": oldpw,
                                              "new_password": newpw1,
                                              "confirm_password": newpw2,
                                            };

                                            //write api code here
                                            var insurl =
                                                'https://gramseva.in/api/customer/change-password';

                                            var response = await http.post(
                                              Uri.parse(insurl),
                                              body: data,
                                              headers: {
                                                "Authorization":
                                                    "Bearer $token2",
                                              },
                                            );

                                            var sts1 = json.decode(
                                                response.body)['status'];

                                            if (sts1 == 400) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      backgroundColor:
                                                          Color(0xff5f259e),
                                                      content: Text(
                                                        AppLocalization.of(
                                                                context)!
                                                            .translate(
                                                                'passworddoesnotmatch'),
                                                      )));
                                              Navigator.pop(context);
                                            } else if (sts1 == 200) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      backgroundColor:
                                                          Color(0xff5f259e),
                                                      content: Text(
                                                        AppLocalization.of(
                                                                context)!
                                                            .translate(
                                                                'passwordsuccessfullychanged'),
                                                      )));
                                              preferences.clear();
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          LoginPage()));
                                            }
                                          });
                                          return Center(
                                              child: Theme(
                                            data: Theme.of(context).copyWith(
                                                accentColor: Color(0xff5f259e)),
                                            child: CircularProgressIndicator(
                                              color: Color(0xff5f259e),
                                            ),
                                          ));
                                        });
                                  }
                                },
                                child: Text(
                                  AppLocalization.of(context)!
                                      .translate('changepassword'),
                                  style: TextStyle(fontSize: 20.0),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
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
      ),
    );
  }

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
}
