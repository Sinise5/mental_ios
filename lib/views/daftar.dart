import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../dialog00.dart';
import '../konfig000.dart';
import '../slide_anim.dart';
import 'login.dart';
import 'daftar_otp.dart';

class Daftar0 extends StatefulWidget {
  @override
  _Daftar0State createState() => _Daftar0State();
}

class _Daftar0State extends State<Daftar0> {

  final _key = GlobalKey<FormState>();
  final TextEditingController _nama_controller = TextEditingController();
  final TextEditingController _telp_controller = TextEditingController();
  final TextEditingController _email_controller = TextEditingController();
  final TextEditingController _pass01_controller = TextEditingController();
  final TextEditingController _pass02_controller = TextEditingController();
  String s_nama="", s_telp="", s_email="", s_pass01="", s_pass02="";
  bool pop00Visible=false;
  bool passwordVisible=true;




  @override
  Widget build(BuildContext context) {

    double width0 = MediaQuery.of(context).size.width ;

    Widget w_Nama = TextFormField(
      decoration: InputDecoration(
        //icon: Icon(Icons.account_circle),
          filled: true,
          fillColor: Colors.white,
          prefixIcon: Icon(Icons.person),
          labelText: 'Nama Lengkap',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
          ),
      ),
      validator: (value){
        if(value!.isEmpty){ return "Harap isi Nama"; }
        else { return null; }
      },
      controller: _nama_controller,
    );

    Widget w_Telp = TextFormField(
        decoration: InputDecoration(
          //icon: Icon(Icons.account_circle),
            filled: true,
            fillColor: Colors.white,
            prefixIcon: Icon(Icons.phone_iphone),
            labelText: 'No. Telepon',
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
        ),
        validator: (value){
          if(value!.isEmpty){ return "Harap isi No. Telepon"; }
          else if(value.length<10){ return "Harap Isi Dengan Nomor Yang Valid"; }
          else if(value.toString().substring(0, 2)!="08"){ return "Harap Isi Dengan Nomor Yang Valid ( diawali 08xxx )"; }
          else { return null; }
        },
        controller: _telp_controller,
        keyboardType: TextInputType.number
    );

    Widget w_Email = TextFormField(
        decoration: InputDecoration(
          //icon: Icon(Icons.account_circle),
            filled: true,
            fillColor: Colors.white,
            prefixIcon: Icon(Icons.mail_outline),
            labelText: 'Email',
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
        ),
        validator: (value){
          if(value!.isEmpty){ return "Harap isi Email"; }
          else {
            /*Pattern pattern =
              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
            */
            RegExp regex = new RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

            if (!regex.hasMatch(value))
              return 'Please Enter Valid Email';
            else { return null; }
          }
        },
        controller: _email_controller,
        keyboardType: TextInputType.emailAddress
    );

    Widget w_Pass01 = TextFormField(
      decoration: InputDecoration(
        //icon: Icon(Icons.account_circle),
          filled: true,
          fillColor: Colors.white,
          prefixIcon: Icon(Icons.lock_outline),
          labelText: 'Password',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
      ),
      obscureText: true,
      validator: (value){
        if(value!.isEmpty){ return "Harap isi Password"; }
        else { return null; }
      },
      controller: _pass01_controller,
    );

    Widget w_Pass02 = TextFormField(
      decoration: InputDecoration(
        //icon: Icon(Icons.account_circle),
          filled: true,
          fillColor: Colors.white,
          prefixIcon: Icon(Icons.lock_outline),
          labelText: 'Confirm Password',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
      ),
      obscureText: true,
      validator: (value){
        if(value!.isEmpty){ return "Harap isi Confirm Password"; }
        if(value.trim() != _pass01_controller.text.trim() ){ return "Konfirmasi Password tak sama"; }
        else { return null; }
      },
      controller: _pass02_controller,
    );

    Widget w_RegisterButton = ElevatedButton(
      onPressed: () {
        if(_key.currentState!.validate()){

          setState(() {
            s_nama = _nama_controller.text.trim();
            s_telp = _telp_controller.text.trim();
            s_email = _email_controller.text.trim();
            s_pass01 = _pass01_controller.text.trim();
            s_pass02 = _pass02_controller.text.trim();
          });
          debugPrint("data submitted, $s_nama , $s_email");
          LoaderLogShow();
          CobaRegister();

        }
      },
      child: Text("Daftar",  style: TextStyle(fontSize: 18)),
      style: ButtonStyle(
        padding: MaterialStateProperty.all(const EdgeInsets.all(10)),
        fixedSize: MaterialStateProperty.all(const Size(300, 40)),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        backgroundColor: MaterialStateProperty.all<Color>(Colors.teal),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(color: Colors.teal)
            )
        ),

      ),
    );

    Widget w_Login = Padding(
      padding: EdgeInsets.only(top:10.0, bottom: 10.0, right: 5.0),
      child: Align(
        alignment: Alignment.center,
        child: RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: "sudah punya akun ? , ",
                style: TextStyle(color: Colors.black),
              ),
              TextSpan(
                text: " login disini !",
                style: TextStyle(color: Colors.green, decoration: TextDecoration.underline,),
                recognizer: new TapGestureRecognizer()..onTap = () {
                  //Navigator.of(context).push(MaterialPageRoute( builder: (context) => Login0() ));
                  Navigator.pushReplacement(context, SlideRightRoute(page: Login0()));
                },
              ),
              /*
              TextSpan( text: "            ", ),
              TextSpan(
                text: "OTP",
                style: TextStyle(color: Colors.green, decoration: TextDecoration.underline,),
                recognizer: new TapGestureRecognizer()..onTap = () {
                  Navigator.pushReplacement(context, SlideRightRoute(page: DaftarOTP_0()));
                },
              ),
              */
            ],
          ),
        ),
      ),
    );

    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        body: Stack(
          children: <Widget>[
            Container(
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                children: <Widget>[
                  SizedBox(height: 50),
                  Form(
                    key: _key,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Image.asset("assets/logo01_rejiwa.png", width: 200*0.7, height: 230*0.7 ),
                            SizedBox(height: 30),
                            w_Nama,
                            SizedBox(height: 16.0),
                            w_Telp,
                            SizedBox(height: 16.0),
                            w_Email,
                            SizedBox(height: 16.0),
                            w_Pass01,
                            SizedBox(height: 16.0),
                            w_Pass02,
                            SizedBox(height: 16.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Expanded(
                                  child: Padding(
                                      padding: const EdgeInsets.fromLTRB(1.0, 0.0, 1.0, 18.0),
                                      child: w_RegisterButton
                                  ),
                                ),
                              ],
                            ),
                            w_Login,
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 200),
                ],
              ),
            ),
            popup00(pop00Visible),
            popup01_loader(pop00Visible, "Login, please wait ...")
          ],
        )
    );

  }


  void LoaderLogShow() {
    setState(() {
      pop00Visible = true;
    });
  }

  void LoaderLogHide() {
    setState(() {
      pop00Visible = false;
    });
  }

  Future CobaRegister() async{

    final String url00 = AppConfig().url_API + "mob-register";
    debugPrint(url00);
    try {
      final response = await http.post(Uri.parse(url00), body: {
        'nama' : s_nama ,
        'telp' : s_telp ,
        'email' : s_email ,
        "pass" : s_pass01,
      });

      if(response.statusCode == 200){
        final String responseString = response.body;
        var err_code0 = jsonDecode(responseString)["err_code"];
        debugPrint(responseString + " errcode : $err_code0");
        if(err_code0==1) {
          LoaderLogHide();
          var err_msg = jsonDecode(responseString)["message"];
          myDialog00().openDialog00(context, "Tak bisa Register, $err_msg ");
        }
        else if(err_code0==0){
          debugPrint("telah kirim");
          var idf_user0 = jsonDecode(responseString)["data"][0]["idf_member"];
          var email0 = jsonDecode(responseString)["data"][0]["email"];
          var tlp0 = jsonDecode(responseString)["data"][0]["telepon"];
          setUserPrefs(idf_user0, email0, tlp0);

          Navigator.pushReplacement(context, SlideRightRoute(page: DaftarOTP_0()));
        }
        //return responseString;
      }
      else {
        /*int a=response.statusCode; debugPrint("xxxx $a ");*/
        myDialog00().openDialog00(context, "No Connection !");
        //return null;
      }

    } catch (e) {
      String cek = "xxx.. $e"; // biar jadi string exceptionnya
      debugPrint(cek);
      LoaderLogHide();
      if(cek.indexOf('unreachable') > -1){
        myDialog00().openDialog00(context, "No Internet Connection !");
      }else{
        myDialog00().openDialog00(context, "Cannot Connect to Server !");
      }
    }


  }


  Future setUserPrefs(String idf0, String email0, String tlp0) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("need_OTP_idf_user", idf0);
    prefs.setString("sf_trx_OTP_email", email0);
    prefs.setString("sf_trx_OTP_telp", tlp0);
    prefs.setString("need_OTP_4", "otp_ver_email_daftar");
  }


}
