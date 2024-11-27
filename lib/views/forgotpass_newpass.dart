import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../dialog00.dart';
import '../konfig000.dart';
import '../slide_anim.dart';
import 'forgotpass_newpass_ok.dart';


class RubahPassOTP extends StatefulWidget {
  @override
  _RubahPassOTPState createState() => _RubahPassOTPState();
}

class _RubahPassOTPState extends State<RubahPassOTP> {

  final _key = GlobalKey<FormState>();
  final TextEditingController _pass01_controller = TextEditingController();
  final TextEditingController _pass02_controller = TextEditingController();
  String s_pass01="", s_pass02="";
  bool pop00Visible=false;

  String need_OTP_idf_user = "", sf_trx_OTP_email = "", sf_trx_OTP_telp = "", need_OTP_4 = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserPrefs();
  }

  @override
  Widget build(BuildContext context) {

    Widget w_Pass01 = TextFormField(
      decoration: InputDecoration(
        //icon: Icon(Icons.account_circle),
          filled: true,
          fillColor: Colors.white,
          prefixIcon: Icon(Icons.lock_outline),
          labelText: 'Password Baru',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
      ),
      obscureText: true,
      validator: (value){
        if(value!.isEmpty){ return "Harap isi Password Baru"; }
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
          labelText: 'Confirm Password Baru',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
      ),
      obscureText: true,
      validator: (value){
        if(value!.isEmpty){ return "Harap isi Confirm Password Baru"; }
        if(value.trim() != _pass01_controller.text.trim() ){ return "Konfirmasi Password tak sama"; }
        else { return null; }
      },
      controller: _pass02_controller,
    );

    Widget w_PassButton = ElevatedButton(
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
      child: Text(" SIMPAN ".toUpperCase(),
          style: TextStyle(fontSize: 14)),
      onPressed: () {
        if(_key.currentState!.validate()){

          setState(() {
            s_pass01 = _pass01_controller.text.trim();
            s_pass02 = _pass02_controller.text.trim();
            pop00Visible = true;
          });
          debugPrint("data submitted, $need_OTP_idf_user , $s_pass01");
          GantiPass(need_OTP_idf_user, s_pass01);

        }
      },
    );
    /*
    Widget w_PassButton = RaisedButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
          side: BorderSide(color: Colors.teal)),
      color: Colors.teal,
      textColor: Colors.white,
      child: Text(" SIMPAN ".toUpperCase(),
          style: TextStyle(fontSize: 14)),
      onPressed: () {
        if(_key.currentState!.validate()){

          setState(() {
            s_pass01 = _pass01_controller.text.trim();
            s_pass02 = _pass02_controller.text.trim();
            pop00Visible = true;
          });
          debugPrint("data submitted, $need_OTP_idf_user , $s_pass01");
          GantiPass(need_OTP_idf_user, s_pass01);

        }
      },
    );
    */

    return Scaffold(
        //appBar: AppBar(title: Text('Edit Password')),
        body: Stack(
          children: <Widget>[
            ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              children: <Widget>[
                Form(
                  key: _key,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 100),
                      Text("Buat", style: TextStyle(color: Colors.teal, fontSize: 21, fontWeight: FontWeight.bold),),
                      Text("Password Baru", style: TextStyle(color: Colors.teal, fontSize: 21, fontWeight: FontWeight.bold),),
                      SizedBox(height: 20),
                      Text("Masukkan password baru kamu", style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold)),
                      SizedBox(height: 50),
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.teal,
                        child: Icon(Icons.lock_outline, color: Colors.white, size: 50.0,),
                      ),
                      SizedBox(height: 50),
                      w_Pass01,
                      SizedBox(height: 16.0),
                      w_Pass02,
                      SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                                padding: const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 18.0),
                                child: w_PassButton
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 48.0),
                    ],
                  ),
                )
              ],
            ),
            popup00(pop00Visible),
            popup01_loader(pop00Visible, "Processing Data, Please wait ...")
          ],
        )
    );
  }

  getUserPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      need_OTP_idf_user = prefs.getString("need_OTP_idf_user") ?? "";
      sf_trx_OTP_email = prefs.getString("sf_trx_OTP_email") ?? "";
      sf_trx_OTP_telp = prefs.getString("sf_trx_OTP_telp") ?? "";
      need_OTP_4 = prefs.getString("need_OTP_4") ?? "";
    });
  }

  Future GantiPass(String idf_user, String pass_new ) async{

    String msg000 = "";
    final String url00 = AppConfig().url_API + "mob-pass-change-v-otp";
    debugPrint(url00);
    try {
      final response = await http.post(Uri.parse(url00), body: {
        'idf_user' : idf_user ,
        'pass_new' : pass_new
      });

      if(response.statusCode == 200){
        final String responseString = response.body;
        var err_code0 = jsonDecode(responseString)["err_code"];
        var msg0 = jsonDecode(responseString)["message"];
        debugPrint(responseString + " errcode : $err_code0");
        if(err_code0==1) {
          if(msg0=="Password Salah"){ msg000 = "Password Lama Salah, Proses Update Gagal";  }
          else { msg000 = "Proses Update Gagal";  }
        }
        else if(err_code0==0){
          debugPrint("telah kirim");
          Navigator.pushReplacement(context, SlideRightRoute(page: RubahPassOTP_OK()));
        }
        //return responseString;
      }
      else {
        int a=response.statusCode; debugPrint("xxxx $a ");
        msg000 = "Proses Update Gagal, \nKoneksi ke Server gagal";
      }

    } catch (e) {
      String cek = "xxx.. $e"; // biar jadi string exceptionnya
      debugPrint(cek);

      if(cek.indexOf('unreachable') > -1){ msg000 = "No Internet Connection !";   }
      else{ msg000 = "Cannot Connect to Server !";  }
    }

    if(msg000 != ""){ myDialog00().alert0(context, "Notif", msg000); }

    setState(() {
      pop00Visible = false;
    });

  }

}

