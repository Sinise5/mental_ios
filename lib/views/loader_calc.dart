import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../slide_anim.dart';
import 'test_mental_cemas_res.dart';
import 'test_mental_depresi_res.dart';
import 'test_mental_riskbundiri_res.dart';

class LoaderCalc0 extends StatefulWidget {
  const LoaderCalc0({Key? key}) : super(key: key);

  @override
  State<LoaderCalc0> createState() => _LoaderCalc0State();
}

class _LoaderCalc0State extends State<LoaderCalc0> {

  String sf_loader_calc_to = "";
  late Timer timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getUserPrefs();

    timer = Timer(Duration(seconds: 3), () {
      debugPrint("Yeah, this line is printed after 5 seconds");
      kemanaLompatnya();
    });

  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/loader_calc0.gif",
                    width: MediaQuery.of(context).size.width - 100 ,
                  ),
                ]
            )
        )
    );
  }


  getUserPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    var a = prefs.getString("sf_loader_calc_to") ?? "";
    getUserPrefs_1(a);
  }

  getUserPrefs_1(sf_loader_calc_to0) {
    setState(() {
      sf_loader_calc_to = sf_loader_calc_to0;
    });
  }

  void kemanaLompatnya() {
    if(sf_loader_calc_to != ""){ timer.cancel(); }

    if(sf_loader_calc_to == "TestMentalDepresiResult0"){
      Navigator.pushReplacement(context, SlideRightRoute(page: TestMentalDepresiResult0()));
    }
    else if(sf_loader_calc_to == "TestMentalCemasResult0"){
      Navigator.pushReplacement(context, SlideRightRoute(page: TestMentalCemasResult0()));
    }
    else if(sf_loader_calc_to == "TestMentalRiskBunDiriResult0"){
      Navigator.pushReplacement(context, SlideRightRoute(page: TestMentalRiskBunDiriResult0()));
    }
  }


}

