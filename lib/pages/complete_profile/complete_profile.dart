

import 'dart:io';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

import '../../core/enums/view_state.dart';
import '../../core/models/user_model.dart';
import '../../core/others/preferences.dart';
import 'complete_profile_view_model.dart';

class completeProfile extends StatefulWidget {

  userModal? model;

  completeProfile({super.key,this.model});

  @override
  State<completeProfile> createState() => _completeProfileState();
}

class _completeProfileState extends State<completeProfile> {
  File? profileImage;
  // String? preProfileImage;
  String? imageUrl;
  TextEditingController nameControler= TextEditingController();
  TextEditingController noControler= TextEditingController();
  TextEditingController mailControler= TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.model?.fullName !=null){
      nameControler.text=widget.model!.fullName!;
    }
    if(widget.model?.phoneNo !=null){
      noControler.text=widget.model!.phoneNo!;
    } if(widget.model?.email !=null){
      mailControler.text=widget.model!.email!;
    }
    if(widget.model?.profilePic !=null){
      imageUrl=widget.model!.profilePic!;

    }
  }


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CompleteProfileViewModel(),
      child:  Consumer<CompleteProfileViewModel>(
          builder: (context, model, child) {
            // model.imageUrl=imageUrl;
          return ModalProgressHUD(
            opacity: 0.5,
            progressIndicator: CircularProgressIndicator(color: Color(0XFF964F66),),
            inAsyncCall: model.state == ViewState.busy,
            child: Scaffold(
              backgroundColor: Color(0XFFFCF7FA),
              resizeToAvoidBottomInset:false,
              appBar: AppBar(automaticallyImplyLeading: /*widget.model!.fullName!.isEmpty ?false:*/true,
                title: Text("Edit Profile",style: TextStyle(color: Colors.black),),
                backgroundColor: Color(0XFFF2E8EB),
                centerTitle: true,
                  iconTheme:IconThemeData(color: Colors.black)
              ),
              body: Stack(
              // fit: StackFit.expand,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 50),
                  height: 150,
                  decoration: BoxDecoration(color: Color(0XFFF2E8EB),
                      // gradient: const LinearGradient(
                      //     begin: Alignment.bottomCenter,
                      //     end: Alignment.topCenter,
                      //     colors: [Color(0XFFF2E8EB)]),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(50),
                        bottomRight: Radius.circular(50),
                      )),
                ),
                Column(
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                  Center(
                    // top: 20,
                    child: SizedBox(
                      width: 150,
                      height: 150,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Container(
                            decoration:  BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image:  (model.imageUrl ==null && imageUrl ==null) ?
                                  AssetImage("assets/images/userProfile.jpg") :
                                  model.imageUrl !=null ? NetworkImage( model.imageUrl!)
                                      :
                                  NetworkImage( imageUrl!)
                                     ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: InkWell(
                              onTap: (){
                                model.selecPhotoOption(context, widget.model!.uId!);
                              },
                              child: CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.white,
                                child: Container(
                                  // margin: const EdgeInsets.all(8.0),
                                  decoration:  BoxDecoration(
                                       shape: BoxShape.circle,border: Border.all(color:Color(0XFF964F66)) ),
                                  child: Icon(Icons.edit,color: Color(0XFF964F66),),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                      child: TextField(controller: nameControler,
                        decoration: InputDecoration(border: OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Color(0XFF964F66)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Color(0XFF964F66), width: 2),
                            ),
                            labelStyle: TextStyle(color:Color(0XFF964F66) ),
                            labelText: "Full Name"
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                      child: TextField(
                        controller: noControler,
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Color(0XFF964F66)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Color(0XFF964F66), width: 2),
                          ),
                          labelStyle: TextStyle(color:Color(0XFF964F66) ),
                          border: OutlineInputBorder(),
                          labelText: "Phone No.",
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                      child: TextField(
                        controller: mailControler,
                        enabled:widget.model!.email ==null ? true: false,
                        decoration: InputDecoration(border: OutlineInputBorder(),
                            labelText: "Email",
                            hintText: "${ widget.model!.email ?? "Email"}"
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(onPressed: () async{
                   model.updateData(widget.model!, nameControler.text, noControler.text,mailControler.text, model.imageUrl ??imageUrl , context);
                  },
                      child: Text("Update"),style: ElevatedButton.styleFrom(
                    minimumSize: Size(MediaQuery.of(context).size.width*0.9, 50),
                    backgroundColor: Color(0XFF964F66), // Button background color
                    foregroundColor: Colors.white, // Button text color
                    shadowColor: Colors.blueAccent, // Shadow color
                    elevation: 2, // Elevation of the button
                    shape: RoundedRectangleBorder( // Rounded corners
                      borderRadius: BorderRadius.circular(10.0),
                    ),))
                ],)
              ],
                        ),
            ),
          );
        }
      ),
    );
  }
}
