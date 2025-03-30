import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:skincare_app/pages/login/login_home.dart';
import 'package:skincare_app/pages/sign_up/sign_up_view_model.dart';

import '../../core/enums/view_state.dart';
import '../../utils/background_design.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController emailController= TextEditingController();
  TextEditingController passwordController= TextEditingController();
  TextEditingController ConfirmPasswordController= TextEditingController();
  @override
  Widget build(BuildContext context) {
    return  ChangeNotifierProvider(
      create: (_) => SignUpViewModel(),
      child:Consumer<SignUpViewModel>(
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
                      top: 100,
                      left: 16,
                      child: Text("Sign Up", style:
                      TextStyle(fontSize: 45,
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

                            const Text(
                              "Look like you don't have an account.\nLet's create a new account ..",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 18,
                                color: Color(0XFF964F66),
                                fontWeight: FontWeight.w500,
                              ),
                            ),

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
                                  borderSide: BorderSide(color:Color(0XFF964F66)),
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

                            // Password TextField
                            TextField(
                              controller: passwordController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText: "Password",
                                hintStyle: TextStyle(color: Colors.grey),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Color(0XFF964F66)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Color(0XFF964F66), width: 2),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    model.passwordVisibility ? Icons.visibility : Icons.visibility_off,color: Color(0XFF964F66),
                                  ),
                                  onPressed: () {
                                    model.togglePasswordVisibility();
                                  },
                                ),
                              ),
                              obscureText: model.passwordVisibility,
                            ),

                            SizedBox(height: 20),

                            // Password TextField
                            TextField(
                              controller: ConfirmPasswordController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText: "Confirm Password",
                                hintStyle: TextStyle(color: Colors.grey),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Color(0XFF964F66)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Color(0XFF964F66), width: 2),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    model.ConfirmpasswordVisibility ? Icons.visibility : Icons.visibility_off,color:Color(0XFF964F66),
                                  ),
                                  onPressed: () {
                                    model.toggleConfirmPasswordVisibility();
                                  },
                                ),
                              ),
                              obscureText: model.ConfirmpasswordVisibility,
                            ),

                            SizedBox(height: 20),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Text.rich(
                                TextSpan(
                                  text: "By selecting Agree & Continue below, I agree to our ",
                                  style: TextStyle(color: Colors.black, fontSize: 12),
                                  children: [
                                    TextSpan(
                                      text: "Terms of Service",
                                      style: TextStyle(color: Color(0XFF964F66), fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(text: " and "),
                                    TextSpan(
                                      text: "Privacy Policy",
                                      style: TextStyle(color: Color(0XFF964F66), fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ),

                            // Continue Button
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () {
                                  model.requestSignUp(emailController.text, passwordController.text, ConfirmPasswordController.text, context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0XFF964F66), // Button Color
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  "Agree and Continue",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("Already have an account? ", style: TextStyle(color: Colors.black)),
                                InkWell(
                                  onTap: () {

                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(builder: (context) => loginHome()),
                                          (Route<dynamic> route) => false,
                                    );
                                  },
                                  child: Text(
                                    "Log in",
                                    style: TextStyle(color: Color(0XFF964F66),
                                      fontWeight: FontWeight.bold,

                                    ),
                                  ),
                                ),
                              ],
                            ),

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
