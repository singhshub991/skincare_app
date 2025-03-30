

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../core/enums/view_state.dart';
import '../../core/models/user_model.dart';
import '../../core/others/base_view_model.dart';
import '../../core/others/preferences.dart';
import '../../main.dart';
import '../complete_profile/complete_profile.dart';
import '../home/home_page.dart';

class SignUpViewModel extends BaseViewModel {
  final formKey = GlobalKey<FormState>();

  bool passwordVisibility = true;
  bool ConfirmpasswordVisibility = true;

  togglePasswordVisibility() {
    setState(ViewState.busy);
    passwordVisibility = !passwordVisibility;
    setState(ViewState.idle);
  }
  toggleConfirmPasswordVisibility() {
    setState(ViewState.busy);
    ConfirmpasswordVisibility = !ConfirmpasswordVisibility;
    setState(ViewState.idle);
  }

  requestSignUp(String email, String password, String Confirmpassword,BuildContext context) async {
    setState(ViewState.busy);
    UserCredential? credentil;
    if(password != Confirmpassword){
      Fluttertoast.showToast(msg:"Password and Confirm Password are not same");
      setState(ViewState.idle);
      return;
    }
    if(email.isEmpty ||password.isEmpty){
      Fluttertoast.showToast(msg:"All fields are required");
      setState(ViewState.idle);
      return;
    }

    try{
      credentil= await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);

      if(credentil.user!=null){
        String uid= credentil.user!.uid;
        userModal model=userModal(
          uId: uid,
          email:email,
          fullName: "",
          profilePic: null,
          phoneNo: "",

        );
        await StorageUtils.saveString(
            "uid",uid);
        FirebaseFirestore.instance.collection("user").doc(uid).set(model.toJson()).then((value) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("New User Created !!")));
          setState(ViewState.idle);
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute( builder: (_) =>  completeProfile(model:model)), (Route<dynamic> route) => false,);

        });
      }

    }on FirebaseAuthException catch(e){
      setState(ViewState.idle);

      Fluttertoast.showToast(msg:"${e.code.toString()}");

    };


  }
}
