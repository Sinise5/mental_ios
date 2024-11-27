import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../konfig000.dart';
import '../slide_anim.dart';
import 'test_mental_cemas.dart';

class TestMentalCemasResult0 extends StatefulWidget {
  @override
  _TestMentalCemasResult0State createState() => _TestMentalCemasResult0State();
}

class _TestMentalCemasResult0State extends State<TestMentalCemasResult0> with TickerProviderStateMixin {

  late AnimationController _controller;
  late Animation _animation;
  int _miles=0;
  String s_cemas_lvl = "";
  String s_rekomendasi_1 = "";
  String s_rekomendasi_2 = "";
  String idf_user = "";

  @override
  void initState() {
    // TODO: implement initState
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    //_animation = _controller;


    setState(() {
      _miles = 0;
      _animation = IntTween(begin: 0, end: _miles).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    });


    _controller.forward();

    super.initState();
    getUserPrefs();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    Widget w_UlangiButton = ElevatedButton(
      onPressed: () {
        Navigator.pushReplacement(context, SlideRightRoute(page: TestMentalCemas0()));
      },
      child: Text("Ulangi Tes",  style: TextStyle(fontSize: 14)),
      style: ButtonStyle(
        padding: MaterialStateProperty.all(const EdgeInsets.all(16)),
        fixedSize: MaterialStateProperty.all(const Size(300, 50)),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        backgroundColor: MaterialStateProperty.all<Color>(Colors.teal),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
                side: BorderSide(color: Colors.teal)
            )
        ),
      ),
    );

    Widget w_valueAnim0 = new AnimatedBuilder(
      animation: _animation,
      builder: (BuildContext context, Widget? child) {
        return new Text(
          _animation.value.toString(),
          style: TextStyle(color: Colors.black, fontSize: 50, fontWeight: FontWeight.bold ),
        );
      },
    );

    return Scaffold(
        backgroundColor: Colors.white,
        //appBar: AppBar(title: Text('Tes Kesehatan Mental'), backgroundColor: Colors.teal,),
        body: ListView(
          children: [
            Padding(
                padding: EdgeInsets.fromLTRB(30, 10, 30,10),
                child: Column(
                  children: [
                    SizedBox(height: 10,),
                    Text("Hasil Tes Kecemasan",
                        style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold ),
                        textAlign: TextAlign.center),
                    Text("(GAD-7)",
                        style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold ),
                        textAlign: TextAlign.center),

                    Padding(
                      padding: EdgeInsets.fromLTRB(55, 20, 55, 20),
                      child: Image.asset(
                        "assets/images/test_mental_hasil.png",
                        fit: BoxFit.fitWidth,
                        //width: MediaQuery.of(context).size.width - 80 ,
                        alignment: Alignment.topCenter,
                      ),
                    ),

                    Text("Skor",
                        style: TextStyle(color: Colors.teal, fontSize: 14, ),
                        textAlign: TextAlign.center),
                    w_valueAnim0,
                    Text(s_cemas_lvl ,
                        style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold ),
                        textAlign: TextAlign.center),
                    SizedBox(height: 18,),
                    Text("Rekomendasi",
                        style: TextStyle(color: Colors.teal, fontSize: 14, ),
                        textAlign: TextAlign.center),
                    Text(s_rekomendasi_1 ,
                        style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold ),
                        textAlign: TextAlign.center),
                    Text(s_rekomendasi_2 ,
                        style: TextStyle(color: Colors.black, fontSize: 12, ),
                        textAlign: TextAlign.center),

                    SizedBox(height: 30,),
                    w_UlangiButton,

                  ],
                )
            ),
            SizedBox(height: 100,),
          ],
        )
    );

  }


  getUserPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    var a = prefs.getString("sf_nilai_test_cemas") ?? "";
    var b = prefs.getString("sf_jawab_test_cemas") ?? "";
    var c = prefs.getString("idf_user") ?? "";

    getUserPrefs_1(a, b, c);
  }

  getUserPrefs_1(sf_nilai_test_cemas0, sf_jawab_test_cemas0, idf_user0) {
    setState(() {
      _miles = int.parse(sf_nilai_test_cemas0);
      _animation = IntTween(begin: 0, end: _miles).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

      s_rekomendasi_1 = "Monitor Keadaan Perasaan";
      s_rekomendasi_2 = " ";
      if(_miles > -1 && _miles < 5){ // 0-4
        s_cemas_lvl = "Kecemasan minimal";
      }
      else if(_miles > 4 && _miles < 10){  // 5-9
        s_cemas_lvl = "Kecemasan ringan";
      }
      else if(_miles > 9 && _miles < 15){  // 10-14
        s_cemas_lvl = "Kecemasan sedang";
        s_rekomendasi_1 = "Kontrol ke dokter untuk diagnosis dan tata laksana";
      }
      else if(_miles > 14 && _miles < 22){  // 15-21
        s_cemas_lvl = "Kecemasan berat";
        s_rekomendasi_1 = "Segera kontrol ke dokter untuk diagnosis dan tata laksana";
      }

      idf_user = idf_user0;

    });

    kirimKeServer(sf_nilai_test_cemas0, sf_jawab_test_cemas0);

  }

  Future kirimKeServer(sf_nilai_test_cemas0, sf_jawab_test_cemas0) async{ // senyap ja jgn ada notif

    String sBar = "";
    final String url00 = AppConfig().url_API + "mob-save-hasil-test-mental";
    debugPrint(url00 + " --> " + idf_user );
    try {
      final response = await http.post(Uri.parse(url00), body: {
        'idf_user' : idf_user ,
        'nilai' : sf_nilai_test_cemas0 ,
        'jawaban' : sf_jawab_test_cemas0 ,
        'test' : 'kecemasan' ,
      });

      if(response.statusCode == 200){
        final String responseString = response.body;
        var err_code0 = jsonDecode(responseString)["err_code"];
        debugPrint(responseString + " errcode : $err_code0");

        if(err_code0==0){
          //debugPrint("masuuuk");
          setState(() {
            //pop00Visible = false;
          });
        }
        else if(err_code0==1) {
          //sBar = "Data Not found!";
          /*
          setState(() {
            pop00Visible = false;
            sf_kontak_darurat_idf = "x";
          });
          */
        }
      }
      else {
        //int a=response.statusCode; debugPrint("xxxx $a ");
        //sBar = "No Connection!";
      }

    } catch (e) {
      String cek = "xxx.. $e"; // biar jadi string exceptionnya
      debugPrint(cek);

      //if(cek.indexOf('unreachable') > -1){ sBar = "No Internet Connection!"; }
      //else { sBar = "Cannot Connect to Server!";   }
    }

    //if(sBar != ""){ myDialog00().snackBar003(context, sBar); }
  }

}
