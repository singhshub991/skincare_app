

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/enums/view_state.dart';
import '../../core/models/skin_care_model.dart';
import '../../core/models/user_model.dart';
import '../../core/others/base_view_model.dart';
import '../../core/others/preferences.dart';
import '../home/home_page.dart';
import 'package:intl/intl.dart';
class RoutineScreenViewModel extends BaseViewModel {
  List<skincareModel>? skincareList;
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

  String? imageUrl;
  RoutineScreenViewModel(){

    fetchSkincareRoutine();
  }


  Future<void> fetchSkincareRoutine() async {
    setState(ViewState.busy);
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    String? uid = await StorageUtils.getString("uid");
    try {
      CollectionReference skincareRef = FirebaseFirestore.instance
          .collection('usersData')
          .doc(uid)
          .collection('skincareRoutine');
      DocumentSnapshot snapshot = await skincareRef.doc(today).get();
      // DocumentSnapshot snapshot =
      // await _firestore.collection("skincare").doc(today).get();

      if (snapshot.exists) {
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

        if (data != null) {
          List<dynamic> routines = data["routines"] ?? [];

          // setState(() {
          skincareList = routines.map((item) => skincareModel.fromJson((item))).toList();
          setState(ViewState.idle);
          // });
        }
      }else{

        await skincareRef.doc(today).set(
          {
            "routines": defaultRoutine, // Save the entire list
          }, // No need for explicit casting anymore
        );

        int doneCount = defaultRoutine.where((item) => item["isDone"] == true).length;
        updateStreak(uid!,doneCount);
        DocumentSnapshot snapshot = await skincareRef.doc(today).get();
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

        if (data != null) {
          List<dynamic> routines = data["routines"] ?? [];

          skincareList = routines.map((item) => skincareModel.fromJson((item))).toList();
          setState(ViewState.idle);
        }
      }
      setState(ViewState.idle);
    }on FirebaseAuthException catch(e){
      setState(ViewState.idle);
      Fluttertoast.showToast(msg:"${e.code.toString()}");

    };

  }

  Future<void> updateSkincareItem({required String today,
    required String itemName, required bool isDone, required String timeStamp, required String url}) async {
    String? uid = await StorageUtils.getString("uid");
    setState(ViewState.busy);
    CollectionReference skincareRef = FirebaseFirestore.instance
        .collection('usersData')
        .doc(uid)
        .collection('skincareRoutine');
    DocumentReference docRef = FirebaseFirestore.instance.collection('usersData')
        .doc(uid)
        .collection('skincareRoutine').doc(today);
    DocumentSnapshot snapshot = await skincareRef.doc(today).get();

    if (snapshot.exists) {
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

      if (data != null && data.containsKey("routines")) {
        List<dynamic> routines = data["routines"];

        // 🔥 Us particular item ko find karo aur update karo
        for (var item in routines) {
          if (item["name"] == itemName) {
            item["isDone"] = isDone;
            item["imageUrl"] = url;
            item["timestamp"] = timeStamp;

            break;
          }
        }

        // ✅ Updated list wapas Firestore me save karo
        await docRef.update({"routines": routines});
        int doneCount = routines.where((item) => item["isDone"] == true).length;
        updateStreak(uid!,doneCount);
        Fluttertoast.showToast(msg: "✅ Item updated successfully!");
        fetchSkincareRoutine();
        setState(ViewState.idle);
      }
    }
  }

  Future<void> updateStreak(String userId, int skincareCount) async {
    final docRef = FirebaseFirestore.instance.collection("usersStreak").doc(userId);

    // Aaj ki date
    String today = DateTime.now().toIso8601String().split("T")[0];
    DocumentSnapshot docSnap = await docRef.get();
    if (docSnap.exists) {
      // 🔄 Document exists → Update Streaks Array
      await docRef.update({
        "streaks": FieldValue.arrayUnion([
          {"date": today, "count": skincareCount}
        ])
      });
    }
    else {
      // 🆕 Document doesn't exist → Create new document
      await docRef.set({
        "streaks": [
          {"date": today, "count": skincareCount}
        ]
      });
    }
  }


    void selectImage(ImageSource source,int index,String fileName) async{
      XFile? pickedFile= await ImagePicker().pickImage(source: source);
      if(pickedFile !=null){
        cropImage(pickedFile,index,fileName);
      }
    }
    void cropImage(XFile file,int index,String name) async{
      CroppedFile? croppedimage=await ImageCropper().cropImage(
          sourcePath: file.path,
          aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
          compressQuality: 30
      );
      if(croppedimage !=null){
        setState(ViewState.busy);

        File image=File(croppedimage.path);
        upload( image,index,name);
      }
    }
    void upload(File image,int index,String fileName) async{
      String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      String formattedTime = DateFormat('h:mm a').format(DateTime.now());
      UploadTask uploadTask=FirebaseStorage.instance.ref().child('status/$today/$fileName!').putFile(image!);
      TaskSnapshot snapShot=await uploadTask;
      imageUrl=await snapShot.ref.getDownloadURL();
      updateSkincareItem(today: today, itemName:skincareList![index].name!, isDone: true, timeStamp:formattedTime , url: imageUrl!);
      setState(ViewState.idle);
    }

}
