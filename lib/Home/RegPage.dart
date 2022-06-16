import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:tax_app/language/app_localization.dart';
import 'LoginPage.dart';
import 'package:http/http.dart' as http;
// ignore: import_of_legacy_library_into_null_safe
import 'package:timer_button/timer_button.dart';

class RegPage extends StatefulWidget {
  @override
  _RegPageState createState() => _RegPageState();
}

class _RegPageState extends State<RegPage> with SingleTickerProviderStateMixin {
  Future<void> secureScreen() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  final _formKey = GlobalKey<FormState>();

  List<String> data = [];
  TextEditingController prabhagnoController = TextEditingController();
  TextEditingController compidController = TextEditingController();
  TextEditingController custnameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  TextEditingController newTextEditingController = TextEditingController();
  Icon floatingIcon = Icon(Icons.add);
  List gpnamedata1 = [];
  var selectedgpdata;
  var result;

  int _tabIndex = 0;

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

  TextEditingController _pass = TextEditingController();
  TextEditingController _confirmPass = TextEditingController();

  getgpdata() async {
    var response1 = await Dio().get(
      'https://gramseva.in/api/grampanchayat_list',
    );
    print("GP LIST");
    print(response1.data);
    var idata = response1.data['data'];

    return idata;
  }

  var net;
  late final TabController _tabController;
  @override
  void initState() {
    secureScreen();
    _tabController = TabController(vsync: this, length: 3);
    super.initState();
    _checkInternet().then((data) {
      setState(() {
        net = data;
      });
    });
    getgpdata().then((data) {
      setState(() {
        gpnamedata1 = data;
      });
    });
  }

  var value;
  @override
  Future<void> dispose() async {
    super.dispose();
    await FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
  }

  _checkInternet() async {
    result = await Connectivity().checkConnectivity();
    return result;
  }

  void _toggleTab() {
    _tabIndex = _tabController.index + 1;
    _tabController.animateTo(_tabIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(18.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocalization.of(context)!.translate('alreadyhaveusers'),
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              },
              child: Text(
                AppLocalization.of(context)!.translate('login'),
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 2,
        backgroundColor: Color(0xff5f259e),
        title: Text(
          AppLocalization.of(context)!.translate('registration'),
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
        ),
        bottom: TabBar(
          onTap: (index) {
            setState(() {
              _tabController.index = 0;
            });
          },
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          tabs: [
            Tab(
              text: AppLocalization.of(context)!.translate('registration1'),
            ),
            Tab(
              text: AppLocalization.of(context)!.translate('registration2'),
            ),
            Tab(
              text: AppLocalization.of(context)!.translate('registration3'),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.all(15.0),
          child: Form(
            key: _formKey,
            child: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              controller: _tabController,
              children: [
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  shadowColor: Color(0xff5f259e),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 5,
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
                                    .translate('enterthecorrectsoundnumber');
                              else
                                return null;
                            },
                            cursorColor: Color(0xff5f259e),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Color(0xff5f259e),
                                  )),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
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
                            controller: phoneController,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return AppLocalization.of(context)!
                                    .translate('namerequired');
                              }
                              return null;
                            },
                            keyboardType: TextInputType.text,
                            controller: custnameController,
                            cursorColor: Color(0xff2655ff),
                            style: TextStyle(color: Colors.grey[600]),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Color(0xff5f259e),
                                  )),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Color(0xff5f259e),
                                  )),
                              labelText: AppLocalization.of(context)!
                                  .translate('name'),
                              labelStyle: TextStyle(
                                fontSize: 13,
                                color: Color(0xff5f259e),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                              cursorColor: Color(0xff5f259e),
                              validator: (value) {
                                if (value!.trim().isEmpty) {
                                  // The form is empty
                                  return AppLocalization.of(context)!
                                      .translate('emailrequired');
                                }
                                // This is just a regular expression for email addresses
                                String p = "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
                                    "\\@" +
                                    "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
                                    "(" +
                                    "\\." +
                                    "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
                                    ")+";
                                RegExp regExp = RegExp(p);

                                if (regExp.hasMatch(value)) {
                                  // So, the email is valid
                                  return null;
                                }

                                // The pattern of the email didn't match the regex above.
                                return AppLocalization.of(context)!
                                    .translate('writeavalidemail');
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Color(0xff5f259e),
                                    )),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Color(0xff5f259e),
                                    )),
                                labelText: AppLocalization.of(context)!
                                    .translate('email'),
                                labelStyle: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xff5f259e),
                                ),
                              ),
                              keyboardType: TextInputType.text,
                              controller: emailController),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding:
                                EdgeInsets.only(left: 0, right: 0, bottom: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(5),
                                  topLeft: Radius.circular(5),
                                  bottomLeft: Radius.circular(5),
                                  bottomRight: Radius.circular(5),
                                ),
                                border: Border.all(
                                  width: 1,
                                  color: Colors.grey,
                                  style: BorderStyle.solid,
                                ),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: Padding(
                                  padding: EdgeInsets.all(4.0),
                                  child: DropdownButtonFormField(
                                    validator: (value) => value == null
                                        ? AppLocalization.of(context)!
                                            .translate(
                                                'nameofgrampanchayatrequired')
                                        : null,
                                    decoration: InputDecoration(
                                      enabledBorder: InputBorder.none,
                                    ),

                                    iconEnabledColor: Color(0xff5f259e),
                                    items: gpnamedata1.map((item) {
                                      return DropdownMenuItem(
                                        child: Text(
                                          item['grampanchayat_name'],
                                          style: TextStyle(),
                                        ),
                                        value: item['grampanchayat_id'],
                                      );
                                    }).toList(),
                                    onChanged: (selectedvalue1) {
                                      setState(() {
                                        selectedgpdata = selectedvalue1;
                                      });
                                    },
                                    dropdownColor: Colors.white,
                                    //  value: selectedprabhag == ""
                                    value: selectedgpdata,
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        color: Color(0xff5f259e)),

                                    //? null
                                    //: selectedprabhag,
                                    hint: Text(
                                        AppLocalization.of(context)!.translate(
                                            'nameofthegrampanchayat'),
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Color(0xff5f259e))),

                                    icon: Icon(Icons.arrow_drop_down),
                                    iconSize: 30,
                                    isExpanded: true,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return AppLocalization.of(context)!
                                    .translate('computernumberrequired');
                              }
                              return null;
                            },
                            keyboardType: TextInputType.phone,
                            controller: compidController,
                            cursorColor: Color(0xff2655ff),
                            style: TextStyle(color: Colors.grey[600]),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Color(0xff5f259e),
                                  )),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Color(0xff5f259e),
                                  )),
                              labelText: AppLocalization.of(context)!
                                  .translate('computernumber'),
                              labelStyle: TextStyle(
                                fontSize: 13,
                                color: Color(0xff5f259e),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
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
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  String contact1 =
                                      phoneController.text.toString();
                                  String compid1 =
                                      compidController.text.toString();
                                  print(contact1.toString());
                                  print(compid1.toString());

                                  print(selectedgpdata.toString());

                                  showDialog(
                                      barrierColor: Colors.transparent,
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        Future.delayed(Duration(seconds: 0),
                                            () async {
                                          var bregbody = {
                                            "contact": contact1.toString(),
                                            "computer_id": compid1.toString(),
                                            "grampanchayat_id":
                                                selectedgpdata.toString()
                                          };

                                          // check mobile no already reg or not
                                          var bregurl =
                                              'https://gramseva.in/api/customer/beforeregister';

                                          var bregresponse = await http.post(
                                              Uri.parse(bregurl),
                                              body: bregbody);

                                          if (bregresponse.body
                                                  .contains('error') ==
                                              true) {
                                            var elen = json.decode(
                                                bregresponse.body)['error'];

                                            if (elen.length == 1) {
                                              if (elen.toString().contains(
                                                      'computer_id') ==
                                                  true) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        backgroundColor:
                                                            Color(0xff5f259e),
                                                        content: Text(
                                                          AppLocalization.of(
                                                                  context)!
                                                              .translate(
                                                                  'computernumberisalreadyregistered'),
                                                        )));

                                                Navigator.pop(context);
                                              } else if (elen
                                                      .toString()
                                                      .contains('contact') ==
                                                  true) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        backgroundColor:
                                                            Color(0xff5f259e),
                                                        content: Text(
                                                          AppLocalization.of(
                                                                  context)!
                                                              .translate(
                                                                  'voicenumberalreadyregistered'),
                                                        )));
                                                Navigator.pop(context);
                                              }
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      backgroundColor:
                                                          Color(0xff5f259e),
                                                      content: Text(
                                                        AppLocalization.of(
                                                                context)!
                                                            .translate(
                                                                'computernumberandmobilenumberarealreadyregistered'),
                                                      )));

                                              Navigator.pop(context);
                                            }
                                          } else if (bregresponse.body
                                                  .contains('result') ==
                                              true) {
                                            var data1 = {
                                              "contact": contact1,
                                            };
                                            var otpgurl =
                                                'https://gramseva.in/api/customer/one';

                                            var otpresponse = await http.post(
                                                Uri.parse(otpgurl),
                                                body: data1);

                                            /*var otpsts = json.decode(
                                                    otpresponse.body)['result']
                                                ['status'];*/
                                            if (otpresponse.statusCode == 200) {
                                              Navigator.pop(context);
                                              _toggleTab();
                                            }
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
                              child: Ink(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: Color(0xff5f259e)),
                                child: Container(
                                  alignment: Alignment.center,
                                  constraints: BoxConstraints(
                                      maxWidth: double.infinity, minHeight: 50),
                                  child: Text(
                                    AppLocalization.of(context)!
                                        .translate('goahead'),
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // 2 nd screen
                Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    shadowColor: Color(0xff5f259e),
                    child: SingleChildScrollView(
                        child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 5,
                                ),
                                OTPTextField(
                                  length: 6,
                                  width: MediaQuery.of(context).size.width,
                                  textFieldAlignment:
                                      MainAxisAlignment.spaceAround,
                                  fieldStyle: FieldStyle.underline,
                                  style: TextStyle(fontSize: 12),
                                  onChanged: (pin) {
                                    value = pin;
                                  },
                                  onCompleted: (pin) {
                                    value = pin;
                                  },
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TimerButton(
                                      label: AppLocalization.of(context)!
                                          .translate('resendotp'),
                                      timeOutInSeconds: 60,
                                      onPressed: () async {
                                        String contact1 =
                                            phoneController.text.toString();

                                        var data2 = {
                                          "contact": contact1,
                                        };

                                        //write api code here
                                        var rotpgurl =
                                            'https://gramseva.in/api/customer/one';

                                        var rotpresponse = await http.post(
                                            Uri.parse(rotpgurl),
                                            body: data2);
                                      },
                                      buttonType: ButtonType.FlatButton,
                                      disabledColor: Colors.white,
                                      color: Colors.transparent,
                                      disabledTextStyle: new TextStyle(
                                          fontSize: 12.0, color: Colors.black),
                                      activeTextStyle: new TextStyle(
                                          fontSize: 12.0,
                                          color: Color(0xff5f259e)),
                                    ),
                                  ],
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
                                    onPressed: () async {
                                      String contact1 =
                                          phoneController.text.toString();
                                      showDialog(
                                          barrierColor: Colors.transparent,
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (BuildContext context) {
                                            Future.delayed(Duration(seconds: 0),
                                                () async {
                                              var validresponse = await Dio().get(
                                                  'https://gramseva.in/api/customer/two?otp=' +
                                                      value +
                                                      '&contact=' +
                                                      contact1);

                                              var validstatus = validresponse
                                                  .data['result']['status'];

                                              if (validstatus == true) {
                                                Navigator.pop(context);
                                                _toggleTab();
                                              } else if (validstatus == false) {
                                                Navigator.pop(context);
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        backgroundColor:
                                                            Color(0xff5f259e),
                                                        content: Text(
                                                          AppLocalization.of(
                                                                  context)!
                                                              .translate(
                                                                  'invalidotp'),
                                                        )));
                                              }
                                            });
                                            return Center(
                                                child: Theme(
                                              data: Theme.of(context).copyWith(
                                                  accentColor:
                                                      Color(0xff5f259e)),
                                              child: CircularProgressIndicator(
                                                color: Color(0xff5f259e),
                                              ),
                                            ));
                                          });
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
                                              .translate('goahead'),
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )))),

                Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    shadowColor: Color(0xff5f259e),
                    child: SingleChildScrollView(
                        child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Column(children: [
                              SizedBox(
                                height: 15,
                              ),
                              TextFormField(
                                  obscureText: _obsuretext1,
                                  keyboardType: TextInputType.text,
                                  cursorColor: Color(0xff5f259e),
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
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
                                  controller: _pass,
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
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4)),
                                        borderSide: BorderSide(
                                          width: 1,
                                          color: Color(0xff5f259e),
                                        )),
                                    labelText: AppLocalization.of(context)!
                                        .translate('enterthepasswordagain'),
                                    labelStyle: TextStyle(
                                      fontSize: 13,
                                      color: Color(0xff5f259e),
                                    ),
                                  ),
                                  controller: _confirmPass,
                                  validator: (val) {
                                    if (val!.trim().isEmpty)
                                      return AppLocalization.of(context)!
                                          .translate('passwordrequired');
                                    else if (val.length < 8)
                                      return AppLocalization.of(context)!.translate(
                                          'passwordmustbenolessthancharacters');
                                    if (val != _pass.text)
                                      return AppLocalization.of(context)!
                                          .translate('passworddoesnotmatch');
                                    return null;
                                  }),
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
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      String gpname = selectedgpdata;

                                      String compid =
                                          compidController.text.toString();
                                      String custname =
                                          custnameController.text.toString();
                                      String phone =
                                          phoneController.text.toString();

                                      String email =
                                          emailController.text.toString();
                                      String password = _pass.text.toString();

                                      showDialog(
                                          barrierColor: Colors.transparent,
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (BuildContext context) {
                                            Future.delayed(Duration(seconds: 2),
                                                () async {
                                              var data = {
                                                "gp_id": gpname,
                                                "customer_name": custname,
                                                "contact": phone,
                                                "computer_id": compid,
                                                "email": email,
                                                "password": password,
                                              };
                                              //write api code here
                                              var insurl =
                                                  'https://gramseva.in/api/customer/register';
                                              var response = await http.post(
                                                  Uri.parse(insurl),
                                                  body: data);
                                              print("REG RESPONSE");
                                              print(response.statusCode);
                                              print(response.body);

                                              if (response.statusCode == 200) {
                                                Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            LoginPage()));
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        backgroundColor:
                                                            Color(0xff5f259e),
                                                        content: Text(
                                                          AppLocalization.of(
                                                                  context)!
                                                              .translate(
                                                                  'registrationhasbeensuccessful'),
                                                        )));

                                                compidController.clear();
                                                phoneController.clear();
                                                emailController.clear();
                                                _pass.clear();
                                                _confirmPass.clear();
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        backgroundColor:
                                                            Color(0xff5f259e),
                                                        content: Text(
                                                          AppLocalization.of(
                                                                  context)!
                                                              .translate(
                                                                  'failedregistration'),
                                                        )));
                                                Navigator.of(context).pop();
                                              }
                                            });
                                            return Center(
                                                child: Theme(
                                              data: Theme.of(context).copyWith(
                                                  accentColor:
                                                      Color(0xff5f259e)),
                                              child: CircularProgressIndicator(
                                                color: Color(0xff5f259e),
                                              ),
                                            ));
                                          });
                                    }
                                  },
                                  child: Ink(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: Color(0xff5f259e)),
                                    child: Container(
                                      alignment: Alignment.center,
                                      constraints: BoxConstraints(
                                          maxWidth: double.infinity,
                                          minHeight: 50),
                                      child: Text(
                                        AppLocalization.of(context)!
                                            .translate('register'),
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.white),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ]))))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
