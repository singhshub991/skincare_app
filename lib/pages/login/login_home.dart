import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:skincare_app/core/enums/view_state.dart';
import 'package:skincare_app/pages/login/login.dart';
import 'package:skincare_app/pages/sign_up/sign_up.dart';

import '../../utils/background_design.dart';
import '../forget_password/forget_password.dart';
import 'login_home_view_model.dart';


class loginHome extends StatefulWidget {
  const loginHome({super.key});

  @override
  State<loginHome> createState() => _loginHomeState();
}

class _loginHomeState extends State<loginHome> {
  TextEditingController emailController= TextEditingController();
  @override
  Widget build(BuildContext context) {
    return   ChangeNotifierProvider(
      create: (_) => LoginHomeViewModel(),
      child:  Consumer<LoginHomeViewModel>(
          builder: (context, model, child) {
          return ModalProgressHUD(
            opacity: 0.5,
            progressIndicator: CircularProgressIndicator(color: Color(0XFF964F66),),
            inAsyncCall: model.state == ViewState.busy,
            child: Scaffold(
              resizeToAvoidBottomInset:false,
              backgroundColor: Color(0XFFFCF7FA),
              body: Stack(
                children: [

                  CustomPaint(
                    size: Size(MediaQuery.of(context).size.width, 250),
                    painter: HeaderPainter(),
                  ),


                  Positioned(
                    top: 100,
                    left: 20,
                      child: Text("Log in", style:
                      TextStyle(fontSize: 50,
                          color: Colors.white,))),
                  // Bottom Sheet
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 40.0),
                        child: Opacity(
                            opacity: 0.3,
                            child: Image.asset("assets/images/login.png",height: 250,width: 250,)),
                      )),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: _buildBottomSheet(context,model),
                  ),
                ],
              ),

            ),
          );
        }
      ),
    );
  }


  Widget _buildBottomSheet(BuildContext context,LoginHomeViewModel model) {

    return Container(

      height: MediaQuery.of(context).size.height * 0.70,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
color:Color(0XFFF2E8EB).withOpacity(0.2),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
       
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          SizedBox(height: 30),

          SizedBox(height: 20),
          TextField(
            controller: emailController,
            decoration: InputDecoration(

              filled: true,
              fillColor: Colors.white,
              hintText: "Email",
              hintStyle: TextStyle(color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Color(0XFF964F66)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Color(0XFF964F66)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Color(0XFF964F66), width: 2),
              ),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async{
              if(emailController.text.isNotEmpty) {
                     Navigator.push(context, MaterialPageRoute(builder: (context) => login(email: emailController.text,)));

              }else{
                Fluttertoast.showToast(msg: "Email Field is Required");
              }
            },
            child: Text("Continue"),
            style: ElevatedButton.styleFrom(
              backgroundColor:  Color(0XFF964F66),
              foregroundColor: Colors.white,
              minimumSize: Size(150, 50),
            ),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Divider(
                  thickness: 1,
                  color: Colors.black,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text("Or", style: TextStyle(color: Colors.black)),
              ),
              Expanded(
                child: Divider(
                  thickness: 1,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),

          /// 🌟 **Social Login Buttons**
          _buildSocialButton("Continue with Google","assets/images/google.png", Colors.grey.shade100,model),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(context,  MaterialPageRoute( builder: (_) =>  ForgetPassword()));
                },
                child: Text(
                  "Forgotten Password?",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    // decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("Don't have an account? ", style: TextStyle(color: Colors.black)),
              InkWell(
                onTap: () {

                  Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp() ));
                },
                child: Text(
                  "Sign Up",
                  style: TextStyle(color: Color(0XFF964F66),
                      fontWeight: FontWeight.bold,

                  ),
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }

  Widget _buildSocialButton(String text,String icon, Color colorn,LoginHomeViewModel model) {
    return ElevatedButton(
      onPressed: () async{

         model.signInWithGoogle(context);


      },

      child: Row(mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(icon, height: 25, width: 25),
          SizedBox(width: 10),
          Text(text, style: TextStyle(color: Colors.black)),
        ],
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
            side: BorderSide(color: Color(0XFF964F66)),
            borderRadius: BorderRadius.circular(10)),
        minimumSize: Size(double.infinity, 60),
      ),
    );
  }


}
