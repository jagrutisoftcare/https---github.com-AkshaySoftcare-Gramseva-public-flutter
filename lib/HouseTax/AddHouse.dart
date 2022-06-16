import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tax_app/Home/Dashboard.dart';
import 'package:tax_app/language/app_localization.dart';

class AddHousePage extends StatefulWidget {
  const AddHousePage({Key? key}) : super(key: key);

  @override
  _AddHousePageState createState() => _AddHousePageState();
}

class _AddHousePageState extends State<AddHousePage> {
  Future<void> secureScreen() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  final _formkey4 = GlobalKey<FormState>();

  late final SharedPreferences preferences;

  TextEditingController compid1Controller = TextEditingController();
  List gpnamedata1 = [];
  var selectedgpdata;
  var username1;
  var token2;
  read() async {
    preferences = await SharedPreferences.getInstance();
    username1 = preferences.getString('username');
    token2 = preferences.getString('token');
  }

  getgpdata() async {
    var response1 = await Dio().get(
      'https://gramseva.in/api/grampanchayat_list',
    );

    var idata = response1.data['data'];

    return idata;
  }

  @override
  void initState() {
    secureScreen();
    super.initState();
    _checkConnectivity();
    read();
    getgpdata().then((data) {
      setState(() {
        gpnamedata1 = data;
      });
    });
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
          AppLocalization.of(context)!.translate('registerhome'),
          style: TextStyle(fontWeight: FontWeight.w200),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formkey4,
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2),
                    ),
                    shadowColor: Colors.blue,
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 15,
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
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return AppLocalization.of(context)!
                                    .translate('entercomputernumber');
                              }
                              return null;
                            },
                            keyboardType: TextInputType.phone,
                            controller: compid1Controller,
                            cursorColor: Color(0xff5f259e),
                            style: TextStyle(color: Color(0xff5f259e)),
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
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Color(0xff5f259e),
                                  )),
                              labelText: AppLocalization.of(context)!
                                  .translate('entercomputernumber'),
                              labelStyle: TextStyle(
                                fontSize: 13,
                                color: Color(0xff5f259e),
                              ),
                            ),
                          ),
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
                                _checkConnectivity();
                                if (_formkey4.currentState!.validate()) {
                                  String compid1 =
                                      compid1Controller.text.toString();
                                  token2 = preferences.getString('token');

                                  showDialog(
                                      barrierColor: Colors.transparent,
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        Future.delayed(Duration(seconds: 1),
                                            () async {
                                          var data = {
                                            "computer_id": compid1,
                                            "grampanchayat_id": selectedgpdata
                                          };

                                          //write api code here
                                          var insurl =
                                              'https://gramseva.in/api/customer/add_house';

                                          var response = await http.post(
                                            Uri.parse(insurl),
                                            body: data,
                                            headers: {
                                              "Authorization": "Bearer $token2",
                                            },
                                          );

                                          if (response.statusCode == 401) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    backgroundColor:
                                                        Color(0xff5f259e),
                                                    content: Text(
                                                      AppLocalization.of(
                                                              context)!
                                                          .translate(
                                                              'thecomputernumberaboveisinvalid'),
                                                    )));
                                            Navigator.pop(context);
                                          } else if (response.statusCode ==
                                              200) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    backgroundColor:
                                                        Color(0xff5f259e),
                                                    content: Text(
                                                      AppLocalization.of(
                                                              context)!
                                                          .translate(
                                                              'thehousehasbeensuccessfullyconnected'),
                                                    )));
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        DashboardPage()));
                                            compid1Controller.clear();
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
                                        .translate('registerhome'),
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
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
