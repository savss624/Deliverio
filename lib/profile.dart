import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:fluttertoast/fluttertoast.dart';
import 'location.dart';

class Profile extends KFDrawerContent {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  DateTime _date;

  CollectionReference userRefrence = FirebaseFirestore.instance.collection('Users');
  final user = FirebaseAuth.instance.currentUser;

  Future phoneAdd() async {
    final prefs = await SharedPreferences.getInstance();
    userRefrence
        .doc(email.substring(0, email.indexOf('@')))
        .update({
      'Phone': phone,
    })
        .then((value) => print('user Added'))
        .catchError((error) => print('Failed to add'));
    prefs.setString('deliverio_phone', phone);
    main();
    setState(() {});
  }

  Future genderAdd() async {
    final prefs = await SharedPreferences.getInstance();
    userRefrence
        .doc(email.substring(0, email.indexOf('@')))
        .update({
      'Gender': gender,
    })
        .then((value) => print('user Added'))
        .catchError((error) => print('Failed to add'));
    prefs.setString('deliverio_gender', gender);
    main();
    setState(() {});
  }

  Future dobAdd() async {
    final prefs = await SharedPreferences.getInstance();
    userRefrence
        .doc(email.substring(0, email.indexOf('@')))
        .update({
      'Birth Date': dob,
    })
        .then((value) => print('user Added'))
        .catchError((error) => print('Failed to add'));
    prefs.setString('deliverio_dob', dob);
    main();
    setState(() {});
  }

  File _image;
  final picker=ImagePicker();

  Future imageAdd() async {
    final prefs = await SharedPreferences.getInstance();
    userRefrence.doc(email.substring(0,email.indexOf('@'))).update({
      'Image' : image,
    }).then((value)=>print('user added'))
        .catchError((error)=> print('Failed to add User'));
    prefs.setString('deliverio_image', image);
    main();
    setState(() {});
  }

  Future<firebase_storage.UploadTask> uploadFile(BuildContext context) async{
    Fluttertoast.showToast(
        msg: "May Take Few Seconds",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 10,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 13.0);
    String fileName = path.basename(_image.path);
    firebase_storage.Reference ref= firebase_storage.FirebaseStorage.instance.ref().child(email.substring(0,email.indexOf('@'))).child(fileName);
    firebase_storage.UploadTask uploadTask = ref.putFile(_image);
    final url = await (await uploadTask).ref.getDownloadURL();
    setState(() async {
      image = url.toString();
      imageAdd();
    });
  }

  Future<void> getImageViaGallery() async{
    Navigator.pop(context);
    final pickedFile =await picker.getImage(source: ImageSource.gallery);
    if(pickedFile!=null){
      final croppedFile=await ImageCropper.cropImage(
        sourcePath: File(pickedFile.path).path,
      );
      setState(() {
        if(croppedFile!=null){
          _image = File(croppedFile.path);
          uploadFile(context);
        }else{
          print('No file selected');
        }
      });
    }
  }

  Future<void> getImageViaCamera() async{
    Navigator.pop(context);
    final pickedFile =await picker.getImage(source: ImageSource.camera);
    if(pickedFile!=null){
      final croppedFile=await ImageCropper.cropImage(
        sourcePath: File(pickedFile.path).path,
      );
      setState(() {
        if(croppedFile!=null){
          _image = File(croppedFile.path);
          uploadFile(context);
        }else{
          print('No file selected');
        }
      });
    }
    else{
      print('No file selected');
    }
  }

  void displayBottomSheet(){
    showModalBottomSheet(
        context: context,
        builder: (context){
          return Container(
            color: Color(0xFF737373),
            height: 150,
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15)
                  )
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        IconButton(
                          iconSize: 60,
                          icon: Icon(Icons.camera),
                          onPressed: getImageViaCamera,
                        ),
                        Text('Camera'),
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                          iconSize: 60,
                          icon: Icon(Icons.photo),
                          onPressed: getImageViaGallery,
                        ),
                        Text('Gallery'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: 8,
              color: Colors.green,
            ),
            Row(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  child: Material(
                    shadowColor: Colors.transparent,
                    color: Colors.transparent,
                    child: FlatButton(
                      height: 20,
                      minWidth: 20,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 15,
                                height: 2.5,
                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(15)),
                              ),
                              SizedBox(width: 4)
                            ],
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Row(
                            children: [
                              SizedBox(width: 4),
                              Container(
                                width: 15,
                                height: 2.5,
                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(15)),
                              ),
                            ],
                          )
                        ],
                      ),
                      onPressed: widget.onMenuPressed,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: 15, right: 15, top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Profile',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat',
                              fontSize: 24),
                        ),
                        Stack(
                          children: [
                            Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40),
                                  image: DecorationImage(
                                      image: AssetImage('images/profile.png'),
                                      fit: BoxFit.cover)),
                            ),
                            Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40),
                                  image: DecorationImage(
                                      image: NetworkImage(image),
                                      fit: BoxFit.cover)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Montserrat',
                                fontSize: 24),
                          ),
                          SizedBox(height: 2),
                          Text(
                            email,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Montserrat',
                                fontSize: 14),
                          ),
                        ],
                      ),
                      Container(
                        height: 30,
                        width: 80,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.green,
                                style: BorderStyle.solid,
                                width: 2.0),
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(10.0)),
                        child: FlatButton(
                            onPressed: displayBottomSheet,
                            child: Center(
                              child: Text('Edit',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Montserrat')),
                            )),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  Center(
                    child: Container(
                      color: Colors.black12,
                      width: MediaQuery.of(context).size.width - 30,
                      height: 2,
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Personal Details',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                        fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Card(
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'First Name',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Montserrat',
                                    color: Colors.grey,
                                    fontSize: 14),
                              ),
                              SizedBox(height: 8),
                              name.indexOf(' ') >= 0 && name.indexOf(' ') < name.length
                                  ? Text(
                                      name.substring(0, name.indexOf(' ')),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Montserrat',
                                          fontSize: 18),
                                    )
                                  : Text(
                                      name,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Montserrat',
                                          fontSize: 18),
                                    ),
                              SizedBox(height: 14),
                              Text(
                                'Gender',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Montserrat',
                                    color: Colors.grey,
                                    fontSize: 14),
                              ),
                              SizedBox(height: 8),
                              gender == 'null' || gender == null
                                ? Text(
                                '',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Montserrat',
                                    fontSize: 18),
                              )
                                : Text(
                                gender,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Montserrat',
                                    fontSize: 18),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Last Name',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Montserrat',
                                    color: Colors.grey,
                                    fontSize: 14),
                              ),
                              SizedBox(height: 8),
                              name.indexOf(' ') >= 0 &&
                                      name.indexOf(' ') < name.length
                                  ? Text(
                                      name.substring(name.indexOf(' ') + 1),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Montserrat',
                                          fontSize: 18),
                                    )
                                  : Text(
                                      '',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Montserrat',
                                          fontSize: 18),
                                    ),
                              SizedBox(height: 14),
                              Text(
                                'Birth Date',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Montserrat',
                                    color: Colors.grey,
                                    fontSize: 14),
                              ),
                              SizedBox(height: 8),
                              dob == null || dob == 'null'
                                ? Text(
                                'dd-mm--yy',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Montserrat',
                                    fontSize: 18),
                              )
                                : Text(
                                dob,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Montserrat',
                                    fontSize: 18),
                              ),
                            ],
                          ),
                          IconButton(
                              icon: Icon(FlutterIcons.edit_faw),
                              onPressed: () {
                                Alert(
                                    context: context,
                                    title: 'Gender',
                                    content: StatefulBuilder(builder:
                                        (BuildContext context,
                                            StateSetter setState) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(top: 16.0),
                                        child: Wrap(
                                          alignment: WrapAlignment.center,
                                          runSpacing: 10.0,
                                          spacing: 10.0,
                                          children: [
                                            Container(
                                              height: 30,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.green,
                                                      style: BorderStyle.solid,
                                                      width: 2.0),
                                                  color: gender == 'male'
                                                      ? Colors.green
                                                      : Colors.transparent,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0)),
                                              child: FlatButton(
                                                onPressed: () {
                                                  setState(() {
                                                    gender = 'male';
                                                  });
                                                },
                                                child: Center(
                                                  child: Text(
                                                    'Male',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily:
                                                            'Montserrat'),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 30,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.green,
                                                      style: BorderStyle.solid,
                                                      width: 2.0),
                                                  color: gender == 'female'
                                                      ? Colors.green
                                                      : Colors.transparent,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0)),
                                              child: FlatButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      gender = 'female';
                                                    });
                                                  },
                                                  child: Center(
                                                    child: Text('Female',
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontFamily:
                                                                'Montserrat')),
                                                  )),
                                            ),
                                            Container(
                                              height: 30,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.green,
                                                      style: BorderStyle.solid,
                                                      width: 2.0),
                                                  color: gender == 'others'
                                                      ? Colors.green
                                                      : Colors.transparent,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0)),
                                              child: FlatButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      gender = 'others';
                                                    });
                                                  },
                                                  child: Center(
                                                    child: Text('Others',
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontFamily:
                                                                'Montserrat')),
                                                  )),
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                                    buttons: [
                                      DialogButton(
                                        child: Text(
                                          'Next',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontFamily: 'Montserrat',
                                              fontSize: 18,
                                              color: Colors.white),
                                        ),
                                        onPressed: () {
                                          genderAdd();
                                          Navigator.pop(context);
                                          Alert(
                                              context: context,
                                              title: 'Birth Date',
                                              content: StatefulBuilder(builder:
                                                  (BuildContext context,
                                                      StateSetter setState) {
                                                return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 16.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        dob == null
                                                          ? Text('dd-mm--yy')
                                                          : Text(dob),
                                                        SizedBox(width: 20),
                                                        IconButton(
                                                          icon: Icon(Icons
                                                              .date_range_outlined),
                                                          onPressed: () {
                                                            showDatePicker(
                                                                context:
                                                                    context,
                                                                initialDate:
                                                                    _date ==
                                                                            null
                                                                        ? DateTime
                                                                            .now()
                                                                        : _date,
                                                                firstDate:
                                                                    DateTime(
                                                                        1900),
                                                                lastDate:
                                                                    DateTime
                                                                        .now(),
                                                                builder: (BuildContext
                                                                        context,
                                                                    Widget
                                                                        child) {
                                                                  return Theme(
                                                                    data: ThemeData.dark().copyWith(
                                                                        colorScheme: ColorScheme.dark(
                                                                            primary: Colors
                                                                                .green,
                                                                            onPrimary: Colors
                                                                                .white,
                                                                            surface: Colors
                                                                                .white,
                                                                            onSurface: Colors
                                                                                .green),
                                                                        dialogBackgroundColor:
                                                                            Colors.white),
                                                                    child:
                                                                        child,
                                                                  );
                                                                }).then((date) {
                                                              setState(() {
                                                                _date = date;
                                                                dob = (_date.day
                                                                        .toString() +
                                                                    '-' +
                                                                    _date.month
                                                                        .toString() +
                                                                    '-' +
                                                                    _date.year
                                                                        .toString());
                                                              });
                                                            });
                                                          },
                                                        )
                                                      ],
                                                    ));
                                              }),
                                              buttons: [
                                                DialogButton(
                                                  child: Text(
                                                    'Update',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontFamily:
                                                            'Montserrat',
                                                        fontSize: 18,
                                                        color: Colors.white),
                                                  ),
                                                  onPressed: () {
                                                    dobAdd();
                                                    Navigator.pop(context);
                                                  },
                                                  color: Colors.green,
                                                )
                                              ]).show();
                                        },
                                        color: Colors.green,
                                      )
                                    ]).show();
                              })
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Phone & Email',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                        fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Card(
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Phone',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Montserrat',
                                    color: Colors.grey,
                                    fontSize: 14),
                              ),
                              SizedBox(height: 8),
                              phone.toString() == 'null'
                                ? Text(
                                '',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Montserrat',
                                    fontSize: 18),
                              )
                                : Text(
                                phone,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Montserrat',
                                    fontSize: 18),
                              ),
                              SizedBox(height: 14),
                              Text(
                                'Email',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Montserrat',
                                    color: Colors.grey,
                                    fontSize: 14),
                              ),
                              SizedBox(height: 8),
                              Text(
                                email,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Montserrat',
                                    fontSize: 18),
                              ),
                            ],
                          ),
                          IconButton(
                              icon: Icon(FlutterIcons.edit_faw),
                              onPressed: () {
                                Alert(
                                    context: context,
                                    title: 'Phone',
                                    content: phone.toString() == 'null'
                                        ? TextFormField(
                                      cursorColor: Colors.green,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.green))),
                                      onChanged: (String value) {
                                        setState(() {
                                          phone = value;
                                        });
                                      },
                                    )
                                        : TextFormField(
                                      initialValue: phone,
                                      cursorColor: Colors.green,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.green))),
                                      onChanged: (String value) {
                                        setState(() {
                                          phone = value;
                                        });
                                      },
                                    ),
                                    buttons: [
                                      DialogButton(
                                        child: Text(
                                          'Update',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontFamily: 'Montserrat',
                                              fontSize: 18,
                                              color: Colors.white),
                                        ),
                                        onPressed: () {
                                          phoneAdd();
                                          Navigator.pop(context);
                                        },
                                        color: Colors.green,
                                      )
                                    ]).show();
                              })
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Address Details',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                        fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Container(
                    height: 40.0,
                    child: Material(
                      borderRadius: BorderRadius.circular(10.0),
                      shadowColor: Colors.greenAccent,
                      color: Colors.green,
                      elevation: 7.0,
                      child: FlatButton(
                        onPressed: () async {
                          await PermissionHandler().requestPermissions([PermissionGroup.contacts]);
                          Navigator.push(context, MaterialPageRoute(builder: (context) => location()));
                        },
                        child: Center(
                          child: Text(
                            'CHANGE ADDRESS',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat'),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
