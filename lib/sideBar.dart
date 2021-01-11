import 'package:flutter/material.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'class_builder.dart';
import 'home.dart';
import 'profile.dart';
import 'schedules.dart';
import 'settings.dart';
import 'stats.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'authentication/login.dart';
import 'main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class side_Bar extends StatefulWidget {
  @override
  _side_BarState createState() => _side_BarState();
}

class _side_BarState extends State<side_Bar> with TickerProviderStateMixin {
  KFDrawerController _drawerController;
  final user = FirebaseAuth.instance.currentUser;
  final googleSignIn = GoogleSignIn();

  @override
  void initState() {
    super.initState();
    _drawerController = KFDrawerController(
      initialPage: ClassBuilder.fromString('Home'),
      items: [
        KFDrawerItem.initWithPage(
          text:
              Text('Home', style: TextStyle(color: Colors.white, fontSize: 18)),
          icon: Icon(Icons.home, color: Colors.white),
          page: Home(),
        ),
        KFDrawerItem.initWithPage(
          text: Text(
            'Profile',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          icon: Icon(Icons.account_box, color: Colors.white),
          page: Profile(),
        ),
        KFDrawerItem.initWithPage(
          text: Text(
            'Notifications',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          icon: Icon(Icons.notifications_active, color: Colors.white),
          page: ClassBuilder.fromString('Notifications'),
        ),
        KFDrawerItem.initWithPage(
          text: Text(
            'Stats',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          icon: Icon(Icons.trending_up, color: Colors.white),
          page: Stats(),
        ),
        KFDrawerItem.initWithPage(
          text: Text(
            'Schedules',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          icon: Icon(Icons.av_timer, color: Colors.white),
          page: Schedules(),
        ),
        KFDrawerItem.initWithPage(
          text: Text(
            'Settings',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          icon: Icon(Icons.settings, color: Colors.white),
          page: Settings(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: KFDrawer(
        controller: _drawerController,
        header: Align(
          alignment: Alignment.centerLeft,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            width: MediaQuery.of(context).size.width * 0.8,
            child: Row(
              children: <Widget>[
                Stack(
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          image: DecorationImage(
                              image: AssetImage('images/profile.png'),
                              fit: BoxFit.cover)),
                    ),
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          image: DecorationImage(
                              image: method == 'google'
                              ?NetworkImage(user.photoURL)
                              :NetworkImage(image),
                              fit: BoxFit.cover)),
                    ),
                  ],
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    method == 'google'
                    ? Text(user.displayName,
                        style:
                            new TextStyle(fontSize: 17, color: Colors.white))
                    : Text(name,
                        style:
                            new TextStyle(fontSize: 17, color: Colors.white)),
                    SizedBox(height: 2),
                    method == 'google'
                    ? Text(user.email,
                        style: new TextStyle(fontSize: 15, color: Colors.grey))
                    : Text(email,
                        style: new TextStyle(fontSize: 15, color: Colors.grey)),
                  ],
                )
              ],
            ),
          ),
        ),
        footer: KFDrawerItem(
          text: FlatButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              prefs.remove('deliverio_email');
              prefs.remove('deliverio_name');
              prefs.remove('deliverio_method');
              prefs.remove('deliverio_image');
              prefs.remove('deliverio_phone');
              prefs.remove('deliverio_gender');
              prefs.remove('deliverio_dob');
              if (method == 'google') {
                await googleSignIn.disconnect();
                FirebaseAuth.instance.signOut();
              }
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => loginPage()));
            },
            child: Text(
              'Logout',
              style: TextStyle(color: Colors.grey, fontSize: 18),
            ),
          ),
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromRGBO(31, 58, 47, 1.0),
              Color.fromRGBO(31, 58, 47, 1.0)
            ],
            tileMode: TileMode.repeated,
          ),
        ),
      ),
    );
  }
}
