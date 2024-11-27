import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../dialog00.dart';
import '../konfig000.dart';
import '../slide_anim.dart';
import 'profil_pass_edit_ok.dart';

class RubahPass extends StatefulWidget {
  @override
  _RubahPassState createState() => _RubahPassState();
}

class _RubahPassState extends State<RubahPass> {

  final _key = GlobalKey<FormState>();
  final TextEditingController _pass00_controller = TextEditingController();
  final TextEditingController _pass01_controller = TextEditingController();
  final TextEditingController _pass02_controller = TextEditingController();
  String s_pass00="", s_pass01="", s_pass02 ="";
  bool pop00Visible=false;

  String idf_user = "";
  String nama_user = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserPrefs();
  }

  @override
  Widget build(BuildContext context) {

    Widget w_Pass00 = TextFormField(
      decoration: InputDecoration(
        //icon: Icon(Icons.account_circle),
          filled: true,
          fillColor: Colors.white,
          prefixIcon: Icon(Icons.lock_outline),
          labelText: 'Password Sekarang',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
      ),
      obscureText: true,
      validator: (value){
        if(value!.isEmpty){ return "Harap isi Password"; }
        else { return null; }
      },
      controller: _pass00_controller,
    );

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
        else if(value.trim() != _pass01_controller.text.trim() ){ return "Konfirmasi Password tak sama"; }
        else { return null; }
      },
      controller: _pass02_controller,
    );

    Widget w_PassButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.teal,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        elevation: 3,
        fixedSize: const Size(300, 40),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Text(" SIMPAN ", style: TextStyle(fontSize: 14)),
      ),
      onPressed: (){
        if(_key.currentState!.validate()){

          setState(() {
            s_pass00 = _pass00_controller.text.trim();
            s_pass01 = _pass01_controller.text.trim();
            s_pass02 = _pass02_controller.text.trim();
            pop00Visible = true;
          });
          debugPrint("data submitted, $idf_user , $s_pass00 , $s_pass01");
          GantiPass(idf_user, s_pass00, s_pass01);
        }
      },
    );

    return Scaffold(
        appBar: AppBar(title: Text('Edit Password'), backgroundColor: Colors.teal,),
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
                      SizedBox(height: 20.0),
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.teal,
                        child: Icon(Icons.lock_outline, color: Colors.white, size: 50.0,),
                      ),
                      SizedBox(height: 20.0),
                      w_Pass00,
                      SizedBox(height: 16.0),
                      w_Pass01,
                      SizedBox(height: 16.0),
                      w_Pass02,
                      SizedBox(height: 16.0),
                      w_PassButton,
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
      idf_user = prefs.getString("idf_user") ?? "";
      nama_user = prefs.getString("nama_user") ?? "";
    });
  }

  Future GantiPass(String idf_user, String pass_old, String pass_new ) async{

    String msg000 = "";
    final String url00 = AppConfig().url_API + "mob-pass-change";
    debugPrint(url00);
    try {
      final response = await http.post(Uri.parse(url00), body: {
        'idf_user' : idf_user ,
        'pass_old' : pass_old ,
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
          Navigator.pushReplacement(context, SlideRightRoute(page: RubahPass_OK()));
        }
        //return responseString;
      }
      else {
        int a=response.statusCode; debugPrint("xxxx $a ");
        msg000 = "Proses Update Gagal, Koneksi ke Server gagal";
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

