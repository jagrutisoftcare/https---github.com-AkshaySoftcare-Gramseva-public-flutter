import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tax_app/language/app_localization.dart';

import 'AddHouse.dart';
import 'ViewTax.dart';

class HouseTaxPage extends StatefulWidget {
  const HouseTaxPage({Key? key}) : super(key: key);

  @override
  _HouseTaxPageState createState() => _HouseTaxPageState();
}

class _HouseTaxPageState extends State<HouseTaxPage> {
  Future<void> secureScreen() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  late SharedPreferences preferences;
  bool _center = true;
  bool _text = false;
  var username1;
  var token1;
  var gpid1;

  var gname;
  List compiddatalist = [];
  List compiddatalistbyid = [];

  List gpnamedata2 = [];
  var selectedgpdata;

  read() async {
    preferences = await SharedPreferences.getInstance();
    username1 = preferences.getString('username');
    token1 = preferences.getString('token');
    gpid1 = preferences.getString('gpid');
  }

//get computer id list
  getCompIdList() async {
    preferences = await SharedPreferences.getInstance();
    username1 = preferences.getString('username');
    token1 = preferences.getString('token');
    gpid1 = preferences.getString('gpid');

    var response = await Dio().get(
        'https://gramseva.in/api/customer/get_list?grampanchayat_id=' + gpid1,
        options: Options(headers: {"Authorization": "Bearer $token1"}));

    var compidlist = response.data['result'];

    gname = response.data['result'][0]['grampanchayat_name'];
    return compidlist;
  }

  //get list by gpid
  getCompIdListbyid() async {
    preferences = await SharedPreferences.getInstance();
    username1 = preferences.getString('username');
    token1 = preferences.getString('token');
    gpid1 = preferences.getString('gpid');

    var response = await Dio().get(
        'https://gramseva.in/api/customer/get_list?grampanchayat_id=' +
            selectedgpdata,
        options: Options(headers: {"Authorization": "Bearer $token1"}));

    var compidlistbyid = response.data['result'];

    return compidlistbyid;
  }

  @override
  void initState() {
    secureScreen();
    read();
    _checkConnectivity();

    getCompIdList().then((data) {
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
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Color(0xff5f259e),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => AddHousePage()));
        },
        label: Row(children: [
          Icon(Icons.add),
          Text(
            AppLocalization.of(context)!.translate('registerhome'),
          )
        ]),
      ),
      backgroundColor: Color(0xffefe6f7),
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Color(0xff5f259e),
        title: Text(
          AppLocalization.of(context)!.translate('homestead'),
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
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
                selectedgpdata = selectedvalue1;

                getCompIdListbyid().then((data) {
                  setState(() {
                    compiddatalistbyid = data;
                    if (compiddatalistbyid.length == 0) {
                      setState(() {
                        _center = false;
                        _text = true;
                      });
                    }
                  });
                });
              });
            },
            dropdownColor: Color(0xff5f259e),
            //  value: selectedprabhag == ""
            value: selectedgpdata,
            style: TextStyle(fontSize: 16.0, color: Colors.white),

            //? null
            //: selectedprabhag,
            hint: Text(gname == null ? "" : gname,
                style: TextStyle(fontSize: 15, color: Colors.white)),

            icon: Icon(Icons.arrow_drop_down),
            iconSize: 30,
          ),
          IconButton(
              onPressed: () {
                getCompIdList().then((data) {
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
              },
              icon: Icon(Icons.refresh_outlined)),
        ],
      ),
      body: SafeArea(
          child: selectedgpdata == null
              ? Padding(
                  padding: EdgeInsets.all(8.0),
                  child: compiddatalist.length > 0
                      ? ListView.builder(
                          itemCount: compiddatalist.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              margin: const EdgeInsets.all(4.0),
                              padding: const EdgeInsets.all(4.0),
                              decoration: BoxDecoration(
                                color: Color(0xffffffff),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),

                              ///color: Color(0xffffffff),
                              /* shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),*/
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: ListTile(
                                  title: Text(
                                    AppLocalization.of(context)!
                                            .translate('computernumber') +
                                        ':' +
                                        compiddatalist[index]['computer_id'],
                                    maxLines: 20,
                                    overflow: TextOverflow.visible,
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w300,
                                        color: CupertinoColors.black),
                                  ),
                                  subtitle: Text(
                                    AppLocalization.of(context)!
                                            .translate('flatnumber') +
                                        ':' +
                                        compiddatalist[index]['property_no'] +
                                        "\n" +
                                        AppLocalization.of(context)!
                                            .translate('nameofthevillage') +
                                        ':' +
                                        compiddatalist[index]['village_name'] +
                                        "\n" +
                                        AppLocalization.of(context)!
                                            .translate('grampanchayat') +
                                        ':' +
                                        compiddatalist[index]
                                            ['grampanchayat_name'],
                                    maxLines: 20,
                                    overflow: TextOverflow.visible,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black54),
                                  ),
                                  trailing: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ViewHouseTax(
                                                  compiddatalist[index]
                                                      ['computer_id'],
                                                  compiddatalist[index]
                                                      ['customer_id'],
                                                  compiddatalist[index]
                                                      ['gp_id'],
                                                  compiddatalist[index]
                                                      ['grampanchayat_name'])));
                                    },
                                    child: Container(
                                      child: Column(
                                        children: [
                                          compiddatalist[index]
                                                      ['payment_status'] ==
                                                  0
                                              ? Text(
                                                  AppLocalization.of(context)!
                                                      .translate('pending'),
                                                  style: TextStyle(
                                                      color: Color(0xff5f259e)),
                                                )
                                              : Text(
                                                  AppLocalization.of(context)!
                                                      .translate('paid'),
                                                  style: TextStyle(
                                                      color: Color(0xff5f259e)),
                                                ),
                                          Icon(
                                            Icons.remove_red_eye_outlined,
                                            color: Color(0xff5f259e),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
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
                                        AppLocalization.of(context)!.translate(
                                            'informationnotavailable'),
                                      )),
                                ],
                              ))),
                )
              : Padding(
                  padding: EdgeInsets.all(8.0),
                  child: compiddatalistbyid.length > 0
                      ? ListView.builder(
                          itemCount: compiddatalistbyid.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              margin: const EdgeInsets.all(4.0),
                              padding: const EdgeInsets.all(4.0),
                              decoration: BoxDecoration(
                                color: Color(0xffffffff),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),

                              ///color: Color(0xffffffff),
                              /* shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),*/
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: ListTile(
                                  title: Text(
                                    AppLocalization.of(context)!
                                            .translate('computernumber') +
                                        ':' +
                                        compiddatalistbyid[index]
                                            ['computer_id'],
                                    maxLines: 20,
                                    overflow: TextOverflow.visible,
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w300,
                                        color: CupertinoColors.black),
                                  ),
                                  subtitle: Text(
                                    AppLocalization.of(context)!
                                            .translate('flatnumber') +
                                        ":" +
                                        compiddatalistbyid[index]
                                            ['property_no'] +
                                        "\n" +
                                        AppLocalization.of(context)!
                                            .translate('nameofthevillage') +
                                        ":" +
                                        compiddatalistbyid[index]
                                            ['village_name'] +
                                        "\n" +
                                        AppLocalization.of(context)!.translate(
                                            'nameofthegrampanchayat') +
                                        ':' +
                                        compiddatalistbyid[index]
                                            ['grampanchayat_name'],
                                    maxLines: 20,
                                    overflow: TextOverflow.visible,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black54),
                                  ),
                                  trailing: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ViewHouseTax(
                                                  compiddatalistbyid[index]
                                                      ['computer_id'],
                                                  compiddatalistbyid[index]
                                                      ['customer_id'],
                                                  compiddatalistbyid[index]
                                                      ['gp_id'],
                                                  compiddatalistbyid[index]
                                                      ['grampanchayat_name'])));
                                    },
                                    child: Container(
                                      child: Column(
                                        children: [
                                          compiddatalistbyid[index]
                                                      ['payment_status'] ==
                                                  0
                                              ? Text(
                                                  AppLocalization.of(context)!
                                                      .translate('pending'),
                                                  style: TextStyle(
                                                      color: Color(0xff5f259e)))
                                              : Text(
                                                  AppLocalization.of(context)!
                                                      .translate('paid'),
                                                  style: TextStyle(
                                                      color:
                                                          Color(0xff5f259e))),
                                          Icon(Icons.remove_red_eye_outlined,
                                              color: Color(0xff5f259e))
                                        ],
                                      ),
                                    ),
                                  ),
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
                                        AppLocalization.of(context)!.translate(
                                            'informationnotavailable'),
                                      )),
                                ],
                              ))),
                )),
    );
  }
}
