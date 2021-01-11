import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'signup.dart';
import 'package:deliverio/sideBar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:deliverio/main.dart';

class loginPage extends StatefulWidget {
  @override
  _loginPageState createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  CollectionReference userRefrence = FirebaseFirestore.instance.collection('Users');
  final _auth = FirebaseAuth.instance;
  final googleSignIn = GoogleSignIn();
  String email = '';
  String pw = '';

  Future check() async {
    final prefs = await SharedPreferences.getInstance();
    final curr_user = FirebaseAuth.instance.currentUser;
    userRefrence
        .doc(curr_user.email.substring(0, curr_user.email.indexOf('@')))
        .get()
        .then((DocumentSnapshot documentSnapshot) async {
      if (!documentSnapshot.exists) {
        userRefrence
            .doc(curr_user.email.substring(0, curr_user.email.indexOf('@')))
            .set({
              'Email': curr_user.email,
              'Name': curr_user.displayName,
              'UserType': 'Customer',
              'Phone': curr_user.phoneNumber,
              'Image': curr_user.photoURL,
              'Gender': '',
              'Birth Date': 'dd-mm--yy',
            })
            .then((value) => print('user Added'))
            .catchError((error) => print('Failed to add'));
        phone = curr_user.phoneNumber.toString();
        prefs.setString('deliverio_phone', curr_user.phoneNumber.toString());
      }
    });
    userRefrence
        .doc(curr_user.email.substring(0, curr_user.email.indexOf('@')))
        .get()
        .then((DocumentSnapshot documentSnapshot) async {
      phone = documentSnapshot.data()['Phone'];
      gender = documentSnapshot.data()['Gender'];
      dob = documentSnapshot.data()['Birth Date'];
      image = documentSnapshot.data()['Image'];
      prefs.setString('deliverio_image', image.toString());
      prefs.setString('deliverio_dob', dob.toString());
      prefs.setString('deliverio_phone', phone.toString());
      prefs.setString('deliverio_gender', gender.toString());
      });
    prefs.setString('deliverio_name', curr_user.displayName.toString());
    prefs.setString('deliverio_email', curr_user.email.toString());
    prefs.setString('deliverio_method', 'google');
    main();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomPadding: false,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Stack(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(15.0, 110.0, 0.0, 0.0),
                      child: Text('Hello',
                          style: TextStyle(
                              fontSize: 80.0, fontWeight: FontWeight.bold)),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(16.0, 175.0, 0.0, 0.0),
                      child: Text('There',
                          style: TextStyle(
                              fontSize: 80.0, fontWeight: FontWeight.bold)),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(220.0, 175.0, 0.0, 0.0),
                      child: Text('.',
                          style: TextStyle(
                              fontSize: 80.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.green)),
                    ),
                  ],
                ),
              ),
              Container(
                  padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
                  child: Column(
                    children: <Widget>[
                      TextField(
                        onChanged: (String value) {
                          email = value;
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            labelText: 'EMAIL',
                            labelStyle: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.green))),
                      ),
                      SizedBox(height: 20.0),
                      TextField(
                        onChanged: (String value) {
                          pw = value;
                        },
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                            labelText: 'PASSWORD',
                            labelStyle: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.green))),
                        obscureText: true,
                      ),
                      SizedBox(height: 5.0),
                      Container(
                        alignment: Alignment(1.0, 0.0),
                        padding: EdgeInsets.only(top: 15.0, left: 20.0),
                        child: InkWell(
                          child: Text(
                            'Forgot Password',
                            style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat',
                                decoration: TextDecoration.underline),
                          ),
                        ),
                      ),
                      SizedBox(height: 40.0),
                      Container(
                        height: 40.0,
                        child: Material(
                          borderRadius: BorderRadius.circular(20.0),
                          shadowColor: Colors.greenAccent,
                          color: Colors.green,
                          elevation: 7.0,
                          child: FlatButton(
                            onPressed: () async {
                              final prefs = await SharedPreferences.getInstance();
                              try {
                                final result = await InternetAddress.lookup('google.com');
                                if (result.isEmpty && result[0].rawAddress.isEmpty) {
                                  _scaffoldKey.currentState.showSnackBar(SnackBar(
                                    content: Text(
                                        'Network Issue! Please Check Your Internet'),
                                    duration: Duration(seconds: 3),
                                  ));
                                } else if (email == '' || pw == '') {
                                  _scaffoldKey.currentState.showSnackBar(SnackBar(
                                    content: Text(
                                        'Please Fill the Required Credentials'),
                                    duration: Duration(seconds: 3),
                                  ));
                                } else {
                                  userRefrence
                                      .doc(email.substring(0, email.indexOf('@')))
                                      .get()
                                      .then((DocumentSnapshot
                                  documentSnapshot) async {
                                    if (documentSnapshot.exists) {
                                      var type = documentSnapshot.data()['UserType'];
                                      name = documentSnapshot.data()['Name'];
                                      phone = documentSnapshot.data()['Phone'];
                                      image = documentSnapshot.data()['Image'];
                                      gender = documentSnapshot.data()['Gender'];
                                      dob = documentSnapshot.data()['Birth Date'];
                                      prefs.setString('deliverio_dob', dob.toString());
                                      prefs.setString('deliverio_gender', gender.toString());
                                      prefs.setString('deliverio_phone', phone.toString());
                                      prefs.setString('deliverio_name', name.toString());
                                      prefs.setString('deliverio_email', email.toString());
                                      prefs.setString('deliverio_method', 'login_pw');
                                      prefs.setString('deliverio_image', image.toString());
                                      if (type == 'Customer') {
                                        Fluttertoast.showToast(
                                            msg: "Logging In",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.black54,
                                            textColor: Colors.white,
                                            fontSize: 13.0);
                                        final newUser = await FirebaseAuth
                                            .instance
                                            .signInWithEmailAndPassword(
                                            email: email, password: pw);
                                        main();
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => side_Bar()));
                                      }
                                    } else {
                                      _scaffoldKey.currentState
                                          .showSnackBar(SnackBar(
                                        content: Text('User Does Not Exists! '),
                                        duration: Duration(seconds: 3),
                                      ));
                                    }
                                  });
                                }
                              } catch (e) {
                                _scaffoldKey.currentState.showSnackBar(SnackBar(
                                  content: Text(
                                      'Network Issue! Please Check Your Internet'),
                                  duration: Duration(seconds: 3),
                                ));
                              }
                            },
                            child: Center(
                              child: Text(
                                'LOGIN',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Montserrat'),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Container(
                        height: 40.0,
                        color: Colors.transparent,
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.black,
                                  style: BorderStyle.solid,
                                  width: 1.0),
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(20.0)),
                          child: FlatButton(
                            onPressed: () async {
                              try {
                                final user = await googleSignIn.signIn();
                                final result = await InternetAddress.lookup('google.com');
                                if (result.isEmpty && result[0].rawAddress.isEmpty) {
                                  _scaffoldKey.currentState.showSnackBar(SnackBar(
                                    content: Text(
                                        'Network Issue! Please Check Your Internet'),
                                    duration: Duration(seconds: 3),
                                  ));
                                } else if (user == null) {
                                  return;
                                } else {
                                  final googleAuth = await user.authentication;
                                  final credential =
                                  GoogleAuthProvider.credential(
                                    accessToken: googleAuth.accessToken,
                                    idToken: googleAuth.idToken,
                                  );
                                  Fluttertoast.showToast(
                                      msg: "Please Wait!",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.black54,
                                      textColor: Colors.white,
                                      fontSize: 13.0);
                                  await FirebaseAuth.instance
                                      .signInWithCredential(credential);
                                  check();
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => side_Bar()));
                                }
                              } catch (e) {
                                _scaffoldKey.currentState.showSnackBar(SnackBar(
                                  content: Text(
                                      'Network Issue! Please Check Your Internet'),
                                  duration: Duration(seconds: 3),
                                ));
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Center(
                                  child: ImageIcon(
                                      AssetImage('images/Google logo.webp'),
                                      color: Colors.black),
                                ),
                                SizedBox(width: 10.0),
                                Center(
                                  child: Text('Log in with google',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Montserrat')),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  )),
              SizedBox(height: 15.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'New to Deliverio ?',
                    style: TextStyle(fontFamily: 'Montserrat'),
                  ),
                  SizedBox(width: 5.0),
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => signupPage()));
                    },
                    child: Text(
                      'Register',
                      style: TextStyle(
                          color: Colors.green,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline),
                    ),
                  )
                ],
              )
            ],
          ),
        )
    );
  }
}
