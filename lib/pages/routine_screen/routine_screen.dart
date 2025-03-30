import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:skincare_app/core/enums/view_state.dart';
import 'package:skincare_app/core/models/skin_care_model.dart';
import 'package:skincare_app/pages/home/home_page_view_model.dart';
import 'package:skincare_app/pages/login/login_home.dart';
import 'package:skincare_app/pages/routine_screen/routine_Screen_view_model.dart';
import 'package:intl/intl.dart';

import '../../core/others/preferences.dart';
import '../complete_profile/complete_profile.dart';
class RoutineScreen extends StatefulWidget {
  @override
  State<RoutineScreen> createState() => _RoutineScreenState();
}

class _RoutineScreenState extends State<RoutineScreen> {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RoutineScreenViewModel(),
      child:  Consumer<RoutineScreenViewModel>(
          builder: (context, model, child) {
          return ModalProgressHUD(
            opacity: 0.5,
            progressIndicator: CircularProgressIndicator(color: Color(0XFF964F66),),
            inAsyncCall: model.state == ViewState.busy,
            child: Scaffold(
              backgroundColor: Color(0XFFFCF7FA),

              body:model.skincareList !=null ? ListView.builder(
                itemCount: model.skincareList?.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  // String step = skincareSteps[index].keys.first;
                  // String product = skincareSteps[index][step];

                  return ListTile(
                    onTap: (){
                      model.selectImage(ImageSource.camera,index,model.skincareList![index].name!);
                    },
                    leading: Container(

                      decoration: BoxDecoration( color:Color(0XFFF2E8EB) ,borderRadius: BorderRadius.circular(10)),
                      child: Checkbox(
                         side: BorderSide.none,
                          value:model.skincareList?[index].isDone,
                          activeColor:Colors.transparent,
                          checkColor: Color(0XFF964F66),
                          onChanged: (val) {


                          }

                      ),
                    ),
                    title: Text(model.skincareList![index].name!),
                    subtitle: Text(model.skincareList![index].description!,style: TextStyle(color:  Color(0XFF964F66)),),
                    trailing: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if(model.skincareList![index].imageUrl!.isEmpty)
                        Icon(Icons.camera_alt_outlined),
                        if(model.skincareList![index].imageUrl!.isNotEmpty)
                          InkWell(
                            onTap: (){
                              ShowCapturedWidget(context,model.skincareList![index].imageUrl!);
                            },
                            child: Container(
                              height: 25,width: 25,
                              decoration:  BoxDecoration(
                                color: Colors.black,
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image:
                                    NetworkImage( model.skincareList![index].imageUrl!)
                                ),
                              ),
                            ),
                          ),
                          // Image.network(model.skincareList![index].imageUrl!),
                        if(model.skincareList![index].imageUrl!.isNotEmpty)
                          Text(model.skincareList![index].timestamp!)
                      ],
                    ),
                  );
                },
              ) : SizedBox(),
            ),
          );
        }
      ),
    );
  }

  Future<dynamic> ShowCapturedWidget(
      BuildContext context, String capturedImage) {
    return showDialog(
      useSafeArea: false,
      barrierColor:Color(0XFFFCF7FA).withOpacity(0.9),
      barrierDismissible:false,
      context: context,

      builder: (context) =>  SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InteractiveViewer(
                panEnabled: true, // Allow dragging
                // boundaryMargin: EdgeInsets.all(20), // Allow going out of bounds
                minScale: 0.5, // Minimum zoom
                maxScale: 4.0,
                child: Image.network(capturedImage,height:MediaQuery.of(context).size.height*0.5,width:MediaQuery.of(context).size.width*0.9,)),
            SizedBox(height: 0,)
          ],
        ),
      ),
    );
  }
}