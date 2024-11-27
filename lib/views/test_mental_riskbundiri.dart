import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../dialog00.dart';
import '../konfig000.dart';
import '../slide_anim.dart';
import 'loader_calc.dart';


class TestMentalRBunDiri0 extends StatefulWidget {
  @override
  _TestMentalRBunDiri0State createState() => _TestMentalRBunDiri0State();
}

class _TestMentalRBunDiri0State extends State<TestMentalRBunDiri0> {

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  List<String> _jawab = [];
  List<String> _soal = [];

  bool harus_jawab_no5 = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      for (var i = 0; i < 6; i++) {
        _jawab.add("X");
        _soal.add("X");
      }
      _soal[1] = "Pernahkah dalam beberapa minggu terakhir kamu berfikir lebih baik mati ?";
      _soal[2] = "Pernahkah dalam beberapa minggu terakhir merasa kamu atau keluargamu akan lebih baik apabila kamu mati ?";
      _soal[3] = "Dalam beberapa minggu ini, apakah kamu berfikir untuk mengakhiri hidup ?";
      _soal[4] = "Apakah kamu pernah mencoba melakukan bunuh diri?";
      _soal[5] = "Apakah kamu berfikir untuk melakukan bunuh diri saat ini?";
    });
  }

  @override
  Widget build(BuildContext context) {

    Widget w_SaveButton = ElevatedButton(
      onPressed: () {  cek_jawab();   },
      child: Text("Cek Hasil",  style: TextStyle(fontSize: 14)),
      style: ButtonStyle(
        padding: MaterialStateProperty.all(const EdgeInsets.all(16)),
        fixedSize: MaterialStateProperty.all(const Size(300, 50)),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
                side: BorderSide(color: Colors.black)
            )
        ),
      ),
    );

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('Penilaian Risiko Bunuh Diri'), backgroundColor: Colors.teal,),
      body: ListView(
        children: [
          Padding(
              padding: EdgeInsets.fromLTRB(30, 10, 30,10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10,),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Image.asset(
                      "assets/images/test_mental2.png",
                      fit: BoxFit.fitWidth,
                      //width: MediaQuery.of(context).size.width - 80 ,
                      alignment: Alignment.topCenter,
                    ),
                  ),
                  SizedBox(height: 10,),
                  const Align(
                    alignment: Alignment.center,
                    child: Text("Skrining Risiko Bunuh Diri ",
                      style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center,)
                  ),


                  for (var x = 1; x < 5; x++)  // --- 1-4 saja
                    Padding(
                      padding: EdgeInsets.only(top: 30),
                      child: CustomCardTest002("0" + x.toString(), _soal[x], _jawab[x],
                            (){ setState(() { _jawab[x] = "Y"; cekHarusIsi5(); }); },
                            (){ setState(() { _jawab[x] = "N"; cekHarusIsi5(); }); },
                      ),
                    )

                  ,
                  Padding(
                    padding: EdgeInsets.only(top: 30),
                    child: CustomCardTest002b("05" , _soal[5], _jawab[5],
                          (){ setState(() { _jawab[5] = "Y"; }); },
                          (){ setState(() { _jawab[5] = "N"; }); },
                        harus_jawab_no5
                    ),
                  ),


                  SizedBox(height: 50,),
                  w_SaveButton,
                  SizedBox(height: 100,),
                ],
              )
          )
        ],
      ),
    );
  }

  /*
  void cek_jawab22() {
    int err = 0;
    int nilai = 0;
    for (var i = 1; i < 6; i++) {
      if( _jawab[i] == "X"){
        myDialog00().snackBar003(context, "Harap jawab semua pertanyaan");
        err = 1;
        i=6;
      }
      else if( _jawab[i] == "Y"){ nilai += 1; }
      else if( _jawab[i] == "N"){ nilai += 0; }
    }
    if(err == 0){
      setUserPrefs(nilai.toString());
      //Navigator.pushReplacement(context, SlideRightRoute(page: TestMentalRiskBunDiriResult0()));
      Navigator.pushReplacement(context, SlideRightRoute(page: LoaderCalc0()));
    }
  }
  */

  void cek_jawab() {
    int err = 0;
    int nilai = 0;

    // --- cek 1-4 ---
    int jawab14 = 0;
    for (var i = 1; i < 5; i++) {
      if( _jawab[i] == "X"){
        myDialog00().snackBar003(context, "Harap jawab semua pertanyaan no. 1-4");
        err = 1;
        i=60;
      }
      else if( _jawab[i] == "Y"){ jawab14 += 1; }
      //else if( _jawab[i] == "N"){ nilai += 0; }
    }

    if(jawab14 == 0){
      nilai = 1;
    }
    else if(jawab14 > 0){
      if( _jawab[5] == "X"){
        myDialog00().snackBar003(context, "Harap jawab pertanyaan no. 5");
        err = 1;
      }
      else if( _jawab[5] == "N"){ nilai = 2; }
      else if( _jawab[5] == "Y"){ nilai = 3; }
    }

    if(err == 0){
      String _jawab0 = _jawab.join('|');

      setUserPrefs(nilai.toString(), _jawab0);
      //Navigator.pushReplacement(context, SlideRightRoute(page: TestMentalRiskBunDiriResult0()));

      Navigator.pushReplacement(context, SlideRightRoute(page: LoaderCalc0()));
    }
  }

  Future setUserPrefs(String nilai0, String _jawab0) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("sf_nilai_test_riskbundiri", nilai0);
    prefs.setString("sf_loader_calc_to", "TestMentalRiskBunDiriResult0");
    prefs.setString("sf_jawab_test_riskbundiri", _jawab0);
  }

  void cekHarusIsi5() {
    // --- cek 1-4 ,
    // jika semua N, 5 tak harus jawab
    // jika ada 1 aja jawab Y , 5 harus jawab ---
    int jawab14 = 0;
    for (var i = 1; i < 5; i++) {
      if( _jawab[i] == "Y"){ jawab14 += 1; }
    }

    bool harus5 = false;
    if(jawab14 > 0){    harus5 = true;    }

    setState(() {
      harus_jawab_no5 = harus5;
    });

  }


}


class CustomPilihYN001 extends StatelessWidget{

  String text01;
  bool isOn;
  Function()? onTap0;

  CustomPilihYN001(this.text01, this.isOn, this.onTap0);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
        shape: RoundedRectangleBorder(  borderRadius: BorderRadius.circular(50),  ),
        color: isOn ? Colors.red : AppConfig().biru01 ,
        elevation: 2,
        child: InkWell(
          onTap: onTap0,
          borderRadius: BorderRadius.circular(50),
          child: Container(
            width: 50,
            height: 50,
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: (text01 == "Y")
                ? Icon(Icons.check, color: Colors.white, size: 31)
                : Icon(Icons.close, color: Colors.white, size: 31)
          ),
        )
    );
  }
}

class CustomCardTest002 extends StatelessWidget{

  String text01;
  String text02;
  String pilih;

  Function()? onTap1;
  Function()? onTap2;

  CustomCardTest002(this.text01, this.text02, this.pilih, this.onTap1, this.onTap2);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 30),
      constraints: BoxConstraints(  //pake constraint biar ga overflow
        minWidth: MediaQuery.of(context).size.width - 3 ,
        maxWidth: MediaQuery.of(context).size.width - 3 ,
        minHeight: 200, ),
      decoration: BoxDecoration(
        color: Colors.teal.shade50,
        borderRadius:BorderRadius.all(Radius.circular(17), ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.all(15.0),
                padding: const EdgeInsets.all(3.0),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide( //                    <--- top side
                      color: AppConfig().biru01,
                      width: 3.0,
                    ),
                  ),
                ),
                child: Text(text01, style: TextStyle(color: Colors.black, fontSize: 22,)),
              ),
              Text("dari 05", style: TextStyle(color: Colors.grey, fontSize: 18,)),
            ],
          ),
          Text(text02,
              style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold)),
          SizedBox(height: 30,),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomPilihYN001("Y", pilih=="Y" ? true : false, onTap1 ),
              SizedBox(width: 26,),
              CustomPilihYN001("N", pilih=="N" ? true : false, onTap2 ),
            ],
          ),

        ],
      ),
    );
  }
}

class CustomPilihYN001_off extends StatelessWidget{

  String text01;

  CustomPilihYN001_off(this.text01);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
        shape: RoundedRectangleBorder(  borderRadius: BorderRadius.circular(50),  ),
        color: Colors.grey[400] ,
        elevation: 2,
        child: InkWell(
          onTap: (){},
          borderRadius: BorderRadius.circular(50),
          child: Container(
              width: 50,
              height: 50,
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: (text01 == "Y")
                  ? Icon(Icons.check, color: Colors.white, size: 31)
                  : Icon(Icons.close, color: Colors.white, size: 31)
          ),
        )
    );
  }
}

class CustomCardTest002b extends StatelessWidget{

  String text01;
  String text02;
  String pilih;
  bool harusIsi=false;

  Function()? onTap1;
  Function()? onTap2;

  CustomCardTest002b(this.text01, this.text02, this.pilih, this.onTap1, this.onTap2, this.harusIsi);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 30),
      constraints: BoxConstraints(  //pake constraint biar ga overflow
        minWidth: MediaQuery.of(context).size.width - 3 ,
        maxWidth: MediaQuery.of(context).size.width - 3 ,
        minHeight: 200, ),
      decoration: BoxDecoration(
        color: Colors.teal.shade50,
        borderRadius:BorderRadius.all(Radius.circular(17), ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.all(15.0),
                padding: const EdgeInsets.all(3.0),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide( //                    <--- top side
                      color: AppConfig().biru01,
                      width: 3.0,
                    ),
                  ),
                ),
                child: Text(text01, style: TextStyle(color: Colors.black, fontSize: 22,)),
              ),
              Text("dari 05", style: TextStyle(color: Colors.grey, fontSize: 18,)),
            ],
          ),
          Text(text02,
              style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold)),
          SizedBox(height: 30,),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              harusIsi == true
                ? CustomPilihYN001("Y", pilih=="Y" ? true : false, onTap1 )
                : CustomPilihYN001_off("Y"),
              SizedBox(width: 26,),
              harusIsi == true
                ? CustomPilihYN001("N", pilih=="N" ? true : false, onTap2 )
                : CustomPilihYN001_off("N"),
            ],
          ),

        ],
      ),
    );
  }
}
