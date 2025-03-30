import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:skincare_app/pages/splash.dart';

late final FirebaseApp app;
late final FirebaseAuth auth;
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  if(Platform.isAndroid) {
    app= await Firebase.initializeApp(
        options: FirebaseOptions(
          apiKey: "AIzaSyAUo6wVaxvQlFfXRpk0MEDdvGO4uiB5nBo",
          appId: "1:688990985034:android:a5add28c16680ffebb7fb3",
          projectId: "chatapp-a73b0",
          storageBucket: "chatapp-a73b0.appspot.com",
          messagingSenderId: '688990985034',
        )
    );
    auth = FirebaseAuth.instanceFor(app: app);
  }
  else{
    await Firebase.initializeApp();
  }
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:false,
      theme: ThemeData(
        useMaterial3: true,
        appBarTheme:  AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor:Color(0XFFF2E8EB),
                statusBarIconBrightness:Brightness.dark,
              systemNavigationBarIconBrightness: Brightness.dark,
              systemNavigationBarColor:Color(0XFFF2E8EB)
            )
        ),
      ),
      home: SplashScreen(),
    );
  }
}


