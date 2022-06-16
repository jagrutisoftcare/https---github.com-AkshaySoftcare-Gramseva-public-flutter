import 'package:flutter/material.dart';
import 'package:tax_app/language/app_localization.dart';

class AddComplaintPage extends StatefulWidget {
  const AddComplaintPage({Key? key}) : super(key: key);

  @override
  _AddComplaintPageState createState() => _AddComplaintPageState();
}

class _AddComplaintPageState extends State<AddComplaintPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Color(0xff5f259e),
        title: Text(
          AppLocalization.of(context)!.translate('complaintregistration'),
          style: TextStyle(fontWeight: FontWeight.w200),
        ),
      ),
      body: SafeArea(
        child: Center(
            child: Text(
          AppLocalization.of(context)!.translate('complaintregistrationpage'),
        )),
      ),
    );
  }
}
