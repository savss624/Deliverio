import 'package:flutter/material.dart';
import 'package:animator/animator.dart';
import 'package:delayed_display/delayed_display.dart';
import 'authentication/login.dart';
import 'class_builder.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'sideBar.dart';
import 'package:flutter_statusbar_manager/flutter_statusbar_manager.dart';

String email = '';
String name = '';
String method = '';
String image = '';
String dob = 'dd-mm--yy';
String gender = '';
String phone = '';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //await FlutterStatusbarManager.setHidden(true, animation: StatusBarAnimation.SLIDE);
  final prefs = await SharedPreferences.getInstance();
  email = prefs.getString('deliverio_email');
  image = prefs.getString('deliverio_image');
  name = prefs.getString('deliverio_name');
  phone = prefs.getString('deliverio_phone');
  gender = prefs.getString('deliverio_gender');
  dob = prefs.getString('deliverio_dob');
  method = prefs.getString('deliverio_method');
  ClassBuilder.registerClasses();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff141615),
      body: Stack(
        children: [
          Animator<double>(
            tween: Tween<double>(begin: 0, end: 300),
            cycles: 1,
            builder: (context, animatorState, child ) => Center(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                height: animatorState.value,
                width: animatorState.value,
                child: Image(image: AssetImage('images/logo.jpeg')),
              ),
            ),
          ),
          DelayedDisplay(
            delay: Duration(seconds: 2),
            child: name == null ? loginPage() : side_Bar(),//advertisementPage(),
          ),
        ],
      ),
    );
  }
}
