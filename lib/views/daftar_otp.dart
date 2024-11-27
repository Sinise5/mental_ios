import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../dialog00.dart';
import '../konfig000.dart';
import '../slide_anim.dart';
import 'daftar_ok.dart';
import 'forgotpass_newpass.dart';


class DaftarOTP_0 extends StatefulWidget {
  @override
  _DaftarOTP_0State createState() => _DaftarOTP_0State();
}

class _DaftarOTP_0State extends State<DaftarOTP_0> {


  String OTP000 = "";
  List<String> Box0 = ["", "", "", "", "", ""];
  List<Color> BoxBor0 = [Colors.red, Colors.grey, Colors.grey, Colors.grey];


  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String need_OTP_idf_user = "";
  String sf_trx_OTP_email = "---";
  String sf_trx_OTP_telp = "";
  String need_OTP_4 = "";

  bool pop00LoaderVisible=false;
  bool pop00CekOTPLoaderVisible=false;
  bool pop00CekOTPSuccessVisible=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserPrefs();
  }

  @override
  Widget build(BuildContext context) {

    Widget OTP_pin = Center(
      child: Container(
        alignment: Alignment.center,
        width: 230,
        child: Row(
          children: <Widget>[
            CustomTextField0(Box0[0], BoxBor0[0]),
            SizedBox(width: 10,),
            CustomTextField0(Box0[1], BoxBor0[1]),
            SizedBox(width: 10,),
            CustomTextField0(Box0[2], BoxBor0[2]),
            SizedBox(width: 10,),
            CustomTextField0(Box0[3], BoxBor0[3]),
          ],
        ),
      ),
    );

    Widget OTP_tombol = Center(
        child: Container(
          width: 270,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                children: <Widget>[
                  CustomPin00("1", (){ click0("1"); }),
                  CustomPin00("2", (){ click0("2"); }),
                  CustomPin00("3", (){ click0("3"); }),
                ],
              ),
              Row(
                children: <Widget>[
                  CustomPin00("4", (){ click0("4"); }),
                  CustomPin00("5", (){ click0("5"); }),
                  CustomPin00("6", (){ click0("6"); }),
                ],
              ),
              Row(
                children: <Widget>[
                  CustomPin00("7", (){ click0("7"); }),
                  CustomPin00("8", (){ click0("8"); }),
                  CustomPin00("9", (){ click0("9"); }),
                ],
              ),
              Row(
                children: <Widget>[
                  SizedBox(width: 88),
                  CustomPin00("0", (){ click0("0"); }),
                  Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: Colors.white,
                      elevation: 3,
                      child: InkWell(
                        onTap: (){ clickDel0(); },
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                            width: 80,
                            height: 60,
                            padding: EdgeInsets.all(12.0),
                            child: Center(
                              child: Icon(Icons.backspace),
                            )
                        ),
                      )
                  )
                ],
              )
            ],
          ),
        )
    );

    return Scaffold(
        key: _scaffoldKey,
        //appBar: AppBar(title: Text('Verifikasi OTP')),
        body: Stack(
          children: <Widget>[
            ListView(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 30),
                    Text("Cek e-mail", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23.0, color: Color(0XFF56BCAA),),),
                    SizedBox(height: 1),
                    Text("untuk konfirmasi", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23.0, color: Color(0XFF56BCAA),),),
                    SizedBox(height: 20),
                    Text("Untuk melakukan konfirmasi akun,", style: TextStyle(fontWeight: FontWeight.bold, ),),
                    Text("masukkan 4 digit kode yang sudah dikirim ke", style: TextStyle(fontWeight: FontWeight.bold, ),),
                    Text(sf_trx_OTP_email, style: TextStyle(fontWeight: FontWeight.bold, color: Color(0XFF56BCAA)),),
                    SizedBox(height: 20),
                    Icon(Icons.mail, color: Color(0XFF56BCAA), size: 60),
                    SizedBox(height: 20),
                    /*
                    Padding(
                      padding: EdgeInsets.only(left: 1, right: 1),
                      child: RichText(
                        text: TextSpan(
                          text: 'Silahkan masukkan kode OTP \ndi email: ',
                          style: TextStyle(color: Colors.black),
                          children: <TextSpan>[
                            TextSpan(text: sf_trx_OTP_email, style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: ' \natau ke nomor ponsel: '),
                            TextSpan(text: sf_trx_OTP_telp, style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                    */
                    OTP_pin,
                    SizedBox(height: 50,),
                    Divider(thickness: 15, color: Colors.grey,),
                    SizedBox(height: 16,),
                    OTP_tombol,

                  ],
                ),
              ],
            ),
            popup00(pop00LoaderVisible),
            popup01_loader(pop00CekOTPLoaderVisible, "OTP Verification, please wait ..."),
            popup01_loader(pop00CekOTPSuccessVisible, "Processing Request, please wait ..."),
          ],
        )
    );
  }


  click0(String s) {
    int len = OTP000.length;
    if(len < 4){
      setState(() {
        Box0[len] = s;
        OTP000 += s;
        for (var i = 0; i < 4; i++){ BoxBor0[i] = Colors.grey; }
        if(len+1 < 4){ BoxBor0[len+1] = Colors.red; }
        if(len+1 == 4){
          pop00LoaderVisible=true;
          pop00CekOTPLoaderVisible=true;
          pop00CekOTPSuccessVisible=false;
          goChekOTP();
        }
      });
      timerObsecure();
    }
    //debugPrint("t=$s , OTP=$OTP000");
  }

  clickDel0() {
    int len = OTP000.length;
    if(len > 0){
      setState(() {
        OTP000 = OTP000.substring(0, len-1);
        Box0[len-1] = "";
        for (var i = 0; i < 4; i++){ BoxBor0[i] = Colors.grey; }
        if(len-1 > -1){ BoxBor0[len-1] = Colors.red; }
      });
      timerObsecure();
    }
  }

  timerObsecure() async {
    var duration = const Duration(milliseconds: 300);
    return Timer(duration, (){
      for (var i = 0; i < 4; i++){
        setState(() {
          if(Box0[i] != "*" && Box0[i] != ""){ Box0[i]="*"; }
        });
      }
    });
  }

  Future goChekOTP() async{

    String sBar = "";

    var apicek = "mob-otp-check";
    if(need_OTP_4 == "forgotPass"){ apicek = "mob-otp-check-lupa-pass"; }
    else if(need_OTP_4 == "otp_ver_email_daftar"){ apicek = "mob-verifikasi-email"; }
    String url00 = AppConfig().url_API + apicek;

    debugPrint(url00 + " --> " + need_OTP_idf_user );
    try {
      final response = await http.post(Uri.parse(url00), body: {
        'need_OTP_idf_user' : need_OTP_idf_user ,
        'otp_check' : OTP000 ,
        'need_OTP_email_user' : sf_trx_OTP_email ,
        'need_OTP_4' : need_OTP_4 ,
      });

      if(response.statusCode == 200){
        final String responseString = response.body;
        var err_code0 = jsonDecode(responseString)["err_code"];
        debugPrint(responseString + " errcode : $err_code0");

        if(err_code0==0){
          OTPSuccess0();
        }
        else if(err_code0==1) {
          var message0 = jsonDecode(responseString)["message"];
          if(message0=="OTP salah"){ sBar = "OTP tak sesuai !"; }
          else{  sBar = "Data Not found !";  }
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

    if(sBar != ""){
      //myDialog00().snackBar002(_scaffoldKey, sBar);
      myDialog00().snackBar003(context, sBar);
    }

    setState(() {
      pop00LoaderVisible = false;
      pop00CekOTPLoaderVisible=false;
      pop00CekOTPSuccessVisible=false;

      OTP000 = "";
      for (var i = 0; i < 4; i++){ BoxBor0[i] = Colors.grey;  Box0[i] = ""; }
      BoxBor0[0] = Colors.red;
    });

  }

  void OTPSuccess0() {
    debugPrint("successssss need_OTP_idf_user: $need_OTP_idf_user , need_OTP_4: $need_OTP_4");
    if(need_OTP_4=="forgotPass"){
      Navigator.push(context, SlideRightRoute(page: RubahPassOTP()));
    }
    else if(need_OTP_4=="BuyPaketData"){  debugPrint("Goooooooooo BuyPaketData");  }
    else if(need_OTP_4=="otp_ver_email_daftar"){
      debugPrint("Goooooooooo otp_ver_email_daftar");
      Navigator.pushReplacement(context, SlideRightRoute(page: DaftarOK_0()));
    }
  }


  getUserPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance()
        .then((SharedPreferences prefs0) => getUserPrefs_1(
        prefs0.getString("need_OTP_idf_user") ?? "",
        prefs0.getString("sf_trx_OTP_email") ?? "",
        prefs0.getString("sf_trx_OTP_telp") ?? "",
        prefs0.getString("need_OTP_4") ?? ""
    ) );
  }

  getUserPrefs_1(need_OTP_idf_user0, sf_trx_OTP_email0, sf_trx_OTP_telp0, need_OTP_4_0) {
    setState(() {
      need_OTP_idf_user = need_OTP_idf_user0;
      sf_trx_OTP_email = sf_trx_OTP_email0;
      sf_trx_OTP_telp = sf_trx_OTP_telp0;
      need_OTP_4 = need_OTP_4_0;
    });
  }


}


class CustomTextField0 extends StatelessWidget{

  String text0;
  Color col0;

  CustomTextField0(this.text0, this.col0);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: 50,
      height: 50,
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        border: Border.all(
            color: col0,
            width: col0 == Colors.red ? 3 : 1
        ),
        borderRadius: BorderRadius.all(
            Radius.circular(5.0)
        ),
      ),
      child: Center(
          child: Text(text0,   style: TextStyle(fontSize: 30.0),
          )
      ),
    );

  }

}

class CustomPin00 extends StatelessWidget{

  String text0;
  Function()? onTap0;

  CustomPin00(this.text0, this.onTap0);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: Colors.white,
        elevation: 3,
        child: InkWell(
          onTap: onTap0,
          borderRadius: BorderRadius.circular(10),
          child: Container(
              width: 80,
              height: 60,
              padding: EdgeInsets.all(12.0),
              child: Center(
                child: Text(text0, style: TextStyle(color: Colors.black, fontSize: 30 )),
              )
          ),
        )
    );
  }

}

