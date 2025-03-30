import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:skincare_app/core/others/preferences.dart';
import 'package:skincare_app/pages/forget_password/forget_password.dart';
import 'package:skincare_app/pages/login/login_view_model.dart';

import '../../core/enums/view_state.dart';
import '../../utils/background_design.dart';
import 'login_home.dart';

class login extends StatefulWidget {

  String? email;
   login({super.key, this.email});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  TextEditingController emailController= TextEditingController();
  TextEditingController passwordController= TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.email !=null) {
      emailController.text = widget.email!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return   ChangeNotifierProvider(
      create: (_) => LoginViewModel(),
      child: Consumer<LoginViewModel>(
          builder: (context, model, child) {

          return ModalProgressHUD(
            opacity: 0.5,
            progressIndicator: CircularProgressIndicator(color: Color(0XFF964F66),),
            inAsyncCall: model.state == ViewState.busy,
            child: Scaffold(
              resizeToAvoidBottomInset:false,
              backgroundColor: Color(0XFFFCF7FA),
              body:Stack(
                children: [
                  // Background Image
                  CustomPaint(
                    size: Size(MediaQuery.of(context).size.width, 250),
                    painter: HeaderPainter(),
                  ),
                  // CustomPaint(
                  //   size: Size(MediaQuery.of(context).size.width,130),
                  //   painter: HeaderPainterYellow(),
                  // ),

            
                  Positioned(
                      top: 100,
                      left: 20,
                      child: Text("Log in", style:
                      TextStyle(fontSize: 50,
                        color: Colors.white,))),
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
                      decoration: BoxDecoration(color: Color(0XFFF2E8EB).withOpacity(0.2),borderRadius:  BorderRadius.only(topLeft:Radius.circular(25),topRight: Radius.circular(25))),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 60),
                        child: Column(
                          // mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [

                         TextField(
                         controller: emailController,
                              decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              enabled: false,
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
                              disabledBorder:OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Color(0XFFF2E8EB) ),
            ) ,
                              focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Color(0XFF964F66), width: 2),
                              ),
                              ),
                              ),
            
                            SizedBox(height:20),
            
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
            
                            // Continue Button
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () {
                                  model.requestLogin(emailController.text, passwordController.text, context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:  Color(0XFF964F66), // Button Color
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  "Log in",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
            
                            SizedBox(height: 20),
            
                            // Forgot Password
                            InkWell(
                              onTap: () {
                               Navigator.push(context,  MaterialPageRoute( builder: (_) =>  ForgetPassword()));
                                },
                              child: Text(
                                "Forgotten Password?",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                            //change account
                            InkWell(
                              onTap: () {
                               StorageUtils.remove("uid");
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (context) => loginHome()),
                                      (Route<dynamic> route) => false,
                                );
                              },
                              child: Text(
                            "Select Another Account ",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,

                                  decoration: TextDecoration.underline,
                                ),
                              ),
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
