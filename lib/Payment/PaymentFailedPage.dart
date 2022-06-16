import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:tax_app/language/app_localization.dart';

class PaymentFailedPage extends StatefulWidget {
  @override
  _PaymentFailedPageState createState() => _PaymentFailedPageState();
}

class _PaymentFailedPageState extends State<PaymentFailedPage>
    with TickerProviderStateMixin {
  late AnimationController scaleController = AnimationController(
      duration: const Duration(milliseconds: 400), vsync: this);
  late Animation<double> scaleAnimation =
      CurvedAnimation(parent: scaleController, curve: Curves.easeIn);
  late AnimationController checkController = AnimationController(
      duration: const Duration(milliseconds: 400), vsync: this);
  late Animation<double> checkAnimation =
      CurvedAnimation(parent: checkController, curve: Curves.linear);

  Future<void> secureScreen() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  @override
  void initState() {
    secureScreen();
    super.initState();
    scaleController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        checkController.forward();
      }
    });
    scaleController.forward();
  }

  @override
  Future<void> dispose() async {
    scaleController.dispose();
    checkController.dispose();
    super.dispose();
    await FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
  }

  @override
  Widget build(BuildContext context) {
    double circleSize = 130;
    double iconSize = 90;

    return Scaffold(
      backgroundColor: Color(0xffefe6f7),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 160,
            child: ScaleTransition(
              scale: scaleAnimation,
              child: Container(
                height: circleSize,
                width: circleSize,
                decoration: BoxDecoration(
                  color: Color(0xff5f259e),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          Positioned(
            child: Text(
              AppLocalization.of(context)!.translate('paymentfailed'),
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
            ),
            top: 320,
          ),
          Positioned(
            top: 180,
            child: SizeTransition(
              sizeFactor: checkAnimation,
              axis: Axis.horizontal,
              axisAlignment: -1,
              child: Center(
                child: Icon(Icons.close, color: Colors.white, size: iconSize),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
