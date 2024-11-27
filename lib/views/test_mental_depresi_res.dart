import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../konfig000.dart';
import 'test_mental_depresi.dart';
import '../slide_anim.dart';

class TestMentalDepresiResult0 extends StatefulWidget {
  @override
  _TestMentalDepresiResult0State createState() => _TestMentalDepresiResult0State();
}

class _TestMentalDepresiResult0State extends State<TestMentalDepresiResult0> with TickerProviderStateMixin {

  late AnimationController _controller;
  late Animation _animation;
  int _miles=0;
  String s_depresi_lvl = "";
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
        Navigator.pushReplacement(context, SlideRightRoute(page: TestMentalDepresi0()));
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
                    Text("Hasil Tes Depresi",
                        style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold ),
                        textAlign: TextAlign.center),
                    Text("(PHQ-9)",
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
                    Text(s_depresi_lvl ,
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
                    Text("PERHATIAN",
                        style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold ),
                        textAlign: TextAlign.center),
                    Text("Jika menjawab \"pernah\" pada poin nomor 9",
                        style: TextStyle(color: Colors.grey, fontSize: 9, ),
                        textAlign: TextAlign.center),
                    Text("(merasa lebih baik mati atau ingin melukai diri sendiri dengan cara apapun)",
                        style: TextStyle(color: Colors.grey, fontSize: 9, ),
                        textAlign: TextAlign.center),
                    SizedBox(height: 10,),
                    Text("Rekomendasi",
                        style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center),
                    Text("Segera kontrol ke dokter untuk diagnosis dan tata laksana lanjutan",
                        style: TextStyle(color: Colors.grey, fontSize: 9, ),
                        textAlign: TextAlign.center),
                    SizedBox(height: 5),
                    Text("Ke IGD RS terdekat jika memiliki resiko membahayakan diri sendiri atau orang lain",
                        style: TextStyle(color: Colors.grey, fontSize: 9, ),
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

    var a = prefs.getString("sf_nilai_test_depresi") ?? "";
    var b = prefs.getString("sf_jawab_test_depresi") ?? "";
    var c = prefs.getString("idf_user") ?? "";

    getUserPrefs_1(a, b, c);
  }

  getUserPrefs_1(sf_nilai_test_depresi0, sf_jawab_test_depresi0, idf_user0) {
    setState(() {
      _miles = int.parse(sf_nilai_test_depresi0);
      _animation = IntTween(begin: 0, end: _miles).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

      s_rekomendasi_1 = "Monitor Keadaan Perasaan";
      s_rekomendasi_2 = " ";
      if(_miles==0){
        s_depresi_lvl = "Tidak ada gejala depresi";
      }
      else if(_miles > 0 && _miles < 5){  // 1-4
        s_depresi_lvl = "Depresi minimal";
      }
      else if(_miles > 4 && _miles < 10){  // 5-9
        s_depresi_lvl = "Depresi ringan";
        s_rekomendasi_2 = "Dapat ke dokter atau psikolog untuk diagnosis dan tata laksana lanjutan";
      }
      else if(_miles > 9 && _miles < 15){  // 10-14
        s_depresi_lvl = "Depresi sedang";
        s_rekomendasi_2 = "Dianjurkan ke dokter untuk diagnosis dan tata laksana lanjutan";
      }
      else if(_miles > 14 && _miles < 20){  // 15-19
        s_depresi_lvl = "Depresi sedang-berat";
        s_rekomendasi_1 = "Kontrol ke dokter untuk diagnosis dan tata laksana lanjutan";
      }
      else if(_miles > 19 && _miles < 28){  // 20-27
        s_depresi_lvl = "Depresi berat";
        s_rekomendasi_1 = "Segera kontrol ke dokter untuk diagnosis dan tata laksana lanjutan";
        s_rekomendasi_2 = "Ke IGD RS terdekat jika memiliki risiko membahayakan diri sendiri atau orang lain";
      }

      idf_user = idf_user0;

    });

    kirimKeServer(sf_nilai_test_depresi0, sf_jawab_test_depresi0);
  }

  Future kirimKeServer(sf_nilai_test_depresi0, sf_jawab_test_depresi0) async{ // senyap ja jgn ada notif

    String sBar = "";
    final String url00 = AppConfig().url_API + "mob-save-hasil-test-mental";
    debugPrint(url00 + " --> " + idf_user );
    try {
      final response = await http.post(Uri.parse(url00), body: {
        'idf_user' : idf_user ,
        'nilai' : sf_nilai_test_depresi0 ,
        'jawaban' : sf_jawab_test_depresi0 ,
        'test' : 'depresi' ,
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
