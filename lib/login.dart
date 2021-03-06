import 'dart:async';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'ChatScreen.dart';
import 'db.dart';
import 'main.dart';
import 'service.dart';
import 'globals.dart' as globals;
import 'Models/Message.dart' as mes;

import '../HomePage.dart';
import '../api.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var messageList = <mes.Message>[];
  // final TextEditingController _userid = TextEditingController();
  // final TextEditingController _password = TextEditingController();
  late double _height, _width;
  String _userid = globals.userID, _password = '';
  GlobalKey<FormState> _key = GlobalKey();
  bool _showPassword = true, _load = false;
  late Future<String> _futureJwt;
  bool _splashFlag = true;

  late final FirebaseMessaging _messaging;
  late int _totalNotifications;
  PushNotification? _notificationInfo;

  get onSelectNotification => null;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;



  @override
  void initState()  {
    _totalNotifications = 0;
    super.initState();
    var initialzationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: initialzationSettingsAndroid);

    // _firebaseMessaging
    //     .getToken()
    //     .then((String? token) {
    //   assert(token != null);
    // });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      // if (message.data['screenId'] == "2") {
      Get.to(ChatScreen(name: globals.userName,
        screenId: message.data['screenId'],
        screen: message.data['screenName'],
        messageId:"",
        groupId: message.data['groupId'],
        receiverId: message.data['receiverId'],
        stream:globals.streamController.stream,
      ));
    });

    // FirebaseMessaging.instance.getInitialMessage().then((message) {
    //   if (message != null) {
    //     Get.to(ChatScreen(name: globals.userName,
    //       screenId: message.data['screenId'],
    //       screen: message.data['screenName'],
    //       messageId:"",
    //       groupId: message.data['groupId'],
    //       receiverId: message.data['receiverId'],));      }
    // });

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.data['status'] == "False") {
        ChatScreen chat = new ChatScreen(stream:globals.streamController.stream);
        chat.deleteMessageFromList(message.data['messageId']);
      } else {
        saveMessage(
            message.data['messageId'],
            message.data['senderName'],
            message.notification?.body,
            message.data['screenId'],
            message.data['groupName'],
            message.data['groupId'],
            message.data['senderID'],
            message.data['time']);
        if(globals.screenID == message.data['senderID'] && (globals.groupID == message.data['groupId'] || globals.senderID == message.data['senderID']) ) {
          messageList.add(mes.Message(
              name: message.data['senderName'],
              message: (message.notification?.body != null ? message
                  .notification?.body : "").toString(),
              groupName: message.data['groupName'],
              messageId: message.data['messageId'],
              messageStatus: true,
              time: message.data['time'],
              isMine: false));
          globals.messageList = messageList;
          globals.streamController.add(1);
        }

        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;
        if (notification != null && android != null) {
          flutterLocalNotificationsPlugin.show(
              notification.hashCode,
              notification.title,
              notification.body,
              NotificationDetails(
                android: AndroidNotificationDetails(
                  channel.id,
                  channel.name,
                  channelDescription: channel.description,
                  icon: android.smallIcon,
                ),
              ));
        }
      }
    });


    // RemoteMessage? initialMessage =
    //     await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen

    // if (initialMessage?.data['screenId'] != '') {
    //   Get.to(ChatScreen(name: globals.userName,
    //     screenId: initialMessage?.data['screenId'],
    //     screen: initialMessage?.data['screenName'],
    //     messageId:"",
    //     groupId: initialMessage?.data['groupId'],
    //     receiverId: initialMessage?.data['receiverId'],));
    // }

    autoLogIn();
  }

  void autoLogIn() async {
    // _splashFlag = false;
    var flg = await getSettings();
    // final SharedPreferences prefs = await SharedPreferences.getInstance();
    // _userid =
    //     prefs.getString('userID') != null ? prefs.getString('userID')! : '';
    // _password =
    //     prefs.getString('password') != null ? prefs.getString('password')! : '';
      _userid = globals.userID;
      _password = globals.password;
      if (flg && _userid != '' && _userid != null) {
        signIn(true);
        setState(() {
          _splashFlag = true;
        });
        return;
      } else {
        setState(() {
          _splashFlag = false;
        });
        return;
      }

  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return FutureBuilder<dynamic>(
        builder: (context, AsyncSnapshot<dynamic> _data) {
      if (!_splashFlag) {
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('asset/images/bk2.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              // height: _height,
              // width: _width,
              // padding: EdgeInsets.only(bottom: 5),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    image(),
                    // welcomeText(),
                    //loginText(),
                    form(),
                    // forgetPassText(),
                    SizedBox(height: _height / 20),
                    button(),
                  ],
                ),
              ),
            ),
            // ),
          ),
        );
      } else {
        // Get.to(ErrorPage())
        return CircularIndicator();
      }
    });
  }

  Widget image() {
    return Container(
      margin: EdgeInsets.only(top: _height / 20.0),
      height: 200.0,
      width: 150.0,
      decoration: new BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: new Image.asset('asset/images/pasons.png'),
    );
  }

  Widget welcomeText() {
    return Container(
      margin: EdgeInsets.only(left: _width / 20, top: _height / 100),
      child: Row(
        children: <Widget>[
          Text(
            "Welcome",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 50,
            ),
          ),
        ],
      ),
    );
  }

  Widget loginText() {
    return Container(
      margin: EdgeInsets.only(left: _width / 15.0),
      child: Row(
        children: <Widget>[
          Text(
            "Sign in to your account",
            style: TextStyle(
              fontWeight: FontWeight.w200,
              fontSize: 17,
            ),
          ),
        ],
      ),
    );
  }

  Widget form() {
    return Container(
      margin: EdgeInsets.only(
          left: _width / 12.0, right: _width / 12.0, top: _height / 15.0),
      child: Form(
        key: _key,
        child: Column(
          children: <Widget>[
            emailBox(),
            SizedBox(height: _height / 40.0),
            passwordBox(),
          ],
        ),
      ),
    );
  }

  Widget emailBox() {
    return Material(
      borderRadius: BorderRadius.circular(30.0),
      elevation: 10,
      child: TextFormField(
        onSaved: (input) => _userid = input!,
        keyboardType: TextInputType.text,
        cursorColor: Colors.redAccent,
        obscureText: false,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.perm_identity_rounded,
              color: Colors.blueAccent, size: 20),
          hintText: "User ID",
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget passwordBox() {
    return Material(
      borderRadius: BorderRadius.circular(30.0),
      elevation: 10,
      child: TextFormField(
        onSaved: (input) => _password = input!,
        keyboardType: TextInputType.visiblePassword,
        cursorColor: Colors.redAccent,
        obscureText: _showPassword,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.lock, color: Colors.blueAccent, size: 20),
          suffixIcon: IconButton(
            icon: Icon(
              Icons.remove_red_eye,
              color: this._showPassword ? Colors.grey : Colors.blueAccent,
            ),
            onPressed: () {
              setState(() => this._showPassword = !this._showPassword);
            },
          ),
          hintText: "Password",
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget forgetPassText() {
    return Container(
      margin: EdgeInsets.only(top: _height / 40.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Forgot your password?",
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 13),
          ),
          SizedBox(
            width: 5,
          ),
          GestureDetector(
            onTap: () {
              print("Routing");
              Navigator.of(context).pushNamed('forgotpassword');
            },
            child: Text(
              "Recover",
              style: TextStyle(
                  fontWeight: FontWeight.w600, color: Colors.redAccent),
            ),
          )
        ],
      ),
    );
  }

  Widget button() {
    return !_load
        ? RaisedButton(
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            onPressed: () async {
              RegExp regExp = new RegExp(
                  r'^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$');
              final formstate = _key.currentState;
              formstate?.save();
              if (_userid == null || _userid.isEmpty) {
                // Scaffold.of(context).showSnackBar(
                //     SnackBar(content: Text('User ID Cannot be empty')));
                Get.snackbar('Error', 'User ID Cannot be empty',
                    colorText: Colors.red, snackPosition: SnackPosition.BOTTOM);
              } else if (_password == null || _password.length < 3) {
                // Scaffold.of(context).showSnackBar(SnackBar(
                //     content: Text(
                //         'Password needs to be at least three characters')));
                Get.snackbar(
                    'Error', 'Password needs to be at least three characters',
                    colorText: Colors.red, snackPosition: SnackPosition.BOTTOM);
              } else if (regExp.hasMatch(_userid)) {
                // Scaffold.of(context).showSnackBar(
                //     SnackBar(content: Text('Enter a Valid User ID')));
                Get.snackbar('Error', 'Enter a Valid User ID',
                    colorText: Colors.red, snackPosition: SnackPosition.BOTTOM);
              } else {
                setState(() {
                  _load = true;
                });
                signIn(false);
              }
            },
            textColor: Colors.white,
            padding: EdgeInsets.all(0.0),
            child: Container(
              alignment: Alignment.center,
              width: _width / 2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                gradient: LinearGradient(
                  colors: <Color>[Colors.green[300]!, Colors.blueAccent],
                ),
              ),
              padding: const EdgeInsets.all(12.0),
              child: Text('SIGN IN', style: TextStyle(fontSize: 15)),
            ),
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }

  Future<void> signIn(bool autoLogin) async {
    // try {
    var connectivityResult = await (_futureJwt = logIn(_userid, _password,autoLogin));
    if (connectivityResult == '1') {
      onNewToken();
      //_showLoading = false;
      //Navigator.pop(context);
      setState(() {
        _load = false;
      });
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => HomePage()),
          (Route<dynamic> route) => false);
    } else if (connectivityResult == '2') {
      setState(() {
        _load = false;
      });
      Get.snackbar('Error', 'password or user id is wrong',
          colorText: Colors.red, snackPosition: SnackPosition.BOTTOM);
    } else if (connectivityResult == '3') {
      setState(() {
        _load = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('no response from server'),
          backgroundColor: Colors.red,
        ),
      );
    }else if (connectivityResult == '4') {
      setState(() {
        _load = false;
      });
      Get.snackbar('Error', 'you are already logged in another device',
          colorText: Colors.red, snackPosition: SnackPosition.BOTTOM);
    }
  }
}

class NotificationBadge extends StatelessWidget {
  final int totalNotifications;

  const NotificationBadge({required this.totalNotifications});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.0,
      height: 40.0,
      decoration: new BoxDecoration(
        color: Colors.red,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '$totalNotifications',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }
}

void onNewToken() async {
  // Log.d(TAG, "Refreshed token: " + token);

  String? token = await FirebaseMessaging.instance.getToken();

  Map<String, dynamic> json = {
    "Id": globals.userID.toString(),
    "token": token,
  };
  //_values.add(json);
  token = jsonEncode(json);
  logFirebaseToken(token);
}

class PushNotification {
  PushNotification({
    this.title,
    this.body,
    this.dataTitle,
    this.dataBody,
  });

  String? title;
  String? body;
  String? dataTitle;
  String? dataBody;
}
