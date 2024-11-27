import 'package:flutter/material.dart';

import '../slide_anim.dart';
import 'login.dart';


class DaftarOK_0 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.check_circle, color: Colors.teal, size: 80.0,),
                SizedBox(height: 16.0),
                Text("Berhasil mendaftar! ", style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                SizedBox(height: 16.0),
                GestureDetector(
                  child: Text("silahkan Login untuk masuk aplikasi", style: TextStyle(fontSize: 16, color: Colors.teal, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                  onTap: (){
                    debugPrint('masuuuk');
                    Navigator.pushReplacement(context, SlideRightRoute(page: Login0()));
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
