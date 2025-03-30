

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
import '../login/login_home.dart';

class ForgetPasswordViewModel extends BaseViewModel {

  requestForgetPassword(String email, BuildContext context) async {
    setState(ViewState.busy);
    if (email.isEmpty) {
      setState(ViewState.idle);

        Fluttertoast.showToast(msg: "Please enter your email");
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      setState(ViewState.idle);
     Fluttertoast.showToast(msg: "Password reset email sent! Check your inbox.");
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => loginHome()),
            (Route<dynamic> route) => false,
      );


    } catch (e) {
      setState(ViewState.idle);
      String errorMessage;
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case "user-not-found":
            errorMessage = "No user found with this email.";
            break;
          case "invalid-email":
            errorMessage = "Invalid email format.";
            break;
          default:
            errorMessage = "Something went wrong. Try again.";
        }
      } else {
        errorMessage = "An error occurred.";
      }

     Fluttertoast.showToast(msg: errorMessage);
    }
  }
}
