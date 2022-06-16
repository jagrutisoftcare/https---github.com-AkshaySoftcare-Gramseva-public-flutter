import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show SynchronousFuture;

class AppLocalization {
  AppLocalization(this.locale);

  final Locale locale;

  static AppLocalization? of(BuildContext context) {
    return Localizations.of<AppLocalization>(context, AppLocalization);
  }

  static final Map<String, Map<String, String>> _localizedValues = {
    'mr': {
      'gramseva': 'ग्रामसेवा',
      'undertaking': 'उपक्रम',
      'convenience': 'सुविधा',
      'homestead': 'घरपट्टी',
      'homesteadinformation': 'घरपट्टी माहिती',
      'mobilerecharge': 'मोबाईल रिचार्जे',
      'electricitybill': 'वीज बिल',
      'complaintregistration': 'तक्रार नोंदणी',
      'complaintregistrationpage': 'तक्रार नोंदणी पृष्ठ',
      'paymentinformation': 'देय माहिती',
      'areyousureyouwanttoquit': 'आपली खात्री आहे की आपण बाहेर पडू इच्छिता?',
      'no': 'नाही',
      'yes': 'होय',
      'newupdateavailable': 'नवीन अपडेट उपलब्ध',
      'thereisanewerversionofappavailablepleaseupdateitnow':
          'अँपची नवीन आवृत्ती उपलब्ध आहे कृपया ती आता अपडेट करा.',
      'updatenow': 'आता अद्ययावत करा',
      'later': 'नंतर',
      'checkinternetconnectivity': 'इंटरनेट काँनेक्टिव्हिटी तपासा!',
      'readon': 'पुढे वाचा',
      'informationnotavailable': 'माहिती उपलब्ध नाही!',
      'newusers': 'नवीन वापरकर्ते आहात?',
      'register': 'नोंदणी करा',
      'login': 'लॉग इन',
      'voicenumberrequired': 'ध्वनी क्रमांक आवश्यक!',
      'enterthecorrectsoundnumber': 'योग्य ध्वनी क्रमांक लिहा!',
      'voicenumber': 'ध्वनी क्रमांक',
      'passwordrequired': 'पासवर्ड आवश्यक!',
      'password': 'पासवर्ड',
      'userisinvalid': 'वापरकर्ता अवैध आहे!',
      'alreadyhaveusers': 'आधीपासून वापरकर्ते आहात?',
      'registration': 'नोंदणी',
      'registration1': 'नोंदणी (१)',
      'registration2': 'नोंदणी (२)',
      'registration3': 'नोंदणी (३)',
      'namerequired': 'नाव आवश्यक!',
      'name': 'नाव',
      'emailrequired': 'ई-मेल आवश्यक!',
      'writeavalidemail': 'योग्य ई-मेल लिहा!',
      'email': 'ई-मेल',
      'nameofgrampanchayatrequired': 'ग्रामपंचायतीचे नाव आवश्यक!',
      'nameofthegrampanchayat': 'ग्रामपंचायतीचे नाव',
      'computernumberrequired': 'संगणक क्रमांक आवश्यक!',
      'computernumber': 'संगणक क्रमांक',
      'computernumberisalreadyregistered': 'संगणक क्रमांक आधीच नोंदणीकृत आहे!',
      'voicenumberalreadyregistered': 'ध्वनी क्रमांक आधीच नोंदणीकृत आहे!',
      'computernumberandmobilenumberarealreadyregistered':
          'संगणक क्रमांक आणि ध्वनी क्रमांक आधीच नोंदणीकृत आहे!',
      'goahead': 'पुढे व्हा',
      'resendotp': 'ओटीपी पुन्हा पाठवा',
      'invalidotp': 'अवैध ओटीपी!',
      'passwordmustbenolessthancharacters': 'पासवर्ड ८ वर्णांपेक्षा कमी नसावा!',
      'enterthepasswordagain': 'पुन्हा पासवर्ड लिहा',
      'passworddoesnotmatch': 'पासवर्ड जुळत नाही',
      'registrationhasbeensuccessful': 'नोंदणी यशस्वीरीत्या झाली आहे!',
      'failedregistration': 'अयशस्वी नोंदणी!',
      'registerhome': 'घर नोंदणी करा',
      'entercomputernumber': 'संगणक क्रमांक लिहा!',
      'thecomputernumberaboveisinvalid': 'वरील संगणक क्रमांक अवैध आहे!',
      'thehousehasbeensuccessfullyconnected': 'घर यशस्वीरीत्या जोडले आहे!',
      'flatnumber': 'सदनिका क्रमांक',
      'flattype': 'सदनिका प्रकार',
      'nameofthevillage': 'गावाचे नाव',
      'grampanchayat': 'ग्रामपंचायत',
      'pending': 'प्रलंबित',
      'paid': 'पैसे दिले',
      'ok': 'ठीक आहे',
      'reducethehouse': 'घर कमी करा',
      'realestatefiscalyear': 'घरपट्टी-आर्थिक वर्ष २०२०-२०२१',
      'wardnumber': 'वॉर्ड क्रमांक',
      'ownersname': 'मालकाचे नाव',
      'ownervoicenumber': 'मालकाचा ध्वनी क्रमांक',
      'propertydescription': 'मालमत्तेचे वर्णन',
      'occupantsname': 'रहिवासीचे नाव',
      'housearea': 'घराचे क्षेत्रफळ',
      'constructionyear': 'बांधकाम वर्ष',
      'depreciation': 'घसारा दर',
      'weight': 'भारांक',
      'capitalvalue': 'भांडवली मूल्य',
      'taxrate': 'कराचा दर',
      'startrate': 'चालू कर',
      'housetax': 'घर कर',
      'electricitytax': 'वीज कर',
      'healthtax': 'आरोग्य कर',
      'totaltax': 'एकूण कर',
      'discountamount': 'एकूण सवलत',
      'previoustax': 'मागील कर',
      'penaltytotal': 'एकूण दंड',
      'homesteadpaid': 'घरपट्टी भरा',
      'makeareceipt': 'पावती बनवा',
      'areyousureyouwanttosubtractthehouse':
          'आपणास खात्री आहे कि आपण घर वजा करू इच्छिता?',
      'thehousehasbeensuccessfullydeducted': 'घर यशस्वीरीत्या वजा झाले आहे!',
      'paymentfailed': 'पेमेंट अयशस्वी',
      'homesteadpaymentinformation': 'घरपट्टी देय माहिती',
      'computerid': 'संगणक-आयडी',
      'payid': 'पे-आयडी',
      'paymentsuccessful': 'पेमेंट यशस्वी!',
      'aboutapp': 'अँप बद्दल',
      'aboutapppage': 'अँप पृष्ठाबद्दल',
      'changepassword': 'पासवर्ड बदला',
      'previouspassword': 'आधीचा पासवर्ड',
      'newpassword': 'नवीन पासवर्ड',
      'propernewpassword': 'योग्य नवीन पासवर्ड',
      'passwordsuccessfullychanged': 'पासवर्ड यशस्वीरीत्या बदलला गेला आहे!',
      'contactus': 'आमच्याशी संपर्क साधा',
      'contactpage': 'संपर्क पृष्ठ',
      'notificationpage': 'सूचना पृष्ठ',
      'notification': 'सूचना',
      'settings': 'सेटिंग्ज',
      'logout': 'लॉग आऊट',
      'areyousureyouwanttologout':
          'आपली खात्री आहे की आपण लॉग आउट करू इच्छिता?',
      'paymentcancelled': 'पेमेंट रद्द केले!',
    },
    'en': {
      'gramseva': 'Gramseva',
      'undertaking': 'Activity',
      'convenience': 'Convenience',
      'homestead': 'HouseTax',
      'homesteadinformation': 'House Tax',
      'mobilerecharge': 'Mobile recharge',
      'electricitybill': 'Electricity bill',
      'complaintregistration': 'Complaint Registration',
      'complaintregistrationpage': 'Complaint registration page',
      'paymentinformation': 'Payment Information',
      'areyousureyouwanttoquit': 'Are you sure you want to quit?',
      'no': 'No',
      'yes': 'Yes',
      'newupdateavailable': 'New Update Available',
      'thereisanewerversionofappavailablepleaseupdateitnow':
          'There is a newer version of app available please update it now.',
      'updatenow': 'Update Now',
      'later': 'Later',
      'checkinternetconnectivity': 'Check Internet Connectivity!',
      'readon': 'Read on',
      'informationnotavailable': 'Information not available!',
      'newusers': 'New users?',
      'register': 'Register',
      'login': 'Login',
      'voicenumberrequired': 'Voice number required!',
      'enterthecorrectsoundnumber': 'Enter the correct mobile number!',
      'voicenumber': 'Mobile number',
      'passwordrequired': 'Password required!',
      'password': 'Password',
      'userisinvalid': 'User is invalid!',
      'alreadyhaveusers': 'Already have users?',
      'registration': 'Registration',
      'registration1': 'Reg(1)',
      'registration2': 'Reg(2)',
      'registration3': 'Reg(3)',
      'namerequired': 'Name required!',
      'name': 'Name',
      'emailrequired': 'E-mail required!',
      'writeavalidemail': 'Write a valid e-mail!',
      'email': 'E-mail',
      'nameofgrampanchayatrequired': 'Name of Gram Panchayat required!',
      'nameofthegrampanchayat': 'Name of the Gram Panchayat',
      'computernumberrequired': 'Computer number required!',
      'computernumber': 'Computer number',
      'computernumberisalreadyregistered':
          'Computer number is already registered!',
      'voicenumberalreadyregistered': 'Mobile number already registered!',
      'computernumberandmobilenumberarealreadyregistered':
          'Computer number and voice number are already registered!',
      'goahead': 'Next',
      'resendotp': 'Resend OTP',
      'invalidotp': 'Invalid OTP!',
      'passwordmustbenolessthancharacters':
          'Password must be no less than 8 characters!',
      'enterthepasswordagain': 'Enter the password again',
      'passworddoesnotmatch': 'Password does not match',
      'registrationhasbeensuccessful': 'Registration has been successful!',
      'failedregistration': 'Failed registration!',
      'registerhome': 'Register House',
      'entercomputernumber': 'Enter computer number!',
      'thecomputernumberaboveisinvalid':
          'The computer number above is invalid!',
      'thehousehasbeensuccessfullyconnected':
          'The house has been successfully connected!',
      'flatnumber': 'Property Number',
      'flattype': 'Property Type',
      'nameofthevillage': 'Village Name',
      'grampanchayat': 'Gram Panchayat',
      'pending': 'Pending',
      'paid': 'Paid',
      'ok': 'Ok',
      'reducethehouse': 'Remove the house',
      'realestatefiscalyear': 'House Tax - Financial Year 2021-2022',
      'wardnumber': 'Ward number',
      'ownersname': 'Owners name',
      'ownervoicenumber': 'Owner mobile number',
      'propertydescription': 'Property Description',
      'occupantsname': 'Occupants Name',
      'housearea': 'House Area',
      'constructionyear': 'Construction Year',
      'depreciation': 'Depreciation',
      'weight': 'Weight',
      'capitalvalue': 'Capital Value',
      'taxrate': 'Tax Rate',
      'startrate': 'Current Tax',
      'housetax': 'House Tax',
      'electricitytax': 'Electricity Tax',
      'healthtax': 'Health Tax',
      'totaltax': 'Total Tax',
      'discountamount': 'Discount Amount',
      'previoustax': 'Previous Tax',
      'penaltytotal': 'Penalty Total',
      'homesteadpaid': 'Pay',
      'makeareceipt': 'Make a receipt',
      'areyousureyouwanttosubtractthehouse':
          'Are you sure you want to subtract the house?',
      'thehousehasbeensuccessfullydeducted':
          'The house has been successfully deducted!',
      'paymentfailed': 'Payment Failed',
      'homesteadpaymentinformation': 'Payment History',
      'computerid': 'Computer-ID',
      'payid': 'Pay-ID',
      'paymentsuccessful': 'Payment Successful!',
      'aboutapp': 'About App',
      'aboutapppage': 'About App Page',
      'changepassword': 'Change password',
      'previouspassword': 'Previous password',
      'newpassword': 'New password',
      'propernewpassword': 'Proper new password',
      'passwordsuccessfullychanged': 'Password successfully changed!',
      'contactus': 'Contact Us',
      'contactpage': 'Contact Page',
      'notificationpage': 'Notification Page',
      'notification': 'Notification',
      'settings': 'Settings',
      'logout': 'Logout',
      'areyousureyouwanttologout': 'Are you sure you want to log out?',
      'paymentcancelled': 'Payment Cancelled!',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]![key] ?? '** $key not found';
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<AppLocalization> {
  const AppLocalizationDelegate();

  @override
  bool isSupported(Locale locale) => ['mr', 'en'].contains(locale.languageCode);

  @override
  Future<AppLocalization> load(Locale locale) {
    // Returning a SynchronousFuture here because an async "load" operation
    // isn't needed to produce an instance of DemoLocalizations.
    return SynchronousFuture<AppLocalization>(
      AppLocalization(locale),
    );
  }

  @override
  bool shouldReload(AppLocalizationDelegate old) => false;
}
