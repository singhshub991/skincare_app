import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:skincare_app/pages/login/login_home.dart';


import '../../core/enums/view_state.dart';
import '../../utils/background_design.dart';
import 'forget_password_view_model.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  TextEditingController emailController= TextEditingController();
  TextEditingController passwordController= TextEditingController();
  TextEditingController ConfirmPasswordController= TextEditingController();
  @override
  Widget build(BuildContext context) {
    return  ChangeNotifierProvider(
      create: (_) => ForgetPasswordViewModel(),
      child:Consumer<ForgetPasswordViewModel>(
          builder: (context, model, child) {
            return ModalProgressHUD(
              opacity: 0.5,
              progressIndicator: CircularProgressIndicator(color:Color(0XFF964F66),),
              inAsyncCall: model.state == ViewState.busy,
              child: Scaffold(
                resizeToAvoidBottomInset:false,
                backgroundColor: Colors.grey.shade100,
                body:Stack(
                  children: [
                    // Background Image
                    CustomPaint(
                      size: Size(MediaQuery.of(context).size.width, 250),
                      painter: HeaderPainter(),
                    ),

                    Positioned(
                        top: 70,
                        left: 16,
                        child: Text("Reset\n Password", style:
                        TextStyle(fontSize: 40,
                          color: Colors.white,))),
                    Positioned(
                      top: 40,left: 20,
                      child:  InkWell(
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.arrow_back,
                              color: Colors.white, size: 28)),),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 40.0),
                          child: Opacity(
                              opacity: 0.3,
                              child: Image.asset("assets/images/login.png",height: 250,width: 250,)),
                        )),
                    // Content
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.70,
                        decoration: BoxDecoration( color: Color(0XFFF2E8EB).withOpacity(0.2),borderRadius: BorderRadius.only(topLeft:Radius.circular(25),topRight: Radius.circular(25))),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                          child: Column(
                            // mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 30),
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
                                    borderSide: BorderSide(color:Color(0XFF964F66), width: 2),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              // Continue Button
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () {
                                    model.requestForgetPassword(emailController.text, context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:  Color(0XFF964F66), // Button Color
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Text(
                                    "Reset Password",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(height: 10),
                              InkWell(
                                  onTap: (){
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(builder: (context) => loginHome()),
                                          (Route<dynamic> route) => false,
                                    );
                                  },
                                  child: Text("Back to Login",
                                      style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    decoration: TextDecoration.underline,))),

                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),


              ),
            );
          }
      ),
    );
  }
}
