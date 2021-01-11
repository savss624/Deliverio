import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'login.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';

class signupPage extends StatefulWidget {
  @override
  _signupPageState createState() => _signupPageState();
}

class _signupPageState extends State<signupPage> {

  String email = '';
  String pw = '';
  String name = '';
  CollectionReference userRefrence = FirebaseFirestore.instance.collection('Users');
  final _auth = FirebaseAuth.instance;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomPadding: false,
        body: SingleChildScrollView(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
              Widget>[
            Container(
              child: Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(15.0, 110.0, 0.0, 0.0),
                    child: Text(
                      'Signup',
                      style:
                      TextStyle(fontSize: 80.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(260.0, 125.0, 0.0, 0.0),
                    child: Text(
                      '.',
                      style: TextStyle(
                          fontSize: 80.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.green),
                    ),
                  )
                ],
              ),
            ),
            Container(
                padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
                child: Column(
                  children: <Widget>[
                    TextField(
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (String value) {
                        setState(() {
                          email = value;
                        });
                      },
                      decoration: InputDecoration(
                          labelText: 'EMAIL',
                          labelStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                          // hintText: 'EMAIL',
                          // hintStyle: ,
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green))),
                    ),
                    SizedBox(height: 10.0),
                    TextField(
                      keyboardType: TextInputType.visiblePassword,
                      onChanged: (String value) {
                        setState(() {
                          pw = value;
                        });
                      },
                      decoration: InputDecoration(
                          labelText: 'PASSWORD ',
                          labelStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green))),
                      obscureText: true,
                    ),
                    SizedBox(height: 10.0),
                    TextField(
                      onChanged: (String value) {
                        setState(() {
                          name = value;
                        });
                      },
                      decoration: InputDecoration(
                          labelText: 'NICK NAME ',
                          labelStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green))),
                    ),
                    SizedBox(height: 50.0),
                    Container(
                        height: 40.0,
                        child: Material(
                          borderRadius: BorderRadius.circular(20.0),
                          shadowColor: Colors.greenAccent,
                          color: Colors.green,
                          elevation: 7.0,
                          child: FlatButton(
                            onPressed: () async {
                              try {
                                final result = await InternetAddress.lookup('google.com');
                                if(result.isEmpty && result[0].rawAddress.isEmpty){
                                  _scaffoldKey.currentState.showSnackBar(SnackBar(
                                    content: Text('Network Issue! Please Check Your Internet'),
                                    duration: Duration(seconds: 3),
                                  ));
                                }
                                else if(email == '' || !email.endsWith('@gmail.com') || email.length < 11) {
                                  _scaffoldKey.currentState.showSnackBar(SnackBar(
                                    content: Text('Please Check the Email'),
                                    duration: Duration(seconds: 3),
                                  ));
                                }
                                else if(pw.length < 8) {
                                  _scaffoldKey.currentState.showSnackBar(SnackBar(
                                    content: Text('Please Set a Strong Password (8 Digits Minimum)'),
                                    duration: Duration(seconds: 3),
                                  ));
                                }
                                else if(name == '') {
                                  _scaffoldKey.currentState.showSnackBar(SnackBar(
                                    content: Text('Please Set the Nick Name'),
                                    duration: Duration(seconds: 3),
                                  ));
                                }
                                else {
                                  userRefrence
                                      .doc(email.substring(0, email.indexOf('@')))
                                      .get()
                                      .then((DocumentSnapshot documentSnapshot) async {
                                    if (documentSnapshot.exists) {
                                      _scaffoldKey.currentState.showSnackBar(SnackBar(
                                        content: Text('User Already Exists! '),
                                        duration: Duration(seconds: 3),
                                      ));
                                    }
                                    else {
                                      final newUser = await _auth.createUserWithEmailAndPassword(
                                          email: email, password: pw);
                                      userRefrence
                                          .doc(email.substring(0, email.indexOf('@')))
                                          .set({
                                        'Email': email,
                                        'Name': name,
                                        'Image': 'https://ssvassgje.in/upload/salon-profile-image/demo/profile.png',
                                        'UserType': 'Customer',
                                        'Phone': '',
                                        'Gender': '',
                                        'Birth Date': 'dd-mm--yy',
                                      }).then((value) => print('user Added')).catchError((error) => print('Failed to add'));
                                      Fluttertoast.showToast(
                                          msg: "User Registered",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.black54,
                                          textColor: Colors.white,
                                          fontSize: 13.0);
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => loginPage()));
                                    }
                                  });
                                }
                              } catch (e) {
                                _scaffoldKey.currentState.showSnackBar(SnackBar(
                                  content: Text('Network Issue! Please Check Your Internet'),
                                  duration: Duration(seconds: 3),
                                ));
                              }
                            },
                            child: Center(
                              child: Text(
                                'SIGNUP',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Montserrat'),
                              ),
                            ),
                          ),
                        )),
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
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Center(
                            child: Text('Go Back',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Montserrat')),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
            ),
          ]
          ),
        )
    );
  }
}
