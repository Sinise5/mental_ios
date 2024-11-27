import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../dialog00.dart';
import '../konfig000.dart';
import '../slide_anim.dart';
import 'safety_plan_wv.dart';
import 'test_mental.dart';


class SafetyPlan0 extends StatefulWidget {
  const SafetyPlan0({Key? key}) : super(key: key);

  @override
  State<SafetyPlan0> createState() => _SafetyPlan0State();
}

class _SafetyPlan0State extends State<SafetyPlan0> {

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String idf_user="";
  String s_idf_renc_keamanan = ""; // '' -> masih baca server ;  'x' -> belum buat;  'RK2022...'-> ini ada
  bool pop00Visible=false;
  bool pop00_dialogAddBaru = false;
  bool pop00_hapusRK = false;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserPrefs();
  }

  @override
  Widget build(BuildContext context) {

    Widget w_judul = Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              child: Icon( Icons.arrow_back_ios, color: Colors.black, size: 20, ),
              onTap: (){ Navigator.of(context).pop(); },
            ),
            SizedBox(height: 20,),
            Text('Rencana Keamanan', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold ),),
          ],
        )
    );

    Widget w_RencanaLihatButton = CustomButtonDark001("Lihat Rencana Keamanan", () {
      lihatAjaRK();
    });

    Widget w_RencanaUpdateButton = CustomButtonDark002("Update", () {
      Navigator.push(context, SlideRightRoute(page: SafetyPlan_WV0()));
    });

    Widget w_RencanaBaruButton = GestureDetector(
      onTap: (){ showDialogBaruRK(); },
      child: Column(
        children: [
          Icon(Icons.add_circle, color: Colors.teal, size: 40),
          Text("Buat Rencana Keamanan Baru",
              style: TextStyle(color: Colors.teal, fontSize: 16, fontWeight: FontWeight.bold ),
              textAlign: TextAlign.center),
        ],
      )
    );

    Widget w_gambar = Image.asset("assets/images/safety_plan.png",
      fit: BoxFit.fitWidth,
      width: MediaQuery.of(context).size.width - 135 ,
      alignment: Alignment.topCenter,
    );

    Widget w_belum_ada = Column(
      children: [
        Text("Belum ada",
            style: TextStyle(color: Colors.black, fontSize: 14, ),
            textAlign: TextAlign.center),
        Text("Rencana Keamanan",
            style: TextStyle(color: Colors.teal, fontSize: 14, fontWeight: FontWeight.bold ),
            textAlign: TextAlign.center),
        Text("yang tersimpan. Buat sekarang!",
            style: TextStyle(color: Colors.black, fontSize: 14, ),
            textAlign: TextAlign.center),
      ],
    );

    Widget w_RencanaBaruButton2 = CustomButtonDark001("Buat Rencana Keamanan", () {
      Navigator.push(context, SlideRightRoute(page: SafetyPlan_WV0())).then((value) { getUserPrefs(); } );
    });

    Widget w_buttonYa = ElevatedButton(
      onPressed: (){ buatBaruHapus(); },
      child: Text("Ya",  style: TextStyle(fontSize: 14, color: Colors.white)),
      style: ButtonStyle(
        padding: MaterialStateProperty.all(const EdgeInsets.all(10)),
        fixedSize: MaterialStateProperty.all(const Size(90, 40)),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
        backgroundColor: MaterialStateProperty.all<Color>(Colors.teal),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
                side: BorderSide(color: Colors.teal)
            )
        ),
      ),
    );

    Widget w_buttonNo = ElevatedButton(
      onPressed: (){ hideDialogBaruRK(); },
      child: Text("Tidak",  style: TextStyle(fontSize: 14, color: Colors.teal)),
      style: ButtonStyle(
        padding: MaterialStateProperty.all(const EdgeInsets.all(10)),
        fixedSize: MaterialStateProperty.all(const Size(90, 40)),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
                side: BorderSide(color: Colors.teal)
            )
        ),
      ),
    );

    Widget w_dialogTanya01 = Center(
      child: Container(
          width: MediaQuery.of(context).size.width - 90 ,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.circular(15.0)
          ),
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text("Buat baru ?",  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                SizedBox(height: 20.0),
                Text("Rencana Keamanan yang lama"),
                Text("akan otomatis terhapus"),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    w_buttonYa,
                    SizedBox(width: 16.0),
                    w_buttonNo
                  ],
                )
              ],
            ),
          )
      ),
    );




    return Scaffold(
        backgroundColor: Colors.white,
        //appBar: AppBar(title: Text('Tes Kesehatan Mental'), backgroundColor: Colors.teal,),
        body: Stack(
          children: [
            ListView(
              children: [
                w_judul,
                Padding(
                    padding: EdgeInsets.fromLTRB(30, 10, 30,10),
                    child: Column(
                      children: [
                        SizedBox(height: 20,),
                        w_gambar,
                        SizedBox(height: 40,),
                        Visibility(
                          visible: (s_idf_renc_keamanan != '' && s_idf_renc_keamanan != 'x') ? true : false,
                          child: Column(
                            children: [
                              w_RencanaLihatButton,
                              SizedBox(height: 20),
                              w_RencanaUpdateButton,
                              SizedBox(height: 26),
                              w_RencanaBaruButton,
                            ],
                          ),
                        ),
                        Visibility(
                          visible: (s_idf_renc_keamanan == 'x') ? true : false,
                          child: Column(
                            children: [
                              w_belum_ada,
                              SizedBox(height: 160),
                              w_RencanaBaruButton2,
                            ],
                          ),
                        ),
                        popup01_loader( (s_idf_renc_keamanan == '') ? true : false, "Loading Data ...")
                      ],
                    )
                ),
                SizedBox(height: 100,),
              ],
            ),
            popup00(pop00_dialogAddBaru),
            Visibility(visible: pop00_dialogAddBaru, child: w_dialogTanya01),
            popup00(pop00_hapusRK),
            popup01_loader(pop00_hapusRK, "Processing Data ...")
          ],
        )
    );

  }


  getUserPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    var a = prefs.getString("idf_user") ?? "";
    getUserPrefs_1(a);
  }

  getUserPrefs_1(idf_user0) {
    setState(() {
      idf_user = idf_user0;

      if(idf_user != ""){
        pop00Visible = true;
        ambilDataUser(idf_user);
      }

    });
  }

  Future ambilDataUser(String idf_user) async{

    String sBar = "";
    final String url00 = AppConfig().url_API + "mob-data-ren-keamanan";
    debugPrint(url00 + " --> " + idf_user );
    try {
      final response = await http.post(Uri.parse(url00), body: {
        'idf_user' : idf_user ,
      });

      if(response.statusCode == 200){
        final String responseString = response.body;
        var err_code0 = jsonDecode(responseString)["err_code"];
        debugPrint(responseString + " errcode : $err_code0");

        if(err_code0==0){
          //debugPrint("masuuuk");
          setState(() {
            pop00Visible = false;
            s_idf_renc_keamanan = jsonDecode(responseString)["data"][0]["idf_mob_r_keamanan"];
          });
        }
        else if(err_code0==1) {
          //sBar = "Data Not found!";
          setState(() {
            pop00Visible = false;
            s_idf_renc_keamanan = "x";
          });
        }
      }
      else {
        int a=response.statusCode; debugPrint("xxxx $a ");
        sBar = "No Connection!";
      }

    } catch (e) {
      String cek = "xxx.. $e"; // biar jadi string exceptionnya
      debugPrint(cek);

      if(cek.indexOf('unreachable') > -1){ sBar = "No Internet Connection!"; }
      else { sBar = "Cannot Connect to Server!";   }
    }

    if(sBar != ""){ myDialog00().snackBar003(context, sBar); }

  }

  showDialogBaruRK() {
    setState(() {
      pop00_dialogAddBaru = true;
    });
  }

  hideDialogBaruRK() {
    setState(() {
      pop00_dialogAddBaru = false;
    });
  }

  buatBaruHapus() {
    hideDialogBaruRK();
    setState(() {
      pop00_hapusRK = true;
    });

    hapusDataRK(idf_user);
    //Navigator.push(context, SlideRightRoute(page: SafetyPlan_WV0()));
  }

  Future hapusDataRK(String idf_user) async{

    String sBar = "";
    final String url00 = AppConfig().url_API + "mob-data-ren-keamanan-hapus";
    debugPrint(url00 + " --> " + idf_user );
    try {
      final response = await http.post(Uri.parse(url00), body: {
        'idf_user' : idf_user ,
      });

      if(response.statusCode == 200){
        final String responseString = response.body;
        var err_code0 = jsonDecode(responseString)["err_code"];
        debugPrint(responseString + " errcode : $err_code0");

        if(err_code0==0){
          //debugPrint("masuuuk");
          setState(() {
            pop00_hapusRK = false;
          });
        }
        else if(err_code0==1) {
          //sBar = "Data Not found!";
          setState(() {
            pop00_hapusRK = false;
          });
        }
        Navigator.push(context, SlideRightRoute(page: SafetyPlan_WV0()));

      }
      else {
        int a=response.statusCode; debugPrint("xxxx $a ");
        sBar = "No Connection!";
      }

    } catch (e) {
      String cek = "xxx.. $e"; // biar jadi string exceptionnya
      debugPrint(cek);

      if(cek.indexOf('unreachable') > -1){ sBar = "No Internet Connection!"; }
      else { sBar = "Cannot Connect to Server!";   }
    }

    if(sBar != ""){ myDialog00().snackBar003(context, sBar); }

  }

  void lihatAjaRK() {
    setUserPrefs01();
    Navigator.push(context, SlideRightRoute(page: SafetyPlan_WV0()));
  }

  Future setUserPrefs01() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("sf_SafetyPlan_lihataja", '1');
  }

}
