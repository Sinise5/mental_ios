import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../dialog00.dart';
import '../slide_anim.dart';
import 'kontak_darurat.dart';
import 'kontak_darurat_f.dart';
import 'test_mental.dart';

class KontakDaruratDet0 extends StatefulWidget {
  const KontakDaruratDet0({Key? key}) : super(key: key);

  @override
  State<KontakDaruratDet0> createState() => _KontakDaruratDet0State();
}

class _KontakDaruratDet0State extends State<KontakDaruratDet0> {

  String s_nama="", s_nohp="", s_nowa="", s_pesan="";

  String idf_user="";
  String sf_kontak_darurat_data = "";
  String sf_kontak_darurat_detail_idx = "";

  bool pop00_delData=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserPrefs();
  }

  @override
  Widget build(BuildContext context) {

    Widget wJudul = Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              child: const Icon( Icons.arrow_back_ios, color: Colors.black, size: 20, ),
              onTap: (){ Navigator.of(context).pop(); },
            ),
            const SizedBox(height: 20,),
            const Text('Kontak Darurat', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold ),),
          ],
        )
    );

    Widget wBtnPerson = Container(
        width: 100,
        child: RawMaterialButton(
          onPressed: () {},
          elevation: 2.0,
          fillColor: Colors.grey.shade400,
          child: Icon(
            Icons.person,
            size: 70.0,
            color: Colors.white,
          ),
          padding: EdgeInsets.all(10.0),
          shape: CircleBorder(),
        )
    );

    Widget wBtnTlp = Container(
        width: 60,
        child: RawMaterialButton(
          onPressed: () { _makePhoneCall(s_nohp) ; },
          elevation: 2.0,
          fillColor: Colors.teal ,
          padding: const EdgeInsets.all(10.0),
          shape: CircleBorder(),
          child: const Icon(
            Icons.phone,
            size: 40.0,
            color: Colors.white,
          ),
        )
    );

    Widget wBtnWa = Container(
      width: 60,
      child: RawMaterialButton(
        onPressed: () {
          var url = "https://wa.me/62"+s_nowa+"/?text=" + Uri.encodeComponent(s_pesan) ;
          _launchInBrowser(Uri.parse(url));
        },
        elevation: 2.0,
        fillColor: Colors.teal,
        child: const Icon(
          Icons.chat_rounded,
          size: 40.0,
          color: Colors.white ,
        ),
        padding: const EdgeInsets.all(10.0),
        shape: const CircleBorder(),
      ),
    );

    Widget wMain0 = Column(
      children: [
        wBtnPerson,
        SizedBox(height: 16,),
        Text(s_nama, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold )),
        SizedBox(height: 16,),
        Text('HP :   +62' + s_nohp, style: TextStyle(fontSize: 20 )),
        SizedBox(height: 10,),
        Text('WA :   +62' + s_nowa, style: TextStyle(fontSize: 20 )),
        SizedBox(height: 30,),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            wBtnTlp,
            SizedBox(width: 50,),
            wBtnWa
          ],
        )
      ],
    );

    Widget wEditBtn = Padding(
        padding: EdgeInsets.fromLTRB(100, 0, 100, 10),
        child: CustomButtonDark001("Edit", (){ editKontak(); })
    );

    Widget wDelBtn = Padding(
        padding: EdgeInsets.fromLTRB(100, 0, 100, 10),
        child: CustomButtonDark001("Hapus", (){ showAlertDialog0(context); })
    );



    return Scaffold(
        backgroundColor: Colors.white,
        //appBar: AppBar(title: Text('Tes Kesehatan Mental'), backgroundColor: Colors.teal,),
        body: Stack(
          children: [
            ListView(
              children: [
                wJudul,
                SizedBox(height: 70,),
                wMain0,
                SizedBox(height: 90,),
                wEditBtn,
                SizedBox(height: 10,),
                wDelBtn
              ],
            ),

            popup00(pop00_delData),
            popup01_loader(pop00_delData, "Processing Data ...")
          ],
        )
    );

  }


  getUserPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    var a = prefs.getString("idf_user") ?? "";
    var b = prefs.getString("sf_kontak_darurat_idf") ?? "x";
    var c = prefs.getString("sf_kontak_darurat_data") ?? "";
    var d = prefs.getString("sf_kontak_darurat_detail_idx") ?? "";

    getUserPrefs_1(a, b, c, d);
  }

  getUserPrefs_1(idfUser0, sfKontakDaruratIdf, sfKontakDaruratData0, sfKontakDaruratDetailIdx0) {
    setState(() {
      idf_user = idfUser0;
      sf_kontak_darurat_data = sfKontakDaruratData0 ;
      debugPrint('detdet : '+sf_kontak_darurat_data);
      sf_kontak_darurat_detail_idx = sfKontakDaruratDetailIdx0 ;

      if(idf_user != ""){
        if(sfKontakDaruratIdf=="x" || sfKontakDaruratIdf != idf_user) {
          //ambilDataUser(idf_user);
        }
      }

      if(sf_kontak_darurat_detail_idx != "" ){
        debugPrint('detail euy ' + sf_kontak_darurat_detail_idx) ;
        isiDataDetail(int.parse(sf_kontak_darurat_detail_idx));

      }

    });
  }

  isiDataDetail(idx0) {
    var datakontak = json.decode(sf_kontak_darurat_data);
    setState(() {
      s_nama = datakontak[idx0]['nama'];
      s_nohp = datakontak[idx0]['nohp'];
      s_nowa = datakontak[idx0]['nowa'];
      s_pesan = datakontak[idx0]['pesan'];
    });

  }

  editKontak() {
    debugPrint('edit kontak index : $sf_kontak_darurat_detail_idx' );
    setUserPrefs_kontak_edit(sf_kontak_darurat_detail_idx);
    Navigator.push(context, SlideRightRoute(page: KontakDaruratForm0()));
  }


  Future setUserPrefs_kontak_edit(idx0) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("sf_kontak_darurat_edit_idx", idx0);
  }

  hapusKontak() {
    setState(() {
      pop00_delData = true ;
    });

    setUserPrefs_kontak_hapus(int.parse(sf_kontak_darurat_detail_idx));
    //Navigator.pushReplacement(context, SlideRightRoute(page: KontakDarurat0()));
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
        KontakDarurat0()), (Route<dynamic> route) => false);
  }

  Future setUserPrefs_kontak_hapus(idx0) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List datakontak = [];

    if(sf_kontak_darurat_data != ""){
      datakontak = json.decode(sf_kontak_darurat_data);
    }

    datakontak.removeAt(idx0);

    prefs.setString("sf_kontak_darurat_data", jsonEncode(datakontak));
    prefs.setString("sf_kontak_darurat_kirimserver", "1");
  }

  showAlertDialog0(BuildContext context) {
    // set up the buttons
    Widget cancelButton = GestureDetector(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Text('Batal', style: TextStyle(color: Colors.teal, fontSize: 16, fontWeight: FontWeight.bold ),),
      ) ,
      onTap: (){ Navigator.of(context).pop(); },
    );
    Widget okButton = GestureDetector(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Text('Hapus', style: TextStyle(color: Colors.teal, fontSize: 16, fontWeight: FontWeight.bold ),),
      ) ,
      onTap: (){ hapusKontak(); },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Konfirmasi"),
      content: Text("Apa anda yakin menghapus data ini ?"),
      actions: [
        cancelButton,
        okButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: '+62'+phoneNumber,
    );
    await launchUrl(launchUri);
  }

  Future<void> _launchInBrowser(Uri url) async {
    //const url = "https://wa.me/?text=Your%20text%20here";
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }



}
