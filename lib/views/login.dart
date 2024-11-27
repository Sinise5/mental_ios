import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../dialog00.dart';
import '../konfig000.dart';
import '../slide_anim.dart';
import 'daftar.dart';
import 'forgotpass.dart';
import 'home000.dart';


class Login0 extends StatefulWidget {
  @override
  _Login0State createState() => _Login0State();
}

class _Login0State extends State<Login0> {

  final _key = GlobalKey<FormState>();
  final TextEditingController _pass_controller = TextEditingController();
  final TextEditingController _user_controller = TextEditingController();
  String s_user="", s_pass="";
  bool passwordVisible=true;
  bool pop00Visible=false;

  @override
  Widget build(BuildContext context) {

    /*
    Widget w_Logo = Material(
      borderRadius: BorderRadius.all(Radius.circular(60)),
      elevation: 10,
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Image.asset("assets/images/logo001.png", width: 80, height: 80),
      ),
    );
     */

    Widget w_User = TextFormField(
      decoration: InputDecoration(
        //icon: Icon(Icons.account_circle),
          filled: true,
          fillColor: Colors.white,
          prefixIcon: Icon(Icons.account_circle),
          labelText: 'e-mail',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
      ),
      validator: (value){
        if(value!.isEmpty){ return "Harap isi e-mail anda "; }
        else { return null; }
      },
      controller: _user_controller,
      keyboardType: TextInputType.emailAddress //TextInputType.number,
    );

    Widget w_Pass = TextFormField(
      decoration: InputDecoration(
        //icon: Icon(Icons.lock),
          filled: true,
          fillColor: Colors.white,
          prefixIcon: Icon(Icons.lock),
          suffixIcon: IconButton(
              icon: Icon(
                passwordVisible
                    ? Icons.visibility
                    : Icons.visibility_off,
                color: Colors.grey,
              ),
              onPressed: () {
                // Update the state i.e. toogle the state of passwordVisible variable
                setState(() {
                  passwordVisible = !passwordVisible;
                });
              }),
          labelText: 'Password',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
      ),
      obscureText: passwordVisible,
      validator: (value){
        if(value!.isEmpty){ return "Harap isi Password"; }
        else { return null; }
      },
      controller: _pass_controller,
    );

    Widget w_LoginButton = ElevatedButton(
      onPressed: () {
        //Navigator.pushReplacement(context, SlideRightRoute(page: HomePage0()));

        if(_key.currentState!.validate()){
          setState(() {
            s_user = _user_controller.text.trim();
            s_pass = _pass_controller.text.trim();
            pop00Visible = true;
          });
          debugPrint("data submitted, $s_user , $s_pass");

          CobaLogin(s_user, s_pass);
          //_openLoadingDialog(context);
        }

      },
      child: Text("Login",  style: TextStyle(fontSize: 18)),
      style: ButtonStyle(
        padding: MaterialStateProperty.all(const EdgeInsets.all(10)),
        fixedSize: MaterialStateProperty.all(const Size(300, 45)),
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



    Widget w_LupaPass = Padding(
      padding: EdgeInsets.only(top:10.0, bottom: 10.0, right: 5.0),
      child: Align(
          alignment: Alignment.topRight,
          child: new GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ForgotPassPage()
              ));
            },
            child: new Text("lupa password ?  ", style: TextStyle(color: Colors.red), ),
          )
      ),
    );


    Widget w_Register = Padding(
      padding: EdgeInsets.only(top:10.0, bottom: 10.0, right: 5.0),
      child: Align(
        alignment: Alignment.center,
        child: RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: "belum punya akun ? , ",
                style: TextStyle(color: Colors.black),
              ),
              TextSpan(
                text: " daftar disini !",
                style: TextStyle(color: Colors.green, decoration: TextDecoration.underline,),
                recognizer: new TapGestureRecognizer()..onTap = () {
                  Navigator.pushReplacement(context, SlideRightRoute(page: Daftar0()));
                  //Navigator.of(context).push(MaterialPageRoute(  builder: (context) => Daftar0() ));
                },
              ),
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
            /*
            Image(
              image: AssetImage("assets/images/bg01.jpg"),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              fit: BoxFit.cover,
            ),
            */
            Container(
              /*
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/ico_qrcode.png"), fit: BoxFit.cover)
              ),
              */
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                children: <Widget>[
                  SizedBox(height: 100),
                  Form(
                    key: _key,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            //w_Logo,
                            //SizedBox(height: 10,),
                            Image.asset("assets/logo01_rejiwa.png", width: 200*0.7, height: 230*0.7 ),
                            SizedBox(height: 70),
                            w_User,
                            Padding( padding: EdgeInsets.only(bottom: 15.0)  ),
                            w_Pass,
                            SizedBox(height: 12),
                            w_LupaPass,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Expanded(
                                  child: Padding(
                                      padding: const EdgeInsets.fromLTRB(1.0, 0.0, 1.0, 18.0),
                                      child: w_LoginButton
                                  ),
                                ),
                              ],
                            ),
                            w_Register,
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


  Future CobaLogin(String user, String pass) async{

    final String url00 = AppConfig().url_API + "mob-login";
    debugPrint(url00);
    try {
      final response = await http.post(Uri.parse(url00), body: {
        'user' : user ,
        "pass" : pass
      });

      if(response.statusCode == 200){
        final String responseString = response.body;
        var err_code0 = jsonDecode(responseString)["err_code"];
        debugPrint(responseString + " errcode : $err_code0");
        if(err_code0==1) {
          _pass_controller.clear();
          _user_controller.clear();

          setState(() {
            pop00Visible = false;
          });
          //myDialog00().openDialog00(context, "User dan Password Tak Ditemukan !");
          myDialog00().alert0(context, "Alert", "User dan Password Tak Ditemukan !");
        }
        else if(err_code0==0){
          debugPrint("masuuuk");
          var idf_user0 = jsonDecode(responseString)["data"][0]["idf_member"];
          var nama_user0 = jsonDecode(responseString)["data"][0]["nama"];
          var deviceid_user0 = jsonDecode(responseString)["data"][0]["mob_device_id"];
          setUserPrefs(idf_user0, nama_user0, deviceid_user0);

          /*
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              // Set the name here
                settings: const RouteSettings(
                  name: "/home000",
                ),
              builder: (context) => HomePage0()
          )); */

          Navigator.pushReplacement(context, SlideRightRoute(page: HomePage0()));
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
      setState(() {
        pop00Visible = false;
      });
      if(cek.indexOf('unreachable') > -1){
        myDialog00().openDialog00(context, "No Internet Connection !");
      }else{
        myDialog00().openDialog00(context, "Cannot Connect to Server !");
      }
    }


  }

  Future setUserPrefs(String idf_user, String nama_user, String deviceid_user0) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("idf_user", idf_user);
    prefs.setString("nama_user", nama_user);
    prefs.setString("sf_device_id", deviceid_user0);
  }


}
