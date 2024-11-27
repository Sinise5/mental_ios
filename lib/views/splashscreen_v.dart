import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:async';
import '../konfig000.dart';
import 'intro_screen.dart';

class SplashScreenPage extends StatefulWidget {
  @override
    _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage>{


  String idf_user = "";
  String nama_user = "";


  @override
  void initState(){
    super.initState();
    getUserPrefs();
    startSplashScreen();
  }

  startSplashScreen() async {
    var duration = const Duration(seconds: 5);
    return Timer(duration, (){

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_){
          //if(idf_user==""){ return LoginPage(); }
          //else { return HomePage(); }

          return OnboardScreen();
        })
      );

    });
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    Widget w_tengah = Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          //SizedBox(height: 10,),
          Image.asset("assets/logo01_rejiwa.png", width: 200, height: 230 ),
          //Text("Sistem Informasi Monitoring Serayu Opak", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16)),
          //SizedBox(height: 200,)
        ],
      ),
    );

    Widget w_bawah2 = Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                SizedBox(
                    height: 5,
                    width: 222,
                    child:
                    LinearProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.tealAccent.shade400),
                        backgroundColor: Colors.tealAccent.shade100,
                    )
                ),
                SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("."),
                    Text("versi " + AppConfig().mob_Version + "  ... ", style: TextStyle(color: Colors.grey, fontSize: 11)),
                  ],
                )
              ],
            )
        )
    );


    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          /*
          Image(
            image: AssetImage("assets/images/bg_splash.jpg"),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            fit: BoxFit.cover,
          ), */
          w_tengah,
          w_bawah2,

        ],
      )
    );
  }

  getUserPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      idf_user = prefs.getString("idf_user") ?? "";
      nama_user = prefs.getString("nama_user") ?? "";
    });
  }


}
