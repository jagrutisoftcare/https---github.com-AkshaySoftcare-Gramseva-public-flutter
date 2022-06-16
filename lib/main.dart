import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Home/Dashboard.dart';
import 'Home/LoginPage.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';

import 'language/app_localization.dart';
import 'language/current_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'language/app_localization.dart';
import 'language/current_data.dart';

Future<void> secureScreen() async {
  await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final CurrentData currentData = CurrentData();
  await Firebase.initializeApp();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var myusername = preferences.getString('username');

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(
    ChangeNotifierProvider(
      create: (context) => currentData,
      child: Consumer<CurrentData>(
        builder: (context, provider, child) => MaterialApp(
          title: 'ग्रामसेवा',
          locale: Provider.of<CurrentData>(context).locale,
          debugShowCheckedModeBanner: false,
          home: myusername == null ? LoginPage() : DashboardPage(),
          localizationsDelegates: const [
            AppLocalizationDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('mr'),
            Locale('en'),
          ],
        ),
      ),
    ),
  );
}
