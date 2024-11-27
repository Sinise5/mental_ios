import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../dialog00.dart';
import '../konfig000.dart';
import '../slide_anim.dart';
import 'kontak_darurat.dart';
import 'test_mental.dart';


class KontakDaruratForm0 extends StatefulWidget {
  const KontakDaruratForm0({Key? key}) : super(key: key);

  @override
  State<KontakDaruratForm0> createState() => _KontakDaruratForm0State();
}

class _KontakDaruratForm0State extends State<KontakDaruratForm0> {

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _keyForm = GlobalKey<FormState>();
  final TextEditingController _nama_controller = TextEditingController();
  final TextEditingController _nohp_controller = TextEditingController();
  final TextEditingController _nowa_controller = TextEditingController();
  final TextEditingController _pesan_controller = TextEditingController();
  String s_nama="", s_nohp="", s_nowa="", s_pesan="";

  String idf_user="";

  String sf_kontak_darurat_idf = "x"; // 'x' -> loading;  'RK2022...'-> ini ada
  String sf_kontak_darurat_data = "";
  String sf_kontak_darurat_edit_idx = "";


  bool pop00Visible=false;
  bool pop00_addData=false;


  double inpBorderRadius = 15;


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
            Text('Kontak Darurat', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold ),),
          ],
        )
    );

    Widget w_SimpanBtn = CustomButtonDark001("Simpan", () {

      var vv0 = _nowa_controller.text.trim().toString();
      if(vv0.substring(0, 2) == "08" ){
        var vv = vv0.substring(1);
        _nowa_controller.text = vv ;
      }

      vv0 = _nohp_controller.text.trim().toString();
      if(vv0.substring(0, 2) == "08" ){
        var vv = vv0.substring(1);
        _nohp_controller.text = vv ;
      }

        if(_keyForm.currentState!.validate()){

          setState(() {
            s_nama = _nama_controller.text.trim();
            s_nohp = _nohp_controller.text.trim();
            s_nowa = _nowa_controller.text.trim();
            s_pesan = _pesan_controller.text.trim();

            pop00_addData = true ;
          });
          debugPrint("data submitted, $s_nama , $s_nohp");

          CobaSimpan();
        }
    });

    Widget w_Nama = TextFormField(
      decoration: InputDecoration(
        //icon: Icon(Icons.account_circle),
        filled: true,
        fillColor: Colors.white,
        focusedBorder:OutlineInputBorder(
          borderSide: BorderSide(color: Colors.teal.shade300, width: 2.0),
          borderRadius: BorderRadius.circular(inpBorderRadius),
        ),
        //prefixIcon: Icon(Icons.person),
        labelText: 'Namaku Adalah',
        floatingLabelBehavior: FloatingLabelBehavior.never,
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(inpBorderRadius),
        ),
      ),
      validator: (value){
        if(value!.isEmpty){ return "Harap isi Nama"; }
        else { return null; }
      },
      controller: _nama_controller,
    );

    Widget w_NoHP = TextFormField(
      decoration: InputDecoration(
        //icon: Icon(Icons.account_circle),
        filled: true,
        fillColor: Colors.white,
        focusedBorder:OutlineInputBorder(
          borderSide: BorderSide(color: Colors.teal.shade300, width: 2.0),
          borderRadius: BorderRadius.circular(inpBorderRadius),
        ),
        prefixIcon:Text("     +62  "),
        prefixIconConstraints: BoxConstraints(minWidth: 50, minHeight: 0),
        //labelText: 'Nama Lengkap',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(inpBorderRadius),
        ),
        counterText: ""
      ),
      validator: (value){
        if(value!.isEmpty){ return "Harap isi No. HP"; }
        else if(value.length<10){ return "Harap Isi Dengan Nomor Yang Valid"; }
        //else if(value.toString().substring(0, 2)!="08" && value.toString().substring(0, 1)!="8"){
        else if(value.toString().substring(0, 1)!="8" ){
          return "Harap Isi Dengan Nomor Yang Valid ( diawali +62 8xxx )";
        }
        else { return null; }
      },
      controller: _nohp_controller,
      keyboardType: TextInputType.phone,
      maxLength: 14,
    );

    Widget w_NoWA = TextFormField(
        decoration: InputDecoration(
          //icon: Icon(Icons.account_circle),
          filled: true,
          fillColor: Colors.white,
          focusedBorder:OutlineInputBorder(
            borderSide: BorderSide(color: Colors.teal.shade300, width: 2.0),
            borderRadius: BorderRadius.circular(inpBorderRadius),
          ),
          prefixIcon:Text("     +62  "),
          prefixIconConstraints: BoxConstraints(minWidth: 50, minHeight: 0),
          //labelText: 'Nama Lengkap',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(inpBorderRadius),
          ),
          counterText: ""
        ),
        validator: (value){
          if(value!.isEmpty){ return "Harap isi No. WhatsApp"; }
          else if(value.length<10){ return "Harap Isi Dengan Nomor Yang Valid"; }
          //else if(value.toString().substring(0, 2)!="08" && value.toString().substring(0, 1)!="8" ){
          else if(value.toString().substring(0, 1)!="8" ){
              return "Harap awali +62 8xxxxxxxxxxxxx ";
          }
          else { return null; }
        },
        controller: _nowa_controller,
        keyboardType: TextInputType.phone,
        maxLength: 14,
    );

    Widget w_TempPesan = TextFormField(
      decoration: InputDecoration(
        //icon: Icon(Icons.account_circle),
        filled: true,
        fillColor: Colors.white,
        focusedBorder:OutlineInputBorder(
          borderSide: BorderSide(color: Colors.teal.shade300, width: 2.0),
          borderRadius: BorderRadius.circular(inpBorderRadius),
        ),
        prefixIcon: const Icon(
          Icons.edit,
          color: Colors.blue,
        ),
        labelText: 'Tulis disini',
        floatingLabelBehavior: FloatingLabelBehavior.never,
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(inpBorderRadius),
        ),
      ),
      validator: (value){
        if(value!.isEmpty){ return "Harap isi Pesan"; }
        else { return null; }
      },
      controller: _pesan_controller,
      maxLines: null,
      keyboardType: TextInputType.multiline,
      maxLength: 250,
    );




    return Scaffold(
        backgroundColor: Colors.white,
        //appBar: AppBar(title: Text('Tes Kesehatan Mental'), backgroundColor: Colors.teal,),
        body: Stack(
          children: [
            ListView(
              children: [
                w_judul,
                SizedBox(height: 50,),
                Center(
                  child: Text(((sf_kontak_darurat_edit_idx != "" ) ? 'Edit' : 'Tambah') + ' Kontak Darurat', style: TextStyle(color: Colors.black, fontSize: 21, fontWeight: FontWeight.bold ),),
                ),
                Form(
                  key: _keyForm,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(30, 10, 30,10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20,),
                        Text('Nama', style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold, )),
                        SizedBox(height: 7,),
                        w_Nama,
                        SizedBox(height: 20,),
                        Text('Nomor Handphone', style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold, )),
                        SizedBox(height: 7,),
                        w_NoHP,
                        SizedBox(height: 20,),
                        Text('Nomor Whatsapp', style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold, )),
                        SizedBox(height: 7,),
                        w_NoWA,
                        SizedBox(height: 20,),
                        Text('Template Pesan', style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold, )),
                        SizedBox(height: 7,),
                        w_TempPesan,
                        SizedBox(height: 60,),
                        w_SimpanBtn
                      ],
                    )
                ),
                ),

                SizedBox(height: 100,),
              ],
            ),

            popup00(pop00_addData),
            popup01_loader(pop00_addData, "Processing Data ...")
          ],
        )
    );

  }


  getUserPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    var a = prefs.getString("idf_user") ?? "";
    var b = prefs.getString("sf_kontak_darurat_idf") ?? "x";
    var c = prefs.getString("sf_kontak_darurat_data") ?? "";
    var d = prefs.getString("sf_kontak_darurat_edit_idx") ?? "";

    getUserPrefs_1(a, b, c, d);
  }

  getUserPrefs_1(idf_user0, sf_kontak_darurat_idf, sf_kontak_darurat_data0, sf_kontak_darurat_edit_idx0) {
    setState(() {
      idf_user = idf_user0;
      sf_kontak_darurat_data = sf_kontak_darurat_data0 ;
      sf_kontak_darurat_edit_idx = sf_kontak_darurat_edit_idx0 ;

      if(idf_user != ""){
        pop00Visible = true;
        if(sf_kontak_darurat_idf=="x" || sf_kontak_darurat_idf != idf_user) {
          //ambilDataUser(idf_user);
        }
      }

      if(sf_kontak_darurat_edit_idx != "" ){
        debugPrint('edit euy ' + sf_kontak_darurat_edit_idx) ;
        isiBuatEdit(int.parse(sf_kontak_darurat_edit_idx));
        setUserPrefs_editReset();
      }

    });
  }

  Future ambilDataUser(String idf_user) async{

    String sBar = "";
    final String url00 = AppConfig().url_API + "mob-data-kontak_darurat";
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
            sf_kontak_darurat_idf = jsonDecode(responseString)["data"][0]["idf_mob_r_keamanan"];
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

    setState(() {
      pop00Visible = false;
      sf_kontak_darurat_idf = idf_user;
    });
    debugPrint("sf_kontak_darurat_idf : " + sf_kontak_darurat_idf);

  }

  CobaSimpan() {
    if(sf_kontak_darurat_edit_idx == "" ){
      setUserPrefs_kontak();
    }
    else {
      setUserPrefs_kontak_edit(int.parse(sf_kontak_darurat_edit_idx));
    }

    Navigator.pushReplacement(context, SlideRightRoute(page: const KontakDarurat0()));

  }

  Future setUserPrefs_kontak() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var kontak0 = {
      "nama": s_nama,
      "nohp": s_nohp,
      "nowa": s_nowa,
      "pesan": s_pesan
    } ;
    List datakontak = [];

    if(sf_kontak_darurat_data != ""){
      datakontak = json.decode(sf_kontak_darurat_data);
    }

    datakontak.add(kontak0);
    prefs.setString("sf_kontak_darurat_data", jsonEncode(datakontak));
    prefs.setString("sf_kontak_darurat_kirimserver", "1");

  }

  Future setUserPrefs_editReset() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //prefs.setString("sf_kontak_darurat_edit_idx", "");
    prefs.remove('sf_kontak_darurat_edit_idx');
  }

  Future setUserPrefs_kontak_edit(idx0) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var kontak0 = {
      "nama": s_nama,
      "nohp": s_nohp,
      "nowa": s_nowa,
      "pesan": s_pesan
    } ;
    List datakontak = [];

    if(sf_kontak_darurat_data != ""){
      datakontak = json.decode(sf_kontak_darurat_data);
    }

    datakontak[idx0] = kontak0 ;

    prefs.setString("sf_kontak_darurat_data", jsonEncode(datakontak));
    prefs.setString("sf_kontak_darurat_kirimserver", "1");
  }

  isiBuatEdit(idx0) {
    var datakontak = json.decode(sf_kontak_darurat_data);
    _nama_controller.text = datakontak[idx0]['nama'];
    _nohp_controller.text = datakontak[idx0]['nohp'];
    _nowa_controller.text = datakontak[idx0]['nowa'];
    _pesan_controller.text = datakontak[idx0]['pesan'];
  }



}
