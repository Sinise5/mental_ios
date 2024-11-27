import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../dialog00.dart';
import '../konfig000.dart';
import '../slide_anim.dart';
import 'loader_calc.dart';
import 'test_mental_depresi.dart';

class TestMentalCemas0 extends StatefulWidget {
  @override
  _TestMentalCemas0State createState() => _TestMentalCemas0State();
}

class _TestMentalCemas0State extends State<TestMentalCemas0> {

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  List<String> _jawab = [];
  List<String> _soal = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      for (var i = 0; i < 8; i++) {
        _jawab.add("X");
        _soal.add("X");
      }
      _soal[1] = "Merasa gugup, cemas, atau gelisah";
      _soal[2] = "Tidak mampu menghentikan atau mengendalikan rasa khawatir";
      _soal[3] = "Khawatir berlebihan tentang berbagai hal";
      _soal[4] = "Sulit untuk merasa rileks";
      _soal[5] = "Begitu gelisah sehingga sulit untuk duduk diam";
      _soal[6] = "Menjadi mudah kesal atau jengkel";
      _soal[7] = "Merasa khawatir seakan sesuatu yang buruk akan terjadi";
    });
  }

  @override
  Widget build(BuildContext context) {

    Widget w_SaveButton = ElevatedButton(
      onPressed: () {  cek_jawab();   },
      child: Text("LANJUT",  style: TextStyle(fontSize: 14)),
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
      appBar: AppBar(title: Text('Tes Kecemasan'), backgroundColor: Colors.teal,),
      body: ListView(
        children: [
          Padding(
              padding: EdgeInsets.fromLTRB(30, 10, 30,10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10,),
                  Text("Alat skrining yang digunakan untuk ",
                      style: TextStyle(color: Colors.black, fontSize: 16,)),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.black, fontSize: 16,),
                      children: <TextSpan>[
                        TextSpan( text: "Tes Kecemasan adalah "),
                        TextSpan( text: " GAD-7 ", style: TextStyle(color: Colors.teal,), ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  Padding(
                    padding: EdgeInsets.fromLTRB(30, 10, 30,10),
                    child: Image.asset(
                      "assets/images/test_mental.png",
                      fit: BoxFit.fitWidth,
                      //width: MediaQuery.of(context).size.width - 80 ,
                      alignment: Alignment.topCenter,
                    ),
                  ),
                  SizedBox(height: 10,),
                  Text("Selama dua minggu terakhir, seberapa sering Anda terganggu oleh masalah-masalah berikut? ",
                    style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),

                  for (var x = 1; x < 8; x++)
                    Padding(
                      padding: EdgeInsets.only(top: 30),
                      child: CustomCardTest002("0" + x.toString(), _soal[x], _jawab[x],
                            (){ setState(() { _jawab[x] = "A"; }); },
                            (){ setState(() { _jawab[x] = "B"; }); },
                            (){ setState(() { _jawab[x] = "C"; }); },
                            (){ setState(() { _jawab[x] = "D"; }); },
                      ),
                    )
                  ,

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

  void cek_jawab() {
    int err = 0;
    int nilai = 0;
    for (var i = 1; i < 8; i++) {
      if( _jawab[i] == "X"){
        myDialog00().snackBar003(context, "Harap jawab semua pertanyaan");
        err = 1;
        i=8;
      }
      else if( _jawab[i] == "A"){ nilai += 0; }
      else if( _jawab[i] == "B"){ nilai += 1; }
      else if( _jawab[i] == "C"){ nilai += 2; }
      else if( _jawab[i] == "D"){ nilai += 3; }
    }
    if(err == 0){
      String _jawab0 = _jawab.join('|');

      setUserPrefs(nilai.toString(), _jawab0);
      //Navigator.pushReplacement(context, SlideRightRoute(page: TestMentalCemasResult0()));

      Navigator.pushReplacement(context, SlideRightRoute(page: LoaderCalc0()));
    }
  }

  Future setUserPrefs(String nilai0, String _jawab0) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("sf_nilai_test_cemas", nilai0);
    prefs.setString("sf_loader_calc_to", "TestMentalCemasResult0");
    prefs.setString("sf_jawab_test_cemas", _jawab0);
  }


}


class CustomCardTest002 extends StatelessWidget{

  String text01;
  String text02;
  String pilih;

  Function()? onTap1;
  Function()? onTap2;
  Function()? onTap3;
  Function()? onTap4;

  CustomCardTest002(this.text01, this.text02, this.pilih, this.onTap1, this.onTap2, this.onTap3, this.onTap4);

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
              Text("dari 07", style: TextStyle(color: Colors.grey, fontSize: 18,)),
            ],
          ),
          Text(text02,
              style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold)),
          SizedBox(height: 30,),

          CustomPilih001("Tidak sama sekali dalam 2 minggu", pilih=="A" ? true : false, onTap1 ),
          CustomPilih001("Beberapa hari dalam 2 minggu", pilih=="B" ? true : false, onTap2 ),
          CustomPilih001("Lebih dari separuh waktu dalam 2 minggu", pilih=="C" ? true : false, onTap3 ),
          CustomPilih001("Hampir setiap hari dalam 2 minggu", pilih=="D" ? true : false, onTap4 ),
        ],
      ),
    );
  }
}

