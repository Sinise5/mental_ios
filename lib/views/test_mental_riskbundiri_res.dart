import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../konfig000.dart';
import '../slide_anim.dart';
import 'kontak_bantuan_wv.dart';
import 'kontak_darurat.dart';
import 'safety_plan.dart';
import 'teknik_relaks.dart';
import 'test_mental.dart';
import 'test_mental_riskbundiri.dart';


class TestMentalRiskBunDiriResult0 extends StatefulWidget {
  const TestMentalRiskBunDiriResult0({Key? key}) : super(key: key);

  @override
  State<TestMentalRiskBunDiriResult0> createState() => _TestMentalRiskBunDiriResult0State();
}

class _TestMentalRiskBunDiriResult0State extends State<TestMentalRiskBunDiriResult0> {

  int _miles=0;
  String s_risiko_lvl = "";
  String s_risiko_img = "risk_null.png";
  String idf_user = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserPrefs();
  }

  @override
  Widget build(BuildContext context) {

    Widget w_RKeamananButton = CustomButtonDark00000("Cek Rencana Keamanan", () {
      Navigator.pushReplacement(context, SlideRightRoute(page: SafetyPlan0()));
    }, Colors.teal.shade200, Colors.white );

    Widget w_TenangDiriButton = CustomButtonDark00000("Ikuti panduan menenangkan diri", () {
      Navigator.pushReplacement(context, SlideRightRoute(page: TeknikRelaks0()));
    }, Colors.teal, Colors.white );

    Widget w_KontakDaruratBtn = CustomButtonDark00000("Hubungi kontak darurat", () {
      Navigator.pushReplacement(context, SlideRightRoute(page: KontakDarurat0()));
    }, Colors.red, Colors.white );

    Widget w_KosulDokterBtn = CustomButtonDark00000("Segera konsultasi ke dokter", () {
      Navigator.pushReplacement(context, SlideRightRoute(page: KontakBantuan_WV0()));
    }, Colors.red.shade900, Colors.white );

    Widget w_UlangiButton = CustomButtonDark001("Ulangi Tes", () {
      Navigator.pushReplacement(context, SlideRightRoute(page: TestMentalRBunDiri0()));
    });


    return Scaffold(
        backgroundColor: Colors.white,
        //appBar: AppBar(title: Text('Tes Kesehatan Mental'), backgroundColor: Colors.teal,),
        body: ListView(
          children: [
            Padding(
                padding: EdgeInsets.fromLTRB(30, 10, 30,10),
                child: Column(
                  children: [
                    SizedBox(height: 20,),
                    Text("Hasil Penilaian Risiko Bunuh Diri",
                        style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold ),
                        textAlign: TextAlign.center),

                    Padding(
                      padding: EdgeInsets.fromLTRB(55, 20, 55, 16),
                      child: Image.asset(
                        "assets/images/" + s_risiko_img,
                        fit: BoxFit.fitWidth,
                        width: MediaQuery.of(context).size.width - 250 ,
                        alignment: Alignment.topCenter,
                      ),
                    ),

                    /*
                    Text("Skor",
                        style: TextStyle(color: Colors.teal, fontSize: 14, ),
                        textAlign: TextAlign.center), */

                    Text(s_risiko_lvl ,
                        style: TextStyle(color: Colors.black, fontSize: 28, fontWeight: FontWeight.bold ),
                        textAlign: TextAlign.center),
                    SizedBox(height: 16,),
                    Text("Rekomendasi",
                        style: TextStyle(color: Colors.teal, fontSize: 14, ),
                        textAlign: TextAlign.center),


                    SizedBox(height: 16,),
                    w_RKeamananButton,
                    SizedBox(height: 10,),
                    w_TenangDiriButton,
                    SizedBox(height: 10,),
                    Visibility(
                        visible: (s_risiko_lvl == "Risiko Sedang" || s_risiko_lvl == "Risiko Tinggi") ? true : false,
                        child: Column(
                          children: [
                            w_KontakDaruratBtn,
                            SizedBox(height: 10,),
                          ],
                        )
                    ),
                    Visibility(
                        visible: (s_risiko_lvl == "Risiko Tinggi") ? true : false,
                        child: Column(
                          children: [
                            w_KosulDokterBtn,
                            SizedBox(height: 10,),
                          ],
                        )
                    ),

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

    var a = prefs.getString("sf_nilai_test_riskbundiri") ?? "";
    var b = prefs.getString("sf_jawab_test_riskbundiri") ?? "";
    var c = prefs.getString("idf_user") ?? "";

    getUserPrefs_1(a, b, c);
  }

  getUserPrefs_1(sf_nilai_test_riskbundiri0, sf_jawab_test_riskbundiri0, idf_user0) {
    setState(() {
      var nilai0 = int.parse(sf_nilai_test_riskbundiri0);

      if(nilai0 == 1){ //
        s_risiko_lvl = "Risiko Rendah";
        s_risiko_img = "risk_rendah.png";
      }
      else if(nilai0 == 2 ){  //
        s_risiko_lvl = "Risiko Sedang";
        s_risiko_img = "risk_sedang.png";
      }
      else if(nilai0 == 3 ){  //
        s_risiko_lvl = "Risiko Tinggi";
        s_risiko_img = "risk_tinggi.png";
      }

      idf_user = idf_user0;

    });

    kirimKeServer(sf_nilai_test_riskbundiri0, sf_jawab_test_riskbundiri0);

  }

  Future kirimKeServer(sf_nilai_test_riskbundiri0, sf_jawab_test_riskbundiri0) async{ // senyap ja jgn ada notif

    String sBar = "";
    final String url00 = AppConfig().url_API + "mob-save-hasil-test-mental";
    debugPrint(url00 + " --> " + idf_user );
    try {
      final response = await http.post(Uri.parse(url00), body: {
        'idf_user' : idf_user ,
        'nilai' : sf_nilai_test_riskbundiri0 ,
        'jawaban' : sf_jawab_test_riskbundiri0 ,
        'test' : 'RBD' ,
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

