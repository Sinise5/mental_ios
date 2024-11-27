import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
//import 'package:launch_review/launch_review.dart';

import '../dialog00.dart';
import '../konfig000.dart';
import '../slide_anim.dart';
import 'home000.dart';
import 'intro_screen_list.dart';
import 'login.dart';
import 'daftar.dart';

class OnboardScreen extends StatefulWidget {
  @override
  _OnboardScreenState createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool pop00CekMobUpdVisible=false;
  bool mobversi_statVis=true;
  //bool pop00MobPopupNotifVis=false;

  List<Widget> slides = items0
      .map((item) => Container(
        padding: EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          children: <Widget>[
            SizedBox(height: 50),
            Text(item['header'],
                style: TextStyle( fontSize: 23.0, fontWeight: FontWeight.bold, color: Color(0XFF56BCAA), height: 1.2)),
            Text(item['header2'],
                style: TextStyle( fontSize: 23.0, fontWeight: FontWeight.bold, color: Color(0XFF56BCAA), height: 1.2)),
            SizedBox(height: 30),
            Image.asset( item['image'], fit: BoxFit.fitWidth, width: 300, alignment: Alignment.topCenter,
              /*alignment: Alignment.bottomCenter,*/
            ),
            SizedBox(height: 30),
            Text(item['description'],
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Color(0XFF000000), height: 1.2)),
            Text(item['description2'],
                style: TextStyle( fontSize: 16.0, fontWeight: FontWeight.bold, color: Color(0XFF000000), height: 1.2)),
            /*
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  children: <Widget>[
                    Text(item['header'],
                        style: TextStyle(
                            fontSize: 50.0,
                            fontWeight: FontWeight.w300,
                            color: Color(0XFF3F3D56),
                            height: 2.0)),
                    Text(
                      item['description'],
                      style: TextStyle(
                          color: Colors.grey,
                          letterSpacing: 1.2,
                          fontSize: 16.0,
                          height: 1.3),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
            )
            */
          ],
        )))
      .toList();

  List<Widget> indicator() => List<Widget>.generate(
      slides.length,
          (index) => Container(
        margin: EdgeInsets.symmetric(horizontal: 3.0),
        height: 10.0,
        width: 10.0,
        decoration: BoxDecoration(
            color: currentPage.round() == index
                ? Color(0XFF56BCAA)
                : Color(0XFF56BCAA).withOpacity(0.2), //0XFF256075
            borderRadius: BorderRadius.circular(10.0)),
      ));

  double currentPage = 0.0;
  final _pageViewController = new PageController();

  late Timer _timer;

  String idf_user = "", nama_user = "";

  @override
  void initState() {

    super.initState();

    _pageViewController.addListener(() {
      setState(() {
        currentPage = _pageViewController.page!;
        debugPrint("currentPage $currentPage");
      });
    });

    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (currentPage < 2) {
        currentPage++;
      } else {
        currentPage = 0;
      }

      _pageViewController.animateToPage(
        currentPage.toInt(),
        duration: Duration(milliseconds: 350),
        curve: Curves.easeIn,
      );
    });

    getUserPrefs();
    cekMobVersi();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {

    Widget w_LoginButton = ElevatedButton(
      onPressed: () {
        Navigator.pushReplacement(context, SlideRightRoute(page: Login0()));
        /*
        (currentPage == 2.0)
            ? Navigator.pushReplacement(context, SlideRightRoute(page: Login0()))
            : (){} ; */
      },
      child: Text("Masuk",  style: TextStyle(fontSize: 18)),
      style: ButtonStyle(
        padding: MaterialStateProperty.all(const EdgeInsets.all(10)),
        fixedSize: MaterialStateProperty.all(const Size(300, 40)),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        backgroundColor: MaterialStateProperty.all<Color>( Colors.black ), // (currentPage > 1.5) ? Colors.black : Colors.grey
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                //side: BorderSide(color: Colors.black)
            )
        ),

      ),
    );

    Widget w_DaftarButton = ElevatedButton(
      onPressed: () {
        Navigator.pushReplacement(context, SlideRightRoute(page: Daftar0()));
        /*
        (currentPage == 2.0)
            ? Navigator.pushReplacement(context, SlideRightRoute(page: Daftar0()))
            : (){} ;  */
      },
      child: Text("Daftar",  style: TextStyle(fontSize: 18)),
      style: ButtonStyle(
        padding: MaterialStateProperty.all(const EdgeInsets.all(10)),
        fixedSize: MaterialStateProperty.all(const Size(300, 40)),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        backgroundColor: MaterialStateProperty.all<Color>( Colors.teal ), // (currentPage > 1.5) ? Colors.teal : Colors.grey
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                //side: BorderSide(color: Colors.teal)
            )
        ),

      ),
    );

    Widget w_MasukButton = ElevatedButton(
      onPressed: () {
        Navigator.pushReplacement(context, SlideRightRoute(page: HomePage0()));
      },
      child: Text("Masuk",  style: TextStyle(fontSize: 18)),
      style: ButtonStyle(
        padding: MaterialStateProperty.all(const EdgeInsets.all(10)),
        fixedSize: MaterialStateProperty.all(const Size(300, 40)),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
              //side: BorderSide(color: Colors.black)
            )
        ),

      ),
    );

    Widget w_Indicator = Container(
      margin: EdgeInsets.only(top: 70.0),
      padding: EdgeInsets.symmetric(vertical: 40.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: indicator(),
      ),
    );

    Widget w_bawah2 = Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
            padding: EdgeInsets.only(bottom: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                w_Indicator,
                SizedBox(height: 40),
                Visibility(
                    visible: idf_user=="" ? true : false,
                    child: Column(
                      children: [
                        w_LoginButton,
                        SizedBox(height: 10),
                        w_DaftarButton
                      ],
                    )
                ),
                Visibility(
                    visible: idf_user!="" ? true : false,
                    child: w_MasukButton
                )

              ],
            )
        )
    );

    Widget w_mobUpd2 = Visibility(
      visible: pop00CekMobUpdVisible,
      child: Center(
          child: Stack(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(36),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0)
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.only(
                                topLeft:  Radius.circular(15),
                                topRight: Radius.circular(15))
                        ),
                        height: 150,
                        child: Icon(Icons.autorenew, color: Colors.white, size: 100),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text("Versi terbaru telah tersedia, \nsegera perbaharui aplikasi anda dengan yang terbaru...", textAlign: TextAlign.center,),
                      ),
                      Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            debugPrint("xxxxxxx launch");
                            /*LaunchReview.launch(
                              androidAppId: AppConfig().appPackageName_atPlayStore,
                              //iOSAppId: "585027354",
                            );*/
                            final InAppReview inAppReview = InAppReview.instance;
                            if (await inAppReview.isAvailable()) {
                            inAppReview.requestReview();
                            }
                          },
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all(const EdgeInsets.all(10)),
                            fixedSize: MaterialStateProperty.all(const Size(150, 45)),
                            foregroundColor: MaterialStateProperty.all<Color>(Colors.green),
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: const BorderSide(color: Colors.green)
                                )
                            ),
                          ),
                          child: const Text('    UPDATE    ', style: TextStyle(color: Colors.green)),
                        ),
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              Visibility(
                  visible: mobversi_statVis,
                  child: Positioned(
                      top: 18, right: 18,
                      child: Container(
                        //padding: EdgeInsets.fromLTRB(1, 1, 1, 1),
                        decoration: new BoxDecoration(
                            color: Colors.white,
                            borderRadius: new BorderRadius.circular(50)
                        ),
                        child: IconButton(icon: Icon(Icons.cancel, color: Colors.red, size: 30,), onPressed: (){
                          setState(() {
                            pop00CekMobUpdVisible=false;
                          });
                        } ),
                      )
                  )
              )
            ],
          )


      ),
    );

    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            PageView.builder(
              controller: _pageViewController,
              itemCount: slides.length,
              itemBuilder: (BuildContext context, int index) {
                return slides[index];
              },
            ),
            w_bawah2,

            popup00(pop00CekMobUpdVisible),
            w_mobUpd2
          ],
        ),
      ),
    );
  }

  getUserPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    var a = prefs.getString("idf_user") ?? "";
    var b = prefs.getString("nama_user") ?? "";

    getUserPrefs_1(a, b);
  }

  getUserPrefs_1(idf_user0, nama_user0) {
    setState(() {
      idf_user = idf_user0;
      nama_user = nama_user0;
    });
  }

  Future cekMobVersi() async{

    String sBar = "";
    final String url00 = AppConfig().url_API + "mob-cek-versi";
    debugPrint(url00 + " --> " );
    try {
      final response = await http.post(Uri.parse(url00), body: {
        'xxxx' : "xxxx" ,
      });

      if(response.statusCode == 200){
        final String responseString = response.body;
        var err_code0 = jsonDecode(responseString)["err_code"];
        debugPrint(responseString + " errcode : $err_code0");

        if(err_code0==0){
          debugPrint("masuuuk");
          //var jum_dat = jsonDecode(responseString)["jum_dat"];

          String mob_versi = jsonDecode(responseString)["data"][0]["mob_versi"];
          String mobversi_stat = jsonDecode(responseString)["data"][0]["mobversi_stat"];
          String mobver = AppConfig().mob_Version;
          debugPrint(" versii $mob_versi -- $mobver"  );

          //String mob_notif_popup = jsonDecode(responseString)["data"][0]["mob_notif_popup"];

          setState(() {
            if(mob_versi != ""){
              mob_versi = mob_versi.replaceAll(".", "");
              mobver = mobver.replaceAll(".", "");
              int a = int.parse(mob_versi);
              int b = int.parse(mobver);
              if(b < a ){
                //pop00CekPinVisible=false;
                //pop00CekPinLoaderVisible=false;
                pop00CekMobUpdVisible = true;
                if(mobversi_stat=="1"){ mobversi_statVis = false; }
                else{ mobversi_statVis = true; }
              }

              /*
              if(pop00CekMobUpdVisible == false){
                if(mob_notif_popup!=""){
                  pop00MobPopupNotifVis = true ;
                  s_TextPopNotif = mob_notif_popup;
                }
              } */

            }
          });

        }
        else if(err_code0==1) { sBar = "Data Not found!"; }
      }
      else {
        int a=response.statusCode; debugPrint("xxxx $a ");
        sBar = "No Connection!";
      }

      //FocusScope.of(context).unfocus();

    } catch (e) {
      String cek = "xxx.. $e"; // biar jadi string exceptionnya
      debugPrint(cek);

      if(cek.indexOf('unreachable') > -1){ sBar = "No Internet Connection!"; }
      else { sBar = "Cannot Connect to Server!";   }
    }

    if(sBar != ""){ myDialog00().snackBar003(context, sBar); }

  }

}

