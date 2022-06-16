import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;
// ignore: import_of_legacy_library_into_null_safe
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tax_app/Home/Dashboard.dart';
import 'package:tax_app/Payment/PaymentFailedPage.dart';
import 'package:tax_app/Payment/PaymentSuccess.dart';

/// liraries for pdf
import 'dart:io';

// ignore: import_of_legacy_library_into_null_safe
import 'package:ext_storage/ext_storage.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:open_file/open_file.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:translator/translator.dart';

import 'dart:async';
import 'dart:math';

import 'package:safexpay/constants/strings.dart';

import 'package:safexpay/safexpay.dart';

import 'language/app_localization.dart';

// ignore: must_be_immutable
class ViewHouseTax extends StatefulWidget {
  String compid1;
  String custid1;
  String gpid2;
  ViewHouseTax(this.compid1, this.custid1, this.gpid2);
  @override
  _ViewHouseTaxState createState() => _ViewHouseTaxState();
}

class _ViewHouseTaxState extends State<ViewHouseTax>
    implements SafeXPayPaymentCallback {
  // ignore: unused_field
  String _platformVersion = 'Unknown';

  late SafeXPayPaymentCallbackObservable _safeXPayPaymentCallbackObservable;

  var msg;
  //for pdf and notify
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();
  var initializationSettingsAndroid;
  var initializationSettingsIOS;
  var initializationSettings;
  var path2;
  late SharedPreferences preferences;

  var username1;
  var token1;
  var gpid1;
  var mid1;
  var pid1;
  List individual = [];
  bool _center = true;
  bool _text = false;
  var amt;
  var custname;
  var email;

//for pdf anf notify

  var file2;

  Future<void> _demoNotification() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'channel_ID', 'channel name',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'test ticker');

    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
        0, 'House Tax', 'Pdf downloaded!', platformChannelSpecifics,
        payload: 'test oayload');
  }

//get individual data

  getIndividual() async {
    preferences = await SharedPreferences.getInstance();
    username1 = preferences.getString('username');
    token1 = preferences.getString('token');
    gpid1 = preferences.getString('gpid');

    var response = await Dio().get(
        'https://gramseva.in/api/customer/get_tax?grampanchayat_id=' +
            widget.gpid2 +
            '&computer_id=' +
            widget.compid1,
        options: Options(headers: {"Authorization": "Bearer $token1"}));

    var taxdata = response.data['data'];

    setState(() {
      if (taxdata.length == 0) {
        setState(() {
          _center = false;
          _text = true;
        });
      }
    });

    var mid = response.data['data'][0]['master_id'];

    mid1 = mid;
    return taxdata;
  }

  Future<void> secureScreen() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  final translator = GoogleTranslator();
  @override
  void initState() {
    secureScreen();
    super.initState();

    initPlatformState();
    _safeXPayPaymentCallbackObservable = SafeXPayPaymentCallbackObservable();
    _safeXPayPaymentCallbackObservable.register(this);

    //fetch merchant data through api
    MerchantConstants.setDetails(
        mId: '201705240001',
        mKey: 'rXbmCVAcefiPyWZz9wVs9WBYPbaYVfDV4VxwowyJBHg=',
        aggId: 'Paygate',
        environment: Environment.PRODUCTION);
    //  //fetch merchant data through api
    //   MerchantConstants.setDetails(
    //       mId: '202107210001',
    //       mKey: '+d9Tu9pTB8YOFd68cA12xE+ELb3qY/Abp6yOd4OzdB4=',
    //       aggId: 'Paygate',
    //       environment: Environment.PRODUCTION);

    Permission.storage.request();
    getIndividual().then((data) {
      setState(() {
        individual = data;

        if (individual.length == 0) {
          setState(() {
            _center = false;
            _text = true;
          });
        }
      });
    });

    initializationSettingsAndroid = new AndroidInitializationSettings('logo_3');
    // initializationSettingsIOS = new IOSInitializationSettings(
    //     onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    initializationSettings = new InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: null,
      macOS: null,
    );
    flutterLocalNotificationsPlugin.pendingNotificationRequests();
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    await FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
    _safeXPayPaymentCallbackObservable.unRegister(this);
  }

  showToast(msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.black54,
    );
  }

//for pdf and notify
  Future onSelectNotification(String payload) async {
    // ignore: unnecessary_null_comparison
    if (payload != null) {
      OpenFile.open(file2.path);
      // OpenFile.open('/storage/emulated/0/Download/htax1.pdf');

    }
    await Navigator.push(context,
        new MaterialPageRoute(builder: (context) => new DashboardPage()));
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
              title: Text(title),
              content: Text(body),
              actions: <Widget>[
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Text(
                    AppLocalization.of(context)!.translate('ok'),
                  ),
                  onPressed: () async {
                    Navigator.of(context, rootNavigator: true).pop();
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DashboardPage()));
                  },
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          AppLocalization.of(context)!.translate('homesteadinformation'),
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
        ),
        actions: [
          PopupMenuButton(
            itemBuilder: (BuildContext bc) => [
              PopupMenuItem(
                  child: Text(
                    AppLocalization.of(context)!.translate('reducethehouse'),
                  ),
                  value: "/removehouse"),
            ],
            onSelected: (route) async {
              _removehouse();
            },
          ),
        ],
        backgroundColor: Color(0xff5f259e),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(4.0),
          child: individual.length > 0
              ? ListView.builder(
                  itemCount: individual.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1, //                   <--- border width here
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              AppLocalization.of(context)!
                                  .translate('realestatefiscalyear'),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w200),
                            ),

                            Divider(
                              color: Colors.black,
                            ),

                            Table(
                              border: TableBorder.all(color: Colors.black54),
                              children: [
                                TableRow(children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      AppLocalization.of(context)!
                                          .translate('computernumber'),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      individual[index]['computer_id']
                                          .toString(),
                                      maxLines: 10,
                                      overflow: TextOverflow.visible,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  )
                                ]),
                                TableRow(children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      AppLocalization.of(context)!
                                          .translate('nameofthevillage'),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      individual[index]['village_name']
                                          .toString(),
                                      maxLines: 10,
                                      overflow: TextOverflow.visible,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  )
                                ]),
                                TableRow(children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      AppLocalization.of(context)!
                                          .translate('wardnumber'),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      individual[index]['ward_no'] ?? '',
                                      maxLines: 10,
                                      overflow: TextOverflow.visible,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  )
                                ]),
                                TableRow(children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      AppLocalization.of(context)!
                                          .translate('flatnumber'),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      individual[index]['property_no']
                                          .toString(),
                                      maxLines: 10,
                                      overflow: TextOverflow.visible,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  )
                                ]),
                                //start
                                TableRow(children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      AppLocalization.of(context)!
                                          .translate('flattype'),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      individual[index]['property_type']
                                          .toString(),
                                      maxLines: 10,
                                      overflow: TextOverflow.visible,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  )
                                ]),
                                TableRow(children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      AppLocalization.of(context)!
                                          .translate('ownersname'),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      individual[index]['owner_name']
                                          .toString(),
                                      maxLines: 10,
                                      overflow: TextOverflow.visible,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  )
                                ]),
                                TableRow(children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      AppLocalization.of(context)!
                                          .translate('ownervoicenumber'),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      individual[index]['owner_contact'] ?? '',
                                      maxLines: 10,
                                      overflow: TextOverflow.visible,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  )
                                ]),
                                TableRow(children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      AppLocalization.of(context)!
                                          .translate('propertydescription'),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      individual[index]['property_description']
                                          .toString(),
                                      maxLines: 10,
                                      overflow: TextOverflow.visible,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  )
                                ]),
                                TableRow(children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      AppLocalization.of(context)!
                                          .translate('occupantsname'),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      individual[index]['occupants_name']
                                          .toString(),
                                      maxLines: 10,
                                      overflow: TextOverflow.visible,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  )
                                ]),
                                TableRow(children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      AppLocalization.of(context)!
                                          .translate('housearea'),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      individual[index]['house_area']
                                          .toString(),
                                      maxLines: 10,
                                      overflow: TextOverflow.visible,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  )
                                ]),
                                TableRow(children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      AppLocalization.of(context)!
                                          .translate('constructionyear'),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      individual[index]['construction_year']
                                          .toString(),
                                      maxLines: 10,
                                      overflow: TextOverflow.visible,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  )
                                ]),
                                TableRow(children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      AppLocalization.of(context)!
                                          .translate('depreciation'),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      individual[index]['depreciation'] ?? 0.0,
                                      maxLines: 10,
                                      overflow: TextOverflow.visible,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  )
                                ]),
                                TableRow(children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      AppLocalization.of(context)!
                                          .translate('weight'),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      individual[index]['weight'] ?? 0.0,
                                      maxLines: 10,
                                      overflow: TextOverflow.visible,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  )
                                ]),
                                TableRow(children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      AppLocalization.of(context)!
                                          .translate('capitalvalue'),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      individual[index]['capital_value']
                                          .toString(),
                                      maxLines: 10,
                                      overflow: TextOverflow.visible,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  )
                                ]),
                                TableRow(children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      AppLocalization.of(context)!
                                          .translate('taxrate'),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      individual[index]['tax_rate'].toString(),
                                      maxLines: 10,
                                      overflow: TextOverflow.visible,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  )
                                ]),
                              ],
                            ),

                            SizedBox(
                              height: 10,
                            ),

                            Container(
                              child: Text(
                                AppLocalization.of(context)!
                                    .translate('startrate'),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),

                            Divider(
                              color: Colors.black,
                            ),

                            Table(
                              border: TableBorder.all(color: Colors.black54),
                              children: [
                                TableRow(children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      AppLocalization.of(context)!
                                          .translate('housetax'),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      individual[index]['house_tax'].toString(),
                                      maxLines: 10,
                                      overflow: TextOverflow.visible,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  )
                                ]),
                                TableRow(children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      AppLocalization.of(context)!
                                          .translate('electricitytax'),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      individual[index]['light_tax'].toString(),
                                      maxLines: 10,
                                      overflow: TextOverflow.visible,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  )
                                ]),
                                TableRow(children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      AppLocalization.of(context)!
                                          .translate('healthtax'),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      individual[index]['health_tax']
                                          .toString(),
                                      maxLines: 10,
                                      overflow: TextOverflow.visible,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  )
                                ]),
                                TableRow(children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      AppLocalization.of(context)!
                                          .translate('totaltax'),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      individual[index]['total_tax'].toString(),
                                      overflow: TextOverflow.visible,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  )
                                ]),
                                TableRow(children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      AppLocalization.of(context)!
                                          .translate('discountamount'),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      individual[index]['discount_amount']
                                          .toString(),
                                      overflow: TextOverflow.visible,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  )
                                ]),
                              ],
                            ),

                            SizedBox(
                              height: 8,
                            ),
                            //Resident info
                            Text(
                              AppLocalization.of(context)!
                                  .translate('previoustax'),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),

                            Divider(
                              color: Colors.black,
                            ),

                            Table(
                              border: TableBorder.all(color: Colors.black54),
                              children: [
                                TableRow(children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      AppLocalization.of(context)!
                                          .translate('housetax'),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      individual[index]['previous_house_tax']
                                          .toString(),
                                      maxLines: 10,
                                      overflow: TextOverflow.visible,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  )
                                ]),
                                TableRow(children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      AppLocalization.of(context)!
                                          .translate('electricitytax'),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      individual[index]['previous_light_tax']
                                          .toString(),
                                      maxLines: 10,
                                      overflow: TextOverflow.visible,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  )
                                ]),
                                TableRow(children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      AppLocalization.of(context)!
                                          .translate('healthtax'),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      individual[index]['previous_health_tax']
                                          .toString(),
                                      maxLines: 10,
                                      overflow: TextOverflow.visible,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  )
                                ]),
                                TableRow(children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      AppLocalization.of(context)!
                                          .translate('totaltax'),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      individual[index]['previous_total']
                                          .toString(),
                                      maxLines: 10,
                                      overflow: TextOverflow.visible,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  )
                                ]),
                                TableRow(children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      AppLocalization.of(context)!
                                          .translate('penaltytotal'),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      individual[index]['penalty_total']
                                          .toString(),
                                      maxLines: 10,
                                      overflow: TextOverflow.visible,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  )
                                ]),
                              ],
                            ),

                            SizedBox(
                              height: 8,
                            ),

                            Text(
                              AppLocalization.of(context)!
                                  .translate('totaltax'),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),

                            Divider(
                              color: Colors.black,
                            ),

                            Table(
                              border: TableBorder.all(color: Colors.black54),
                              children: [
                                TableRow(children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      AppLocalization.of(context)!
                                          .translate('housetax'),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      individual[index]['final_house_tax']
                                          .toString(),
                                      maxLines: 10,
                                      overflow: TextOverflow.visible,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  )
                                ]),
                                TableRow(children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      AppLocalization.of(context)!
                                          .translate('electricitytax'),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      individual[index]['final_light_tax']
                                          .toString(),
                                      maxLines: 10,
                                      overflow: TextOverflow.visible,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  )
                                ]),
                                TableRow(children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      AppLocalization.of(context)!
                                          .translate('healthtax'),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      individual[index]['final_health_tax']
                                          .toString(),
                                      maxLines: 10,
                                      overflow: TextOverflow.visible,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  )
                                ]),
                                TableRow(children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      AppLocalization.of(context)!
                                          .translate('totaltax'),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      individual[index]['final_total']
                                          .toString(),
                                      maxLines: 10,
                                      overflow: TextOverflow.visible,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  )
                                ]),
                              ],
                            ),

                            SizedBox(
                              height: 15,
                            ),

                            individual[index]['payment_status'].toString() ==
                                    "0"
                                ? Container(
                                    height: 45,
                                    width: double.infinity,
                                    // ignore: deprecated_member_use
                                    child: FlatButton(
                                      onPressed: () async {
                                        amt = double.parse(individual[index]
                                                ['final_total']
                                            .toString());
                                        custname = individual[index]
                                                ['customer_name']
                                            .toString();
                                        email = individual[index]
                                                ['customer_email']
                                            .toString();
                                        try {
                                          SafeXPayGateway safeXPayGateway =
                                              SafeXPayGateway(
                                                  orderNo:
                                                      '${Random().nextInt(1000)}',
                                                  amount: amt,
                                                  currency: 'INR',
                                                  transactionType: 'SALE',
                                                  channel: 'MOBILE',
                                                  successUrl:
                                                      'http://localhost/safexpay/response.php',
                                                  failureUrl:
                                                      'http://localhost/safexpay/response.php',
                                                  countryCode: 'IND');

                                          safeXPayGateway.setUserDetails(
                                              name: individual[index]
                                                      ['customer_name']
                                                  .toString(),
                                              emailId: individual[index]
                                                      ['customer_email']
                                                  .toString(),
                                              mobile: username1);
                                          safeXPayGateway.allowedPaymentMethods(
                                              allowCardPayment: true,
                                              allowNetBankingPayment: true,
                                              allowWalletPayment: true,
                                              allowUPIPayment: true);
                                          safeXPayGateway.setUdf(
                                              UDF1: individual[index]
                                                      ['computer_id']
                                                  .toString(),
                                              UDF2: "2020-2021",
                                              UDF3: "null",
                                              UDF4: "null",
                                              UDF5: "null");

                                          MaterialPageRoute route =
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      safeXPayGateway);
                                          Navigator.push(context, route);
                                        } catch (e) {}
                                      },
                                      padding: EdgeInsets.all(0),
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
                                                .translate('homesteadpaid'),
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.white),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                    ),
                                  )
                                : Container(
                                    height: 45,
                                    width: double.infinity,
                                    // ignore: deprecated_member_use
                                    child: FlatButton(
                                      onPressed: () async {
                                        var paydata = {
                                          "computer_id": individual[index]
                                                  ['computer_id']
                                              .toString(),
                                        };

                                        //write api code here
                                        var payapi =
                                            'https://gramseva.in/api/customer/getdetails_by_computerid';

                                        var token2 =
                                            preferences.getString('token');

                                        var response = await http.post(
                                          Uri.parse(payapi),
                                          body: paydata,
                                          headers: {
                                            "Authorization": "Bearer $token2",
                                          },
                                        );
                                        _demoNotification();
                                        final pdf = pw.Document();

                                        final ByteData data = await rootBundle
                                            .load('fonts/Hind-Medium.ttf');
                                        data.buffer.asUint8List(
                                            data.offsetInBytes,
                                            data.lengthInBytes);
                                        final font1 = pw.Font.ttf(data);

                                        ///final Uint8List fontData = File('fonts/Hind-Medium.ttf').readAsBytesSync();
                                        ///final ttf = pw.Font.ttf(fontData.buffer.asByteData());
                                        var varrealestatefiscalyear =
                                            AppLocalization.of(context)!
                                                .translate(
                                                    'realestatefiscalyear');
                                        var varcomputernumber =
                                            AppLocalization.of(context)!
                                                .translate('computernumber');
                                        var varnameofthevillage =
                                            AppLocalization.of(context)!
                                                .translate('nameofthevillage');
                                        var varwardnumber =
                                            AppLocalization.of(context)!
                                                .translate('wardnumber');
                                        var varflatnumber =
                                            AppLocalization.of(context)!
                                                .translate('flatnumber');
                                        var varflattype =
                                            AppLocalization.of(context)!
                                                .translate('flattype');
                                        var varownersname =
                                            AppLocalization.of(context)!
                                                .translate('ownersname');
                                        var varownervoicenumber =
                                            AppLocalization.of(context)!
                                                .translate('ownervoicenumber');
                                        var varpropertydescription =
                                            AppLocalization.of(context)!
                                                .translate(
                                                    'propertydescription');
                                        var varoccupantsname =
                                            AppLocalization.of(context)!
                                                .translate('occupantsname');
                                        var varhousearea =
                                            AppLocalization.of(context)!
                                                .translate('housearea');
                                        var varconstructionyear =
                                            AppLocalization.of(context)!
                                                .translate('constructionyear');
                                        var vardepreciation =
                                            AppLocalization.of(context)!
                                                .translate('depreciation');
                                        var varweight =
                                            AppLocalization.of(context)!
                                                .translate('weight');
                                        var varcapitalvalue =
                                            AppLocalization.of(context)!
                                                .translate('capitalvalue');
                                        var vartaxrate =
                                            AppLocalization.of(context)!
                                                .translate('taxrate');
                                        var varstartrate =
                                            AppLocalization.of(context)!
                                                .translate('startrate');
                                        var varhousetax =
                                            AppLocalization.of(context)!
                                                .translate('housetax');
                                        var varelectricitytax =
                                            AppLocalization.of(context)!
                                                .translate('electricitytax');
                                        var varhealthtax =
                                            AppLocalization.of(context)!
                                                .translate('healthtax');
                                        var vartotaltax =
                                            AppLocalization.of(context)!
                                                .translate('totaltax');
                                        var varprevioustax =
                                            AppLocalization.of(context)!
                                                .translate('previoustax');
                                        var varpenaltytotal =
                                            AppLocalization.of(context)!
                                                .translate('penaltytotal');
                                        pdf.addPage(pw.MultiPage(
                                          build: (context) => [
                                            pw.Container(
                                                child: pw.ListView(children: [
                                                  pw.SizedBox(height: 10),
                                                  pw.Text(
                                                      varrealestatefiscalyear,
                                                      textAlign:
                                                          pw.TextAlign.center,
                                                      style: pw.TextStyle(
                                                          fontSize: 20,
                                                          font: font1)),
                                                  /* pw.Divider(
                                                      color: PdfColors.black),*/
                                                  pw.Table(
                                                      border:
                                                          pw.TableBorder.all(),
                                                      children: [
                                                        pw.TableRow(children: [
                                                          pw.Text(
                                                            varcomputernumber,
                                                            style: pw.TextStyle(
                                                                fontSize: 15,
                                                                font: font1),
                                                          ),
                                                          pw.Text(
                                                            individual[index][
                                                                    'computer_id']
                                                                .toString(),
                                                            maxLines: 10,
                                                            overflow: pw
                                                                .TextOverflow
                                                                .visible,
                                                            style: pw.TextStyle(
                                                                fontSize: 15,
                                                                font: font1),
                                                          )
                                                        ]),
                                                        pw.TableRow(children: [
                                                          pw.Text(
                                                            varnameofthevillage,
                                                            maxLines: 10,
                                                            overflow: pw
                                                                .TextOverflow
                                                                .visible,
                                                            style: pw.TextStyle(
                                                                fontSize: 15,
                                                                font: font1),
                                                          ),
                                                          pw.Text(
                                                            individual[index][
                                                                    'village_name']
                                                                .toString(),
                                                            maxLines: 10,
                                                            overflow: pw
                                                                .TextOverflow
                                                                .visible,
                                                            style: pw.TextStyle(
                                                                fontSize: 15,
                                                                font: font1),
                                                          ),
                                                        ]),
                                                        pw.TableRow(children: [
                                                          pw.Text(
                                                            varwardnumber,
                                                            maxLines: 10,
                                                            overflow: pw
                                                                .TextOverflow
                                                                .visible,
                                                            style: pw.TextStyle(
                                                                fontSize: 15,
                                                                font: font1),
                                                          ),
                                                          pw.Text(
                                                            individual[index][
                                                                    'ward_no'] ??
                                                                '',
                                                            maxLines: 10,
                                                            overflow: pw
                                                                .TextOverflow
                                                                .visible,
                                                            style: pw.TextStyle(
                                                                fontSize: 15,
                                                                font: font1),
                                                          ),
                                                        ]),
                                                        pw.TableRow(children: [
                                                          pw.Text(
                                                            varflatnumber,
                                                            maxLines: 10,
                                                            overflow: pw
                                                                .TextOverflow
                                                                .visible,
                                                            style: pw.TextStyle(
                                                                fontSize: 15,
                                                                font: font1),
                                                          ),
                                                          pw.Text(
                                                            individual[index][
                                                                    'property_no']
                                                                .toString(),
                                                            maxLines: 10,
                                                            overflow: pw
                                                                .TextOverflow
                                                                .visible,
                                                            style: pw.TextStyle(
                                                                fontSize: 15,
                                                                font: font1),
                                                          ),
                                                        ]),
                                                        //start
                                                        pw.TableRow(children: [
                                                          pw.Text(
                                                            varflattype,
                                                            maxLines: 10,
                                                            overflow: pw
                                                                .TextOverflow
                                                                .visible,
                                                            style: pw.TextStyle(
                                                                fontSize: 15,
                                                                font: font1),
                                                          ),
                                                          pw.Text(
                                                            individual[index][
                                                                    'property_type']
                                                                .toString(),
                                                            maxLines: 10,
                                                            overflow: pw
                                                                .TextOverflow
                                                                .visible,
                                                            style: pw.TextStyle(
                                                                fontSize: 15,
                                                                font: font1),
                                                          ),
                                                        ]),
                                                        pw.TableRow(children: [
                                                          pw.Text(
                                                            varownersname,
                                                            maxLines: 10,
                                                            overflow: pw
                                                                .TextOverflow
                                                                .visible,
                                                            style: pw.TextStyle(
                                                                fontSize: 15,
                                                                font: font1),
                                                          ),
                                                          pw.Text(
                                                            individual[index][
                                                                    'owner_name']
                                                                .toString(),
                                                            maxLines: 10,
                                                            overflow: pw
                                                                .TextOverflow
                                                                .visible,
                                                            style: pw.TextStyle(
                                                                fontSize: 15,
                                                                font: font1),
                                                          ),
                                                        ]),
                                                        pw.TableRow(children: [
                                                          pw.Text(
                                                            varownervoicenumber,
                                                            maxLines: 10,
                                                            overflow: pw
                                                                .TextOverflow
                                                                .visible,
                                                            style: pw.TextStyle(
                                                                fontSize: 15,
                                                                font: font1),
                                                          ),
                                                          pw.Text(
                                                            individual[index][
                                                                    'owner_contact'] ??
                                                                '',
                                                            maxLines: 10,
                                                            overflow: pw
                                                                .TextOverflow
                                                                .visible,
                                                            style: pw.TextStyle(
                                                                fontSize: 15,
                                                                font: font1),
                                                          ),
                                                        ]),
                                                        pw.TableRow(children: [
                                                          pw.Text(
                                                            varpropertydescription,
                                                            maxLines: 10,
                                                            overflow: pw
                                                                .TextOverflow
                                                                .visible,
                                                            style: pw.TextStyle(
                                                                fontSize: 15,
                                                                font: font1),
                                                          ),
                                                          pw.Text(
                                                            individual[index][
                                                                    'property_description']
                                                                .toString(),
                                                            maxLines: 10,
                                                            overflow: pw
                                                                .TextOverflow
                                                                .visible,
                                                            style: pw.TextStyle(
                                                                fontSize: 15,
                                                                font: font1),
                                                          ),
                                                        ]),
                                                        pw.TableRow(children: [
                                                          pw.Text(
                                                            varoccupantsname,
                                                            maxLines: 10,
                                                            overflow: pw
                                                                .TextOverflow
                                                                .visible,
                                                            style: pw.TextStyle(
                                                                fontSize: 15,
                                                                font: font1),
                                                          ),
                                                          pw.Text(
                                                            individual[index][
                                                                    'occupants_name']
                                                                .toString(),
                                                            maxLines: 10,
                                                            overflow: pw
                                                                .TextOverflow
                                                                .visible,
                                                            style: pw.TextStyle(
                                                                fontSize: 15,
                                                                font: font1),
                                                          ),
                                                        ]),
                                                        pw.TableRow(children: [
                                                          pw.Text(
                                                            varhousearea,
                                                            maxLines: 10,
                                                            overflow: pw
                                                                .TextOverflow
                                                                .visible,
                                                            style: pw.TextStyle(
                                                                fontSize: 15,
                                                                font: font1),
                                                          ),
                                                          pw.Text(
                                                            individual[index][
                                                                    'house_area']
                                                                .toString(),
                                                            maxLines: 10,
                                                            overflow: pw
                                                                .TextOverflow
                                                                .visible,
                                                            style: pw.TextStyle(
                                                                fontSize: 15,
                                                                font: font1),
                                                          ),
                                                        ]),
                                                        pw.TableRow(children: [
                                                          pw.Text(
                                                            varconstructionyear,
                                                            maxLines: 10,
                                                            overflow: pw
                                                                .TextOverflow
                                                                .visible,
                                                            style: pw.TextStyle(
                                                                fontSize: 15,
                                                                font: font1),
                                                          ),
                                                          pw.Text(
                                                            individual[index][
                                                                    'construction_year']
                                                                .toString(),
                                                            maxLines: 10,
                                                            overflow: pw
                                                                .TextOverflow
                                                                .visible,
                                                            style: pw.TextStyle(
                                                                fontSize: 15,
                                                                font: font1),
                                                          ),
                                                        ]),
                                                        pw.TableRow(children: [
                                                          pw.Text(
                                                            vardepreciation,
                                                            maxLines: 10,
                                                            overflow: pw
                                                                .TextOverflow
                                                                .visible,
                                                            style: pw.TextStyle(
                                                                fontSize: 15,
                                                                font: font1),
                                                          ),
                                                          pw.Text(
                                                            individual[index][
                                                                    'depreciation']
                                                                .toString(),
                                                            maxLines: 10,
                                                            overflow: pw
                                                                .TextOverflow
                                                                .visible,
                                                            style: pw.TextStyle(
                                                                fontSize: 15,
                                                                font: font1),
                                                          ),
                                                        ]),
                                                        pw.TableRow(children: [
                                                          pw.Text(
                                                            varweight,
                                                            maxLines: 10,
                                                            overflow: pw
                                                                .TextOverflow
                                                                .visible,
                                                            style: pw.TextStyle(
                                                                fontSize: 15,
                                                                font: font1),
                                                          ),
                                                          pw.Text(
                                                            individual[index][
                                                                    'weight'] ??
                                                                0.0,
                                                            maxLines: 10,
                                                            overflow: pw
                                                                .TextOverflow
                                                                .visible,
                                                            style: pw.TextStyle(
                                                                fontSize: 15,
                                                                font: font1),
                                                          ),
                                                        ]),
                                                        pw.TableRow(children: [
                                                          pw.Text(
                                                            varcapitalvalue,
                                                            maxLines: 10,
                                                            overflow: pw
                                                                .TextOverflow
                                                                .visible,
                                                            style: pw.TextStyle(
                                                                fontSize: 15,
                                                                font: font1),
                                                          ),
                                                          pw.Text(
                                                            individual[index][
                                                                    'capital_value']
                                                                .toString(),
                                                            maxLines: 10,
                                                            overflow: pw
                                                                .TextOverflow
                                                                .visible,
                                                            style: pw.TextStyle(
                                                                fontSize: 15,
                                                                font: font1),
                                                          ),
                                                        ]),
                                                        pw.TableRow(children: [
                                                          pw.Text(
                                                            vartaxrate,
                                                            maxLines: 10,
                                                            overflow: pw
                                                                .TextOverflow
                                                                .visible,
                                                            style: pw.TextStyle(
                                                                fontSize: 15,
                                                                font: font1),
                                                          ),
                                                          pw.Text(
                                                            individual[index]
                                                                    ['tax_rate']
                                                                .toString(),
                                                            maxLines: 10,
                                                            overflow: pw
                                                                .TextOverflow
                                                                .visible,
                                                            style: pw.TextStyle(
                                                                fontSize: 15,
                                                                font: font1),
                                                          ),
                                                        ]),
                                                      ]),
                                                  pw.Text(varstartrate,
                                                      textAlign:
                                                          pw.TextAlign.center,
                                                      style: pw.TextStyle(
                                                          fontSize: 20,
                                                          font: font1)),
                                                  pw.Divider(
                                                      color: PdfColors.black),
                                                  pw.Table(
                                                      border:
                                                          pw.TableBorder.all(),
                                                      children: [
                                                        pw.TableRow(children: [
                                                          pw.Text(
                                                            varhousetax,
                                                            style: pw.TextStyle(
                                                                fontSize: 15,
                                                                font: font1),
                                                          ),
                                                          pw.Text(
                                                            individual[index][
                                                                    'house_tax']
                                                                .toString(),
                                                            maxLines: 10,
                                                            overflow: pw
                                                                .TextOverflow
                                                                .visible,
                                                            style: pw.TextStyle(
                                                                fontSize: 15,
                                                                font: font1),
                                                          )
                                                        ]),
                                                        pw.TableRow(children: [
                                                          pw.Text(
                                                            varelectricitytax,
                                                            maxLines: 10,
                                                            overflow: pw
                                                                .TextOverflow
                                                                .visible,
                                                            style: pw.TextStyle(
                                                                fontSize: 15,
                                                                font: font1),
                                                          ),
                                                          pw.Text(
                                                            individual[index][
                                                                    'light_tax']
                                                                .toString(),
                                                            maxLines: 10,
                                                            overflow: pw
                                                                .TextOverflow
                                                                .visible,
                                                            style: pw.TextStyle(
                                                                fontSize: 15,
                                                                font: font1),
                                                          ),
                                                        ]),
                                                        pw.TableRow(children: [
                                                          pw.Text(
                                                            varhealthtax,
                                                            maxLines: 10,
                                                            overflow: pw
                                                                .TextOverflow
                                                                .visible,
                                                            style: pw.TextStyle(
                                                                fontSize: 15,
                                                                font: font1),
                                                          ),
                                                          pw.Text(
                                                            individual[index][
                                                                    'health_tax'] ??
                                                                '',
                                                            maxLines: 10,
                                                            overflow: pw
                                                                .TextOverflow
                                                                .visible,
                                                            style: pw.TextStyle(
                                                                fontSize: 15,
                                                                font: font1),
                                                          ),
                                                        ]),
                                                        pw.TableRow(children: [
                                                          pw.Text(
                                                            vartotaltax,
                                                            maxLines: 10,
                                                            overflow: pw
                                                                .TextOverflow
                                                                .visible,
                                                            style: pw.TextStyle(
                                                                fontSize: 15,
                                                                font: font1),
                                                          ),
                                                          pw.Text(
                                                            individual[index][
                                                                    'total_tax']
                                                                .toString(),
                                                            maxLines: 10,
                                                            overflow: pw
                                                                .TextOverflow
                                                                .visible,
                                                            style: pw.TextStyle(
                                                                fontSize: 15,
                                                                font: font1),
                                                          ),
                                                        ]),
                                                      ]),
                                                  pw.Text(varprevioustax,
                                                      textAlign:
                                                          pw.TextAlign.center,
                                                      style: pw.TextStyle(
                                                          fontSize: 20,
                                                          font: font1)),
                                                  pw.Divider(
                                                      color: PdfColors.black),
                                                  pw.Table(
                                                      border:
                                                          pw.TableBorder.all(),
                                                      children: [
                                                        pw.TableRow(children: [
                                                          pw.Text(
                                                            varhousetax,
                                                            style: pw.TextStyle(
                                                                fontSize: 15,
                                                                font: font1),
                                                          ),
                                                          pw.Text(
                                                            individual[index][
                                                                    'previous_house_tax']
                                                                .toString(),
                                                            maxLines: 10,
                                                            overflow: pw
                                                                .TextOverflow
                                                                .visible,
                                                            style: pw.TextStyle(
                                                                fontSize: 15,
                                                                font: font1),
                                                          )
                                                        ]),
                                                        pw.TableRow(children: [
                                                          pw.Text(
                                                            varelectricitytax,
                                                            maxLines: 10,
                                                            overflow: pw
                                                                .TextOverflow
                                                                .visible,
                                                            style: pw.TextStyle(
                                                                fontSize: 15,
                                                                font: font1),
                                                          ),
                                                          pw.Text(
                                                            individual[index][
                                                                    'previous_light_tax']
                                                                .toString(),
                                                            maxLines: 10,
                                                            overflow: pw
                                                                .TextOverflow
                                                                .visible,
                                                            style: pw.TextStyle(
                                                                fontSize: 15,
                                                                font: font1),
                                                          ),
                                                        ]),
                                                        pw.TableRow(children: [
                                                          pw.Text(
                                                            varhealthtax,
                                                            maxLines: 10,
                                                            overflow: pw
                                                                .TextOverflow
                                                                .visible,
                                                            style: pw.TextStyle(
                                                                fontSize: 15,
                                                                font: font1),
                                                          ),
                                                          pw.Text(
                                                            individual[index][
                                                                    'previous_health_tax'] ??
                                                                '',
                                                            maxLines: 10,
                                                            overflow: pw
                                                                .TextOverflow
                                                                .visible,
                                                            style: pw.TextStyle(
                                                                fontSize: 15,
                                                                font: font1),
                                                          ),
                                                        ]),
                                                        pw.TableRow(children: [
                                                          pw.Text(
                                                            vartotaltax,
                                                            maxLines: 10,
                                                            overflow: pw
                                                                .TextOverflow
                                                                .visible,
                                                            style: pw.TextStyle(
                                                                fontSize: 15,
                                                                font: font1),
                                                          ),
                                                          pw.Text(
                                                            individual[index][
                                                                    'previous_total']
                                                                .toString(),
                                                            maxLines: 10,
                                                            overflow: pw
                                                                .TextOverflow
                                                                .visible,
                                                            style: pw.TextStyle(
                                                                fontSize: 15,
                                                                font: font1),
                                                          ),
                                                        ]),
                                                        pw.TableRow(children: [
                                                          pw.Text(
                                                            varpenaltytotal,
                                                            maxLines: 10,
                                                            overflow: pw
                                                                .TextOverflow
                                                                .visible,
                                                            style: pw.TextStyle(
                                                                fontSize: 15,
                                                                font: font1),
                                                          ),
                                                          pw.Text(
                                                            individual[index][
                                                                    'penalty_total']
                                                                .toString(),
                                                            maxLines: 10,
                                                            overflow: pw
                                                                .TextOverflow
                                                                .visible,
                                                            style: pw.TextStyle(
                                                                fontSize: 15,
                                                                font: font1),
                                                          ),
                                                        ]),
                                                      ]),
                                                  pw.Text(vartotaltax,
                                                      textAlign:
                                                          pw.TextAlign.center,
                                                      style: pw.TextStyle(
                                                          fontSize: 20,
                                                          font: font1)),
                                                  /*pw.Divider(
                                                      color: PdfColors.black),*/
                                                  pw.Table(
                                                      border:
                                                          pw.TableBorder.all(),
                                                      children: [
                                                        pw.TableRow(children: [
                                                          pw.Text(
                                                            varhousetax,
                                                            style: pw.TextStyle(
                                                                fontSize: 15,
                                                                font: font1),
                                                          ),
                                                          pw.Text(
                                                            individual[index][
                                                                    'final_house_tax']
                                                                .toString(),
                                                            maxLines: 10,
                                                            overflow: pw
                                                                .TextOverflow
                                                                .visible,
                                                            style: pw.TextStyle(
                                                                fontSize: 15,
                                                                font: font1),
                                                          )
                                                        ]),
                                                        pw.TableRow(children: [
                                                          pw.Text(
                                                            varelectricitytax,
                                                            maxLines: 10,
                                                            overflow: pw
                                                                .TextOverflow
                                                                .visible,
                                                            style: pw.TextStyle(
                                                                fontSize: 15,
                                                                font: font1),
                                                          ),
                                                          pw.Text(
                                                            individual[index][
                                                                    'final_light_tax']
                                                                .toString(),
                                                            maxLines: 10,
                                                            overflow: pw
                                                                .TextOverflow
                                                                .visible,
                                                            style: pw.TextStyle(
                                                                fontSize: 15,
                                                                font: font1),
                                                          ),
                                                        ]),
                                                        pw.TableRow(children: [
                                                          pw.Text(
                                                            varhealthtax,
                                                            maxLines: 10,
                                                            overflow: pw
                                                                .TextOverflow
                                                                .visible,
                                                            style: pw.TextStyle(
                                                                fontSize: 15,
                                                                font: font1),
                                                          ),
                                                          pw.Text(
                                                            individual[index][
                                                                    'final_health_tax']
                                                                .toString(),
                                                            maxLines: 10,
                                                            overflow: pw
                                                                .TextOverflow
                                                                .visible,
                                                            style: pw.TextStyle(
                                                                fontSize: 15,
                                                                font: font1),
                                                          ),
                                                        ]),
                                                        pw.TableRow(children: [
                                                          pw.Text(
                                                            vartotaltax,
                                                            maxLines: 10,
                                                            overflow: pw
                                                                .TextOverflow
                                                                .visible,
                                                            style: pw.TextStyle(
                                                                fontSize: 15,
                                                                font: font1),
                                                          ),
                                                          pw.Text(
                                                            individual[index][
                                                                    'final_total']
                                                                .toString(),
                                                            maxLines: 10,
                                                            overflow: pw
                                                                .TextOverflow
                                                                .visible,
                                                            style: pw.TextStyle(
                                                                fontSize: 15,
                                                                font: font1),
                                                          ),
                                                        ]),
                                                      ]),
                                                ]),
                                                decoration: pw.BoxDecoration(
                                                    border: pw.Border.all(
                                                        width: 1)))
                                          ],
                                        ));

                                        DateTime now = DateTime.now();

                                        String convertedDateTime =
                                            "${now.year.toString()}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}${now.hour.toString()}-${now.minute.toString()}-${now.second.toString()}";

                                        var dpath = await ExtStorage
                                            .getExternalStoragePublicDirectory(
                                                ExtStorage.DIRECTORY_DOWNLOADS);

                                        var file = File(
                                            '$dpath/housetax$convertedDateTime.pdf');

                                        file2 = file;

                                        await file
                                            .writeAsBytes(await pdf.save());
                                        await _demoNotification();
                                      },
                                      padding: EdgeInsets.all(0),
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
                                                .translate('makeareceipt'),
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.white),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                    ),
                                  ),

//syvey year
                          ],
                        ),
                      ),
                    );
                  })
              : Center(
                  child: Theme(
                      data: Theme.of(context)
                          .copyWith(accentColor: Color(0xff5f259e)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Visibility(
                              visible: _center,
                              child: CircularProgressIndicator(
                                color: Color(0xff5f259e),
                              )),
                          Visibility(
                              visible: _text,
                              child: Text(
                                AppLocalization.of(context)!
                                    .translate('informationnotavailable'),
                              )),
                        ],
                      ))),
        ),
      ),
    );
  }

  //remove house popup
  void _removehouse() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            elevation: 0,
            content: Text(
                AppLocalization.of(context)!
                    .translate('areyousureyouwanttosubtractthehouse'),
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
                  onPressed: () async {
                    var data = {
                      "computer_id": widget.compid1,
                    };

                    //write api code here
                    var insurl =
                        'https://gramseva.in/api/customer/delete_house';

                    var response = await http.post(
                      Uri.parse(insurl),
                      body: data,
                      headers: {
                        "Authorization": "Bearer $token1",
                      },
                    );

                    if (response.statusCode == 401) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Color(0xff5f259e),
                          content: Text(
                            AppLocalization.of(context)!
                                .translate('thecomputernumberaboveisinvalid'),
                          )));
                      Navigator.pop(context);
                    } else if (response.statusCode == 200) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Color(0xff5f259e),
                          content: Text(
                            AppLocalization.of(context)!.translate(
                                'thehousehasbeensuccessfullydeducted'),
                          )));
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DashboardPage()));
                    }
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

  Future<void> initPlatformState() async {
    String platformVersion;

    try {
      platformVersion =
          await Safexpay.platformVersion ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Future<void> onInitiatePaymentFailure(
      String orderID,
      String transactionID,
      String paymentID,
      String paymentStatus,
      String date,
      String time,
      String paymode,
      String amount,
      String udf1,
      String udf2,
      String udf3,
      String udf4,
      String udf5) async {
    var transdata = {
      "customer_id": widget.custid1,
      "computer_id": widget.compid1,
      "order_id": orderID,
      "transaction_id": transactionID,
      "payment_id": paymentID,
      "pay_status": paymentStatus,
      "date": date,
      "time": time,
      "pay_mode": paymode,
      "cust_name": custname,
      "gp_id": widget.gpid2,
      "amount": amount,
      "contact": username1,
      "email": email,
    };

    var transurl = 'https://gramseva.in/api/customer/post_online_details';
    var transresponse = await http.post(
      Uri.parse(transurl),
      body: transdata,
      headers: {
        "Authorization": "Bearer $token1",
      },
    );

    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => PaymentFailedPage()));
  }

  @override
  void onPaymentCancelled() {
    final snackBar = SnackBar(
        content: Text(
      AppLocalization.of(context)!.translate('paymentcancelled'),
    ));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    Navigator.of(context);
  }

  @override
  Future<void> onPaymentComplete(
      String orderID,
      String transactionID,
      String paymentID,
      String paymentStatus,
      String date,
      String time,
      String paymode,
      String amount,
      String udf1,
      String udf2,
      String udf3,
      String udf4,
      String udf5) async {
    var transdata1 = {
      "customer_id": widget.custid1,
      "computer_id": udf1,
      "order_id": orderID,
      "transaction_id": transactionID,
      "payment_id": paymentID,
      "pay_status": paymentStatus,
      "date": date,
      "time": time,
      "pay_mode": paymode,
      "cust_name": custname,
      "gp_id": widget.gpid2,
      "amount": amount,
      "contact": username1,
      "email": email,
    };

    var transurl = 'https://gramseva.in/api/customer/post_online_details';
    var transresponse = await http.post(
      Uri.parse(transurl),
      body: transdata1,
      headers: {
        "Authorization": "Bearer $token1",
      },
    );

    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => PaymentSuccessPage()));
  }
}
