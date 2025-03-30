

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:skincare_app/pages/login/login_home.dart';

import '../core/others/preferences.dart';
import 'home/home_page.dart';
import 'package:intl/intl.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {



  @override
  void didChangeDependencies() {
    _initialSetup();
    super.didChangeDependencies();
  }

  _initialSetup() async {
   await Future.delayed(Duration(seconds: 2));
   bool? isLogin = await StorageUtils.getBool("isLogin");

   debugPrint("islogin:${isLogin}");
   if(isLogin !=null && isLogin){
    await loadDailySkincareRoutine();
     Navigator.pushAndRemoveUntil(
       context,
       MaterialPageRoute(builder: (context) => HomeScreen()),
           (Route<dynamic> route) => false,
     );
   }else {
     Navigator.pushAndRemoveUntil(
       context,
       MaterialPageRoute(builder: (context) => loginHome()),
           (Route<dynamic> route) => false,
     );
   }

  }

  Future<void> loadDailySkincareRoutine() async {
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    String? uid= await StorageUtils.getString("uid");
    CollectionReference skincareRef = FirebaseFirestore.instance
        .collection('usersData')
        .doc(uid)
        .collection('skincareRoutine');

    DocumentSnapshot doc = await skincareRef.doc(today).get();

    if (!doc.exists) {
      // Initialize new daily routine with empty values
      List<Map<String,dynamic>> defaultRoutine = [
        {
          "name": "Cleanser",
          "description": "Cetaphil Gentle Cleanser",
          "timestamp": "",
          "imageUrl": "",
          "isDone": false
        },
        {
          "name": "Toner",
          "description": "Thayers Witch Hazel Toner",
          "timestamp": "",
          "imageUrl": "",
          "isDone": false
        },
        {
          "name": "Moisturizer",
          "description": "Kiehl's Ultra Facial Cream",
          "timestamp": "",
          "imageUrl": "",
          "isDone": false
        },
        {
          "name": "Sunscreen",
          "description": "Supergoop Unseen Sunscreen SPF 40",
          "timestamp": "",
          "imageUrl": "",
          "isDone": false
        },
        {
          "name": "Lip Balm",
          "description": "Glossier Balm Dotcom",
          "timestamp": "",
          "imageUrl": "",
          "isDone": false
        }
      ];

      // for (var item in defaultRoutine) {
        await skincareRef.doc(today).set(
          {
            "routines": defaultRoutine, // Save the entire list
          }, // No need for explicit casting anymore
          // SetOptions(merge: true),
        );
      // }
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color(0XFFFCF7FA),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
             Image.asset("assets/images/icon.png",height: 160,width: 160,)

            ],
          )),
    );
  }
}
