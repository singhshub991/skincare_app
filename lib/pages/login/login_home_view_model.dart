

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../core/enums/view_state.dart';
import '../../core/models/user_model.dart';
import '../../core/others/base_view_model.dart';
import '../../core/others/preferences.dart';
import '../complete_profile/complete_profile.dart';
import '../home/home_page.dart';

class LoginHomeViewModel extends BaseViewModel {

  bool passwordVisibility = true;






  Future<User?> signInWithGoogle(BuildContext context) async {
    try {

      GoogleSignIn googleSignIn = GoogleSignIn();
      if(await googleSignIn.isSignedIn()) {
        await googleSignIn.disconnect();
      }
      // Trigger the Google Sign-In process
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) return null;
      setState(ViewState.busy);
      // Obtain authentication details
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in with Firebase
      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      if(userCredential.additionalUserInfo!.isNewUser){
        String uid= userCredential.user!.uid;
        String? email= userCredential.user!.email;
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
          Navigator.push(context, MaterialPageRoute( builder: (_) =>  completeProfile(model:model)));

        });
      }
      else if (userCredential.user != null) {
        String uid= userCredential.user!.uid;

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
            else{
        setState(ViewState.idle);
              Fluttertoast.showToast(msg: "Email Not Valid");
            }
      return userCredential.user;
    } catch (e) {
      setState(ViewState.idle);
      print("Error signing in with Google: $e");
      return null;
    }
  }

  }

