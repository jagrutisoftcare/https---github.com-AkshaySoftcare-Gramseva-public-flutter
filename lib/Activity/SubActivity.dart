import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:carousel_pro/carousel_pro.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tax_app/language/app_localization.dart';

// ignore: must_be_immutable
class SubActivityPage extends StatefulWidget {
  String id;
  // ignore: non_constant_identifier_names
  String gp_id;
  SubActivityPage(this.id, this.gp_id);

  @override
  _SubActivityState createState() => _SubActivityState();
}

class _SubActivityState extends State<SubActivityPage> {
  late SharedPreferences preferences;
  late Future futureAlbum;
  var username1;
  var token1;
  var gpid1;
  var gpname1;
  bool _center1 = true;
  bool _text1 = false;
  List datalist = [];
  List imglist = [];

  List slider = [];

  Future _getSlider() async {
    preferences = await SharedPreferences.getInstance();
    username1 = preferences.getString('username');
    token1 = preferences.getString('token');
    gpid1 = preferences.getString('gpid');
    gpname1 = preferences.getString('gpname');

    var response = await Dio().get(
        'https://gramseva.in/api/customer/showactivity?grampanchayat_id=' +
            widget.gp_id +
            "&id=" +
            widget.id,
        options: Options(headers: {"Authorization": "Bearer $token1"}));

    var displayFood = response.data['data']['images'];

    slider.clear();
    for (var u in displayFood) {
      slider.add(NetworkImage(u["image"]));
    }
    return slider;
  }

  getsubactivityList() async {
    preferences = await SharedPreferences.getInstance();
    username1 = preferences.getString('username');
    token1 = preferences.getString('token');
    gpid1 = preferences.getString('gpid');
    gpname1 = preferences.getString('gpname');

    var response1 = await Dio().get(
        'https://gramseva.in/api/customer/showactivity?grampanchayat_id=' +
            widget.gp_id +
            "&id=" +
            widget.id,
        options: Options(headers: {"Authorization": "Bearer $token1"}));

    var subactivitylist = response1.data['data'];
    List newlist = [];
    newlist.add(subactivitylist);

    return newlist;
  }

  Future fetchAlbum() async {
    preferences = await SharedPreferences.getInstance();
    username1 = preferences.getString('username');
    token1 = preferences.getString('token');
    gpid1 = preferences.getString('gpid');
    gpname1 = preferences.getString('gpname');
    var response1 = await Dio().get(
        'https://gramseva.in/api/customer/showactivity?grampanchayat_id=' +
            widget.gp_id +
            "&id=" +
            widget.id,
        options: Options(headers: {"Authorization": "Bearer $token1"}));

    if (response1.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.

      return response1.data;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  List<dynamic> slidernew = [
    AssetImage('images/load.jpg'),
    AssetImage('images/load.jpg'),
    AssetImage('images/load.jpg'),
    AssetImage('images/load.jpg'),
    AssetImage('images/load.jpg'),
  ];

  @override
  void initState() {
    _checkConnectivity();

    futureAlbum = fetchAlbum();
    super.initState();

    getsubactivityList().then((data) {
      setState(() {
        datalist = data;
      });
    });
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
        ),
        body: SafeArea(
          child: ListView(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            children: [
              FutureBuilder(
                future: _getSlider(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: SizedBox(
                          height: 220,
                          child: Carousel(
                              boxFit: BoxFit.fill,
                              autoplay: true,
                              animationCurve: Curves.easeInToLinear,
                              animationDuration: Duration(milliseconds: 100),
                              dotSize: 4.0,
                              dotIncreasedColor: Color(0xff5f259e),
                              dotBgColor: Colors.transparent,
                              dotPosition: DotPosition.bottomCenter,
                              dotVerticalPadding: 9.0,
                              showIndicator: true,
                              noRadiusForIndicator: true,
                              indicatorBgPadding: 4.0,
                              images: snapshot.data),
                        ));
                  }

                  return Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: SizedBox(
                        height: 220,
                        child: Carousel(
                            boxFit: BoxFit.cover,
                            autoplay: true,
                            animationCurve: Curves.easeInToLinear,
                            animationDuration: Duration(milliseconds: 100),
                            dotSize: 5.0,
                            dotIncreasedColor: Color(0xff5f259e),
                            dotBgColor: Colors.transparent,
                            dotPosition: DotPosition.bottomCenter,
                            dotVerticalPadding: 9.0,
                            showIndicator: true,
                            noRadiusForIndicator: true,
                            indicatorBgPadding: 7.0,
                            images: slidernew),
                      ));
                },
              ),
              datalist.length > 0
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: datalist.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  datalist[index]['activity_on'].toString() +
                                      " "
                                          "by" +
                                      " " +
                                      datalist[index]['activity_by'].toString(),
                                  textAlign: TextAlign.left,
                                  maxLines: 10,
                                  overflow: TextOverflow.visible,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  datalist[index]['name'].toString(),
                                  textAlign: TextAlign.left,
                                  maxLines: 10,
                                  overflow: TextOverflow.visible,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                datalist[index]['description'].toString(),
                                textAlign: TextAlign.left,
                                maxLines: 10,
                                overflow: TextOverflow.visible,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                            ],
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
                                  visible: _center1,
                                  child: CircularProgressIndicator(
                                    color: Color(0xff5f259e),
                                  )),
                              Visibility(
                                  visible: _text1,
                                  child: Text(
                                    AppLocalization.of(context)!
                                        .translate('informationnotavailable'),
                                  )),
                            ],
                          )))
            ],
          ),
        ));
  }
}
