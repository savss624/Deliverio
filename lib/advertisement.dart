import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:deliverio/authentication/login.dart';

class advertisementPage extends StatefulWidget {
  @override
  _advertisementPageState createState() => _advertisementPageState();
}

class _advertisementPageState extends State<advertisementPage> {

  @override
  Widget build(BuildContext context) {
    return Builder(
        builder: (context) => LiquidSwipe(
            pages: [
              Stack(
                children: [
                  Container(
                    color: Color(0xff141615),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: EdgeInsets.only(top: 40, right: 30),
                      child: SizedBox(
                        height: 45,
                        width: 75,
                        child: RaisedButton(
                          color: Color(0xff141615),
                          elevation: 0.1,
                          child: Text(
                            'SKIP',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontFamily: 'Fredoka One',
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => loginPage()));},
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: Container(
                        width: 80,
                        height: 20,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 12,
                              child: CircleAvatar(
                                radius: 8,
                                backgroundColor: Color(0xff141615).withOpacity(0.5),
                              ),
                            ),
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 12,
                            ),
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 12,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Stack(
                children: [
                  Container(
                    color: Colors.white,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: Container(
                        width: 80,
                        height: 20,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.black54,
                              radius: 12,
                            ),
                            CircleAvatar(
                              backgroundColor: Colors.black54,
                              radius: 12,
                              child: CircleAvatar(
                                radius: 8,
                                backgroundColor: Colors.blue.withOpacity(0.5),
                              ),
                            ),
                            CircleAvatar(
                              backgroundColor: Colors.black54,
                              radius: 12,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Stack(
                children: [
                  Container(
                    color: Color(0xff141615),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: EdgeInsets.only(top: 40, right: 30),
                      child: SizedBox(
                        height: 45,
                        width: 76,
                        child: RaisedButton(
                          color: Colors.transparent,
                          elevation: 0.1,
                          onPressed: () {  },
                          child: Text(
                            'NEXT',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontFamily: 'Fredoka One'
                            ),
                          ),
                          //
                          // onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => Authentication()));},
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: Container(
                        width: 80,
                        height: 20,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.black54,
                              radius: 12,
                            ),
                            CircleAvatar(
                              backgroundColor: Colors.black54,
                              radius: 12,
                            ),
                            CircleAvatar(
                              backgroundColor: Colors.black54,
                              radius: 12,
                              child: CircleAvatar(
                                radius: 8,
                                backgroundColor: Colors.yellow.withOpacity(0.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ]
        )
    );
  }
}
