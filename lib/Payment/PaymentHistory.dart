import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tax_app/language/app_localization.dart';

class PaymentHistoryPage extends StatefulWidget {
  const PaymentHistoryPage({Key? key}) : super(key: key);

  @override
  _PaymentHistoryPageState createState() => _PaymentHistoryPageState();
}

class _PaymentHistoryPageState extends State<PaymentHistoryPage> {
  late SharedPreferences preferences;
  bool _center = true;
  bool _text = false;
  bool _center1 = true;
  bool _text1 = false;
  var username1;
  var token1;
  var gpid1;
  var gpname1;

  var gname;
  List compiddatalist = [];
  List compiddatalistbyid = [];

  List gpnamedata2 = [];
  var selectedgpdata1;

  read() async {
    preferences = await SharedPreferences.getInstance();
    username1 = preferences.getString('username');
    token1 = preferences.getString('token');
    gpid1 = preferences.getString('gpid');

    gpname1 = preferences.getString('gpname');
  }

//get computer id list
  getPayList() async {
    preferences = await SharedPreferences.getInstance();
    username1 = preferences.getString('username');
    token1 = preferences.getString('token');
    gpid1 = preferences.getString('gpid');

    var response = await Dio().get(
        'https://gramseva.in/api/customer/getall_online_details?gp_id=' + gpid1,
        options: Options(headers: {"Authorization": "Bearer $token1"}));

    var compidlist = response.data;

    return compidlist;
  }

  //get list by gpid

  getCompIdListbyid() async {
    preferences = await SharedPreferences.getInstance();
    username1 = preferences.getString('username');
    token1 = preferences.getString('token');
    gpid1 = preferences.getString('gpid');

    var response = await Dio().get(
        'https://gramseva.in/api/customer/getall_online_details?gp_id=' +
            selectedgpdata1,
        options: Options(headers: {"Authorization": "Bearer $token1"}));
    //var paymentstetus = response.data.payment
    var compidlistbyid = response.data;

    return compidlistbyid;
  }

  Future<void> secureScreen() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  @override
  void initState() {
    secureScreen();
    read();

    // read();
    _checkConnectivity();

    getPayList().then((data) {
      setState(() {
        compiddatalist = data;

        /*if (compiddatalist.length == 0) {
          setState(() {
            _center = false;
            _text = true;
          });
        }*/
      });
    });
    getgpdata().then((data) {
      setState(() {
        gpnamedata2 = data;
      });
    });
    super.initState();
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    await FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
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

  getgpdata() async {
    preferences = await SharedPreferences.getInstance();
    username1 = preferences.getString('username');
    token1 = preferences.getString('token');
    gpid1 = preferences.getString('gpid');
    var response1 = await Dio().get('https://gramseva.in/api/customer/get_gp',
        options: Options(headers: {"Authorization": "Bearer $token1"}));

    var idata = response1.data['data'];

    return idata;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffefe6f7),
        appBar: AppBar(
          elevation: 2,
          backgroundColor: Color(0xff5f259e),
          title: Text(
            AppLocalization.of(context)!
                .translate('homesteadpaymentinformation'),
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          actions: [
            DropdownButton(
              iconEnabledColor: Colors.white,
              items: gpnamedata2.map((item) {
                return DropdownMenuItem(
                  child: Text(
                    item['gp_name'],
                    style: TextStyle(),
                  ),
                  value: item['gp_id'],
                );
              }).toList(),
              onChanged: (selectedvalue1) {
                setState(() {
                  selectedgpdata1 = selectedvalue1;

                  getCompIdListbyid().then((data) {
                    setState(() {
                      compiddatalistbyid = data;

                      if (compiddatalistbyid.length == 0) {
                        setState(() {
                          _center1 = false;
                          _text1 = true;
                        });
                      }
                    });
                  });
                });
              },
              dropdownColor: Color(0xff5f259e),
              //  value: selectedprabhag == ""
              value: selectedgpdata1,
              style: TextStyle(fontSize: 16.0, color: Colors.white),

              //? null
              //: selectedprabhag,
              hint: Text(gpname1 ?? '',
                  style: TextStyle(fontSize: 15, color: Colors.white)),

              icon: Icon(Icons.arrow_drop_down),
              iconSize: 30,
            ),
          ],
        ),
        body: SafeArea(
            child: selectedgpdata1 == null
                ? Padding(
                    padding: EdgeInsets.all(8.0),
                    child: compiddatalist.length > 0
                        ? ListView.builder(
                            itemCount: compiddatalist.length,
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              var varpaystetus =
                                  compiddatalist[index]['pay_status'];
                              // var varpaystetus1 = varpaystetus.substring(
                              //     0, varpaystetus.indexOf('~'));
                              return Container(
                                  margin: const EdgeInsets.all(4.0),
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    color: Color(0xffffffff),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                  ),
                                  child: ListTile(
                                    trailing: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: varpaystetus == "Successful"
                                          ? Text(
                                              "₹" +
                                                  compiddatalist[index]
                                                      ['amount'] +
                                                  "\n" +
                                                  compiddatalist[index]
                                                      ['pay_mode'] +
                                                  "\n" +
                                                  varpaystetus,
                                              maxLines: 20,
                                              overflow: TextOverflow.visible,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                  color: CupertinoColors.black),
                                            )
                                          : Text(
                                              "₹" +
                                                  compiddatalist[index]
                                                      ['amount'] +
                                                  "\n" +
                                                  compiddatalist[index]
                                                      ['pay_mode'] +
                                                  "\n" +
                                                  varpaystetus +
                                                  "         ",
                                              maxLines: 20,
                                              overflow: TextOverflow.visible,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                  color: CupertinoColors.black),
                                            ),
                                    ),
                                    title: Text(
                                      AppLocalization.of(context)!
                                              .translate('computerid') +
                                          ":" +
                                          compiddatalist[index]['computer_id'],
                                      maxLines: 20,
                                      overflow: TextOverflow.visible,
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500,
                                          color: CupertinoColors.black),
                                    ),
                                    subtitle: Text(
                                      AppLocalization.of(context)!
                                              .translate('payid') +
                                          ":" +
                                          compiddatalist[index]['payment_id'] +
                                          "\n" +
                                          "Transaction-Id:" +
                                          compiddatalist[index]
                                              ['transaction_id'] +
                                          "\n" +
                                          compiddatalist[index]['date'] +
                                          compiddatalist[index]['time'],
                                      maxLines: 20,
                                      overflow: TextOverflow.visible,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: CupertinoColors.black),
                                    ),
                                  ));
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
                                              .translate(
                                                  'informationnotavailable'),
                                        )),
                                  ],
                                ))))
                : Padding(
                    padding: EdgeInsets.all(8.0),
                    child: compiddatalistbyid.length > 0
                        ? ListView.builder(
                            itemCount: compiddatalistbyid.length,
                            itemBuilder: (BuildContext context, int index) {
                              var varpaystetus =
                                  compiddatalistbyid[index]['pay_status'];
                              // var varpaystetus1 = varpaystetus.substring(
                              //     0, varpaystetus.indexOf('~'));
                              return Container(
                                  margin: const EdgeInsets.all(4.0),
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    color: Color(0xffffffff),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                  ),
                                  child: ListTile(
                                    trailing: varpaystetus == "Successful"
                                        ? Text(
                                            "₹" +
                                                compiddatalistbyid[index]
                                                    ['amount'] +
                                                "\n" +
                                                compiddatalistbyid[index]
                                                    ['pay_mode'] +
                                                "\n" +
                                                varpaystetus,
                                            maxLines: 20,
                                            overflow: TextOverflow.visible,
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                color: CupertinoColors.black),
                                          )
                                        : Text(
                                            "₹" +
                                                compiddatalistbyid[index]
                                                    ['amount'] +
                                                "\n" +
                                                compiddatalistbyid[index]
                                                    ['pay_mode'] +
                                                "\n" +
                                                varpaystetus +
                                                "        ",
                                            maxLines: 20,
                                            overflow: TextOverflow.visible,
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                color: CupertinoColors.black),
                                          ),
                                    title: Text(
                                      AppLocalization.of(context)!
                                              .translate('computerid') +
                                          ":" +
                                          compiddatalistbyid[index]
                                              ['computer_id'],
                                      maxLines: 20,
                                      overflow: TextOverflow.visible,
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500,
                                          color: CupertinoColors.black),
                                    ),
                                    subtitle: Text(
                                      AppLocalization.of(context)!
                                              .translate('payid') +
                                          ":" +
                                          compiddatalistbyid[index]
                                              ['payment_id'] +
                                          "\n" +
                                          "Transaction-Id:" +
                                          compiddatalistbyid[index]
                                              ['transaction_id'] +
                                          "\n" +
                                          compiddatalistbyid[index]['date'] +
                                          compiddatalistbyid[index]['time'],
                                      maxLines: 20,
                                      overflow: TextOverflow.visible,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: CupertinoColors.black),
                                    ),
                                  ));
                            })
                        : Center(
                            child: Theme(
                                data: Theme.of(context)
                                    .copyWith(accentColor: Color(0xff5f259e)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Visibility(
                                        visible: _center1,
                                        child: CircularProgressIndicator(
                                          color: Color(0xff5f259e),
                                        )),
                                    Visibility(
                                        visible: _text1,
                                        child: Text(
                                          AppLocalization.of(context)!
                                              .translate(
                                                  'informationnotavailable'),
                                        )),
                                  ],
                                ))))));
  }
}
