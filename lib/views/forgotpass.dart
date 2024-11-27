import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../dialog00.dart';
import '../konfig000.dart';
import '../slide_anim.dart';
import 'daftar_otp.dart';


class ForgotPassPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ForgotPassPageState();
  }
}

class ForgotPassPageState extends State<ForgotPassPage> {

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _keyForm = GlobalKey<FormState>();
  bool pop00LupaPassLoaderVisible = false;
  bool ketketVisible = false;
  String agen_email="";
  final TextEditingController _email_controller = TextEditingController();
  String sf_trx_OTP_email = "";

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    Widget w_Email = TextFormField(
        decoration: InputDecoration(
          //icon: Icon(Icons.account_circle),
            filled: true,
            fillColor: Colors.white,
            prefixIcon: Icon(Icons.mail_outline),
            labelText: 'Email',
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
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

    Widget w_ForgotButton = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Expanded(
          child: Padding(
              padding: const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 18.0),
              child: ElevatedButton(
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
                child: Text("KIRIM KE EMAIL".toUpperCase(),
                    style: TextStyle(fontSize: 14)),
                onPressed: () {
                  if(_keyForm.currentState!.validate()){

                    String email = _email_controller.text.trim();
                    lupaPassPros(email);

                    setState(() {
                      agen_email = email;
                      pop00LupaPassLoaderVisible =true;
                    });
                  }
                },
              )
          ),
        ),
      ],
    );

    /*
    Widget w_ForgotButtonXX = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Expanded(
          child: Padding(
              padding: const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 18.0),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.teal)),
                color: Colors.teal,
                textColor: Colors.white,
                child: Text("KIRIM KE EMAIL".toUpperCase(),
                    style: TextStyle(fontSize: 14)),
                onPressed: () {
                  if(_keyForm.currentState!.validate()){

                    String email = _email_controller.text.trim();
                    lupaPassPros(email);

                    setState(() {
                      agen_email = email;
                      pop00LupaPassLoaderVisible =true;
                    });
                  }
                },
              )
          ),
        ),
      ],
    );
    */

    Widget w_MasukOTPButton = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Expanded(
          child: Padding(
              padding: const EdgeInsets.fromLTRB(40.0, 0.0, 40.0, 18.0),
              child: ElevatedButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(const EdgeInsets.all(10)),
                  fixedSize: MaterialStateProperty.all(const Size(300, 40)),
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.green)
                      )
                  ),
                ),
                child: Text("MASUKKAN KODE OTP".toUpperCase(),
                    style: TextStyle(fontSize: 14)),
                onPressed: () {
                  if(_keyForm.currentState!.validate()){
                    String email = _email_controller.text.trim();
                    setDataPrefs2(email);
                    LupaPassGo2();
                  }
                },
              )
          ),
        ),
      ],
    );

    /*
    Widget w_MasukOTPButtonXX = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Expanded(
          child: Padding(
              padding: const EdgeInsets.fromLTRB(40.0, 0.0, 40.0, 18.0),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.green)),
                color: Colors.green,
                textColor: Colors.white,
                child: Text("MASUKKAN KODE OTP".toUpperCase(),
                    style: TextStyle(fontSize: 14)),
                onPressed: () {
                  if(_keyForm.currentState!.validate()){
                    String email = _email_controller.text.trim();
                    setDataPrefs2(email);
                    LupaPassGo2();
                  }
                },
              )
          ),
        ),
      ],
    );
     */

    Widget w_ketket = Visibility(
      visible: ketketVisible,
      child: Container(
        width: double.infinity,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          color: Colors.yellow[100],
          elevation: 0,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column (
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 10),
                Text("EMAIL $agen_email \nDATA TAK DITEMUKAN",  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red), ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );

    return Scaffold(
        key: _scaffoldKey,
        //appBar: AppBar(title: Text('Lupa Password')),
        body: Stack(
          children: <Widget>[
            /*
            Image(
              image: AssetImage("assets/images/bg01.jpg"),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              fit: BoxFit.cover,
            ),
            */
            ListView(
                shrinkWrap: true,
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                children: <Widget>[
                  Form(
                      key: _keyForm,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(height: 100),
                            Text("Masukkan e-mail kamu untuk", style: TextStyle(color: Colors.teal, fontSize: 21, fontWeight: FontWeight.bold),),
                            Text("mengatur ulang password", style: TextStyle(color: Colors.teal, fontSize: 21, fontWeight: FontWeight.bold),),
                            SizedBox(height: 20),
                            Text("Masukkan e-mail kamu untuk", style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold)),
                            Text("mereset password", style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold)),
                            SizedBox(height: 50),
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.teal,
                              child: Icon(Icons.lock_outline, color: Colors.white, size: 50.0,),
                            ),

                            SizedBox(height: 50),
                            w_Email,
                            SizedBox(height: 20),
                            w_ForgotButton,
                            SizedBox(height: 16.0),
                            //w_MasukOTPButton,
                            SizedBox(height: 30.0),
                            w_ketket
                          ]
                      )
                  ),
                ]
            ),
            popup00(pop00LupaPassLoaderVisible),
            popup01_loader(pop00LupaPassLoaderVisible, "Processing, please wait ..."),
          ],
        )
    );

  }

  Future lupaPassPros(String email) async{

    String sBar = "";
    final String url00 = AppConfig().url_API + "mob-lupa-pass";
    debugPrint(url00 + " --> " + email );
    try {
      final response = await http.post(Uri.parse(url00), body: {
        'email' : email ,
      });

      if(response.statusCode == 200){
        final String responseString = response.body;
        var err_code0 = jsonDecode(responseString)["err_code"];
        debugPrint(responseString + " errcode : $err_code0");

        if(err_code0==0){
          debugPrint("masuuuk");
          String agen_idf = jsonDecode(responseString)["agen_idf"];
          String agen_email = jsonDecode(responseString)["agen_email"];
          String agen_tlp = jsonDecode(responseString)["agen_tlp"];

          setState(() {
            ketketVisible = false;
          });


          setDataPrefs(agen_idf, agen_email, agen_tlp);

          LupaPassGo2();


        }
        else if(err_code0==1) {
          sBar = "Data Not found!";
          setState(() {
            ketketVisible = true;
          });
        }
      }
      else {
        int a=response.statusCode; debugPrint("xxxx $a ");
        sBar = "No Connection!";
      }

      FocusScope.of(context).unfocus();

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
      pop00LupaPassLoaderVisible=false;
    });

  }


  void LupaPassGo2() {
    Navigator.push(context, SlideRightRoute(page: DaftarOTP_0()));
  }

  Future setDataPrefs(String agen_idf, String agen_email, String agen_telp) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("need_OTP_4", "forgotPass");
    prefs.setString("need_OTP_idf_user", agen_idf);
    prefs.setString("sf_trx_OTP_email", agen_email);
    prefs.setString("sf_trx_OTP_telp", agen_telp);
  }

  Future setDataPrefs2(String agen_email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("need_OTP_4", "forgotPass");
    prefs.setString("sf_trx_OTP_email", agen_email);
  }


  getUserPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      sf_trx_OTP_email = prefs.getString("sf_trx_OTP_email") ?? "";
    });
  }

}