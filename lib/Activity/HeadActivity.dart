import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tax_app/language/app_localization.dart';

import 'SubActivity.dart';

class HeadActivity extends StatefulWidget {
  const HeadActivity({Key? key}) : super(key: key);

  @override
  _HeadActivityState createState() => _HeadActivityState();
}

class _HeadActivityState extends State<HeadActivity> {
  late SharedPreferences preferences;
  bool _center = true;
  bool _text = false;
  var username1;
  var token1;
  var gpid1;
  var gpname1;

  var gname;
  List activitydatalist = [];
  List activitydatalistbyid = [];

  List gpnamedata2 = [];
  var selectedgpdata;

  read() async {
    preferences = await SharedPreferences.getInstance();
    username1 = preferences.getString('username');
    token1 = preferences.getString('token');
    gpid1 = preferences.getString('gpid');
    gpname1 = preferences.getString('gpname');
  }

//get computer id list
  getactivityList() async {
    preferences = await SharedPreferences.getInstance();
    username1 = preferences.getString('username');
    token1 = preferences.getString('token');
    gpid1 = preferences.getString('gpid');

    var response = await Dio().get(
        'https://gramseva.in/api/customer/activityList?grampanchayat_id=' +
            gpid1,
        options: Options(headers: {"Authorization": "Bearer $token1"}));

    var activitylist = response.data['data1'];

    return activitylist;
  }

  //get list by gpid

  getactivityListbyid() async {
    preferences = await SharedPreferences.getInstance();
    username1 = preferences.getString('username');
    token1 = preferences.getString('token');
    gpid1 = preferences.getString('gpid');

    var response = await Dio().get(
        'https://gramseva.in/api/customer/activityList?grampanchayat_id=' +
            selectedgpdata,
        options: Options(headers: {"Authorization": "Bearer $token1"}));

    var activitylistbyid = response.data['data1'];

    return activitylistbyid;
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
  void initState() {
    read();

    // read();
    _checkConnectivity();

    getactivityList().then((data) {
      setState(() {
        activitydatalist = data;

        if (activitydatalist.length == 0) {
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
  void dispose() {
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffefe6f7),
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Color(0xff5f259e),
        title: Text(
          AppLocalization.of(context)!.translate('undertaking'),
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

                getactivityListbyid().then((data) {
                  setState(() {
                    activitydatalistbyid = data;

                    if (activitydatalistbyid.length == 0) {
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
            hint: Text(gpname1 == null ? "" : gpname1,
                style: TextStyle(fontSize: 15, color: Colors.white)),

            icon: Icon(Icons.arrow_drop_down),
            iconSize: 30,
          ),
        ],
      ),
      body: SafeArea(
          child: selectedgpdata == null
              ? Padding(
                  padding: EdgeInsets.all(2.0),
                  child: activitydatalist.length > 0
                      ? ListView.builder(
                          itemCount: activitydatalist.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  color: Colors.white,
                                  elevation: 2.0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0))),
                                  child: ListView(
                                    shrinkWrap: true,
                                    physics: ClampingScrollPhysics(),
                                    children: [
                                      Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 150,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              fit: BoxFit.fill,
                                              image: NetworkImage(
                                                  activitydatalist[index]
                                                          ['cover_image']
                                                      .toString()),
                                            ),
                                          )),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          activitydatalist[index]['activity_on']
                                                  .toString() +
                                              " "
                                                  "by" +
                                              " " +
                                              activitydatalist[index]
                                                      ['activity_by']
                                                  .toString(),
                                          textAlign: TextAlign.left,
                                          maxLines: 10,
                                          overflow: TextOverflow.visible,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 8,
                                            right: 8,
                                            bottom: 8,
                                            top: 2),
                                        child: Text(
                                          activitydatalist[index]['name']
                                              .toString(),
                                          maxLines: 20,
                                          overflow: TextOverflow.visible,
                                          style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 8,
                                            right: 8,
                                            bottom: 8,
                                            top: 2),
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        SubActivityPage(
                                                            activitydatalist[
                                                                    index]['id']
                                                                .toString(),
                                                            activitydatalist[
                                                                        index]
                                                                    ['gp_id']
                                                                .toString())));
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                AppLocalization.of(context)!
                                                    .translate('readon'),
                                                textAlign: TextAlign.end,
                                                style: TextStyle(
                                                    color: Color(0xff5f259e),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Icon(
                                                Icons.arrow_forward_outlined,
                                                color: Color(0xff5f259e),
                                                size: 18,
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  )),
                            );
                          })
                      : Center(
                          child: Theme(
                              data: Theme.of(context)
                                  // ignore: deprecated_member_use
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
                  padding: EdgeInsets.all(2.0),
                  child: activitydatalistbyid.length > 0
                      ? ListView.builder(
                          itemCount: activitydatalistbyid.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  color: Colors.white,
                                  elevation: 2.0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0))),
                                  child: ListView(
                                    shrinkWrap: true,
                                    physics: ClampingScrollPhysics(),
                                    children: [
                                      Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 150,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              fit: BoxFit.fill,
                                              image: NetworkImage(
                                                  activitydatalistbyid[index]
                                                          ['cover_image']
                                                      .toString()),
                                            ),
                                          )),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          activitydatalistbyid[index]
                                                      ['activity_on']
                                                  .toString() +
                                              " "
                                                  "by" +
                                              " " +
                                              activitydatalistbyid[index]
                                                      ['activity_by']
                                                  .toString(),
                                          textAlign: TextAlign.left,
                                          maxLines: 10,
                                          overflow: TextOverflow.visible,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 8,
                                            right: 8,
                                            bottom: 8,
                                            top: 2),
                                        child: Text(
                                          activitydatalistbyid[index]['name']
                                              .toString(),
                                          maxLines: 20,
                                          overflow: TextOverflow.visible,
                                          style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 8,
                                            right: 8,
                                            bottom: 8,
                                            top: 2),
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        SubActivityPage(
                                                            activitydatalistbyid[
                                                                    index]['id']
                                                                .toString(),
                                                            activitydatalistbyid[
                                                                        index]
                                                                    ['gp_id']
                                                                .toString())));
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                AppLocalization.of(context)!
                                                    .translate('readon'),
                                                textAlign: TextAlign.end,
                                                style: TextStyle(
                                                    color: Color(0xff5f259e),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Icon(
                                                Icons.arrow_forward_outlined,
                                                color: Color(0xff5f259e),
                                                size: 18,
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  )),
                            );
                          })
                      : Center(
                          child: Theme(
                              data: Theme.of(context)
                                  // ignore: deprecated_member_use
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
