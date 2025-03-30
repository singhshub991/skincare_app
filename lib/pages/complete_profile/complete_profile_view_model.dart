

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/enums/view_state.dart';
import '../../core/models/user_model.dart';
import '../../core/others/base_view_model.dart';
import '../../core/others/preferences.dart';
import '../../main.dart';
import '../complete_profile/complete_profile.dart';
import '../home/home_page.dart';

class CompleteProfileViewModel extends BaseViewModel {
  final formKey = GlobalKey<FormState>();
  File? profileImage;
  String? uId;
  // String? preProfileImage;
  String? imageUrl;


  void selectImage(ImageSource source) async{
    XFile? pickedFile= await ImagePicker().pickImage(source: source);
    if(pickedFile !=null){
      cropImage(pickedFile);
    }
  }
  void cropImage(XFile file) async{
    CroppedFile? croppedimage=await ImageCropper().cropImage(
        sourcePath: file.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 30
    );
    if(croppedimage !=null){
      setState(ViewState.busy);

      profileImage=File(croppedimage.path);
      upload();
    }
  }
  void upload() async{

    UploadTask uploadTask=FirebaseStorage.instance.ref().child(uId!).putFile(profileImage!);
    TaskSnapshot snapShot=await uploadTask;
    imageUrl=await snapShot.ref.getDownloadURL();
    setState(ViewState.idle);
  }
  void selecPhotoOption(BuildContext context,String userUid) async{
    uId=userUid;
    await  showDialog<void>(context: context, builder: (context){
      return AlertDialog(
        title: Text("Upload Profile picture"),
        content: Column(mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              onTap: (){
                Navigator.pop(context);
                selectImage(ImageSource.gallery);
              },
              title:  Text("Select from Gallery"),
            ),
            ListTile(
              onTap: (){
                Navigator.pop(context);
                selectImage(ImageSource.camera);

              },
              title: Text("Take Picture"),
            ),
          ],
        ),
      );
    });
  }


  updateData( userModal userData,String name,String number,String email,String? url,BuildContext context) async{
    String? uid= await StorageUtils.getString("uid");

    if(imageUrl== null && url !=null){
      imageUrl=url;
    }
    setState(ViewState.busy);
    if(name.isEmpty ||number.isEmpty||email.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("All Fields are Mandatory")));
      setState(ViewState.idle);
      return;
    }
    if(imageUrl==null){
      setState(ViewState.idle);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("All Fields are Mandatory")));
      return;
    }
    userData!.profilePic=imageUrl;
    userData.phoneNo=number;
    userData.fullName=name;
    userData.email=email;
    await FirebaseFirestore.instance.collection("user").doc(uid).set(userData.toJson());
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Data Uploaded Successfuly")));
    await StorageUtils.saveBool(
        "isLogin", true);
    setState(ViewState.idle);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
          (Route<dynamic> route) => false,
    );
  }

}
