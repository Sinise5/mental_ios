import 'package:flutter/material.dart';

import '../slide_anim.dart';
import 'login.dart';


class RubahPass_OK extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.check_circle, color: Colors.teal, size: 80.0,),
              SizedBox(height: 16.0),
              Text("Password baru berhasil disimpan! ", style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
              SizedBox(height: 16.0),
              GestureDetector(
                child: Text("lanjut", style: TextStyle(fontSize: 16, color: Colors.teal, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                onTap: (){
                  debugPrint('lanjut');
                  //Navigator.pushReplacement(context, SlideRightRoute(page: Login0()));
                  Navigator.of(context).pop();
                },
              ),

              SizedBox(height: 16.0,),
              //w_loginButton
            ],
          ),
        )
    );
  }

}
