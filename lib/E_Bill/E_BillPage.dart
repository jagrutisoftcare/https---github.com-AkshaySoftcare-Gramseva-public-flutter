import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:tax_app/language/app_localization.dart';

class EBillPage extends StatefulWidget {
  const EBillPage({Key? key}) : super(key: key);

  @override
  _EBillPageState createState() => _EBillPageState();
}

class _EBillPageState extends State<EBillPage> {
  Future<void> secureScreen() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  @override
  void initState() {
    secureScreen();
    super.initState();
  }

  @override
  void dispose() async {
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
          AppLocalization.of(context)!.translate('electricitybill'),
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
        ),
      ),
      body: SafeArea(
        child: Center(
            child: Text(
                AppLocalization.of(context)!.translate('electricitybill'))),
      ),
    );
  }
}
