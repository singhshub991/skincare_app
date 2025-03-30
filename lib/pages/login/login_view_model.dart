

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../core/enums/view_state.dart';
import '../../core/models/user_model.dart';
import '../../core/others/base_view_model.dart';
import '../../core/others/preferences.dart';
import '../home/home_page.dart';

class LoginViewModel extends BaseViewModel {
  final formKey = GlobalKey<FormState>();
  bool passwordVisibility = true;

  togglePasswordVisibility() {
    setState(ViewState.busy);
    passwordVisibility = !passwordVisibility;
    setState(ViewState.idle);
  }

  requestLogin(String email, String password,BuildContext context) async {
    setState(ViewState.busy);
    UserCredential? credentil;
    if(email.isEmpty ||password.isEmpty){
      Fluttertoast.showToast(msg:"All fields are required");
      setState(ViewState.idle);
      return;
    }

      try{
        credentil= await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);

        if(credentil.user!=null){
          String uid= credentil.user!.uid;

          DocumentSnapshot userData= await  FirebaseFirestore.instance.collection("user").doc(uid).get();

          userModal data= userModal.fromJson(userData.data() as Map<String,dynamic>);
          Fluttertoast.showToast(msg:"Login Successfully !!");

          await StorageUtils.saveBool(
              "isLogin", true);

          await StorageUtils.saveString(
              "uid",uid);
          setState(ViewState.idle);
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
                (Route<dynamic> route) => false,
          );
        }

      }on FirebaseAuthException catch(e){
        setState(ViewState.idle);

        Fluttertoast.showToast(msg:"${e.code.toString()}");

      };



  }

}
