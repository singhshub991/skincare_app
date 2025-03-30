import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:skincare_app/core/enums/view_state.dart';
import 'package:skincare_app/pages/home/home_page_view_model.dart';

import '../../core/others/preferences.dart';
import '../complete_profile/complete_profile.dart';
import '../login/login_home.dart';
import '../routine_screen/routine_screen.dart';
import '../streaks_screen/streaks_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [RoutineScreen(), StreakScreen()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomePageViewModel(),
      child:  Consumer<HomePageViewModel>(
          builder: (context, model, child) {
          return ModalProgressHUD(
            opacity: 0.5,
            progressIndicator: CircularProgressIndicator(color: Color(0XFF964F66),),
            inAsyncCall: model.state == ViewState.busy,
            child: Scaffold(
              appBar: AppBar(
                title: _selectedIndex == 0 ? Text("Daily Skincare") : Text("Streaks"),
                centerTitle: true,elevation: 0,
                backgroundColor: Color(0XFFF2E8EB),
                actions: [
                  PopupMenuButton<String>(
                    color: Colors.white,
                    icon: Icon(Icons.more_vert,), // Icon for the popup menu
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem<String>(
                          value: 'Edit',
                          child: ListTile(
                            // contentPadding: EdgeInsets.symmetric(horizontal: 4),
                            leading: Icon(Icons.person_rounded),
                            title: Text('Edit Profile'),
                          ),
                        ),

                        PopupMenuItem<String>(
                          value: 'logout',
                          child: ListTile(
                            // contentPadding: EdgeInsets.symmetric(horizontal: 4),

                            leading: Icon(Icons.logout),
                            title: Text('Logout'),
                          ),
                        ),

                      ];
                    },
                    onSelected: (value) async {
                      switch(value){
                        case 'Edit':
                          Navigator.push(context, MaterialPageRoute( builder: (_) =>  completeProfile(model:model.data)));
                          break;
                        case 'logout':
                          await StorageUtils.saveBool(
                              "isLogin", false);
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute( builder: (_) =>  loginHome()),(route) => false,);
                          break;

                      }
                    },
                    // Decoration for the popup menu
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    // color: Colors.white,
                    elevation: 4,

                  )
                ],
              ),
              body: _screens[_selectedIndex],
              bottomNavigationBar: BottomNavigationBar(
                selectedItemColor: Color(0XFF964F66),
                unselectedItemColor: Colors.grey,
                backgroundColor: Color(0XFFF2E8EB),
                items: [
                  BottomNavigationBarItem(icon: Icon(Icons.list,color:  Color(0XFF964F66),), label: 'Routine'),
                  BottomNavigationBarItem(icon: Icon(Icons.bar_chart,color:  Color(0XFF964F66),), label: 'Streaks'),
                ],
                currentIndex: _selectedIndex,
                onTap: _onItemTapped,
              ),
            ),
          );
        }
      ),
    );
  }
}