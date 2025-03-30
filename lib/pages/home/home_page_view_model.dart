

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../core/enums/view_state.dart';
import '../../core/models/skin_care_model.dart';
import '../../core/models/user_model.dart';
import '../../core/others/base_view_model.dart';
import '../../core/others/preferences.dart';
import '../home/home_page.dart';
import 'package:intl/intl.dart';
class HomePageViewModel extends BaseViewModel {
  List<skincareModel>? skincareList;
  userModal? data;
  HomePageViewModel(){
    loadDailySkincareRoutine();
     getHomeData();
  }


  getHomeData() async {
    try{
      setState(ViewState.busy);
      String? uid= await StorageUtils.getString("uid");

      if(uid !=null && uid.isNotEmpty) {
        DocumentSnapshot userData = await FirebaseFirestore.instance.collection("user").doc(uid).get();

        data = userModal.fromJson(userData.data() as Map<String, dynamic>);

        // setState(ViewState.idle);
      }
      notifyListeners();
      setState(ViewState.idle);
    }on FirebaseAuthException catch(e){
      setState(ViewState.idle);
      Fluttertoast.showToast(msg:"${e.code.toString()}");

    };
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
}
