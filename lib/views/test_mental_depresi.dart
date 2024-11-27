import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../dialog00.dart';
import '../konfig000.dart';
import '../slide_anim.dart';
import 'loader_calc.dart';


class TestMentalDepresi0 extends StatefulWidget {
  @override
  _TestMentalDepresi0State createState() => _TestMentalDepresi0State();
}

class _TestMentalDepresi0State extends State<TestMentalDepresi0> {

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  List<String> _jawab = [];
  List<String> _soal = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      for (var i = 0; i < 10; i++) {
        _jawab.add("X");
        _soal.add("X");
      }
      _soal[1] = "Kurang tertarik atau bergairah dalam melakukan apapun";
      _soal[2] = "Merasa murung, muram, atau putus asa";
      _soal[3] = "Sulit tidur atau mudah terbangun, atau terlalu banyak tidur";
      _soal[4] = "Merasa lelah atau kurang bertenaga";
      _soal[5] = "Kurang nafsu makan atau terlalu banyak makan";
      _soal[6] = "Kurang percaya diri - atau merasa bahwa Anda adalah orang yang gagal atau telah mengecewakan diri sendiri atau keluarga";
      _soal[7] = "Sulit berkonsentrasi pada sesuatu, misalnya membaca koran atau menonton televisi";
      _soal[8] = "Bergerak atau berbicara sangat lambat sehingga orang lain memperhatikannya. Atau sebaliknya - merasa resah atau gelisah sehingga Anda lebih sering bergerak dari biasanya";
      _soal[9] = "Merasa lebih baik mati atau ingin melukai diri sendiri dengan cara apapun";
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
      appBar: AppBar(title: Text('Tes Depresi'), backgroundColor: Colors.teal,),
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
                      TextSpan( text: "Tes Depresi adalah "),
                      TextSpan( text: " PHQ-9 ", style: TextStyle(color: Colors.teal,), ),
                    ],
                  ),
                ),
                SizedBox(height: 10,),
                Padding(
                  padding: EdgeInsets.fromLTRB(40, 10, 40,10),
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

                for (var x = 1; x < 10; x++)
                  Padding(
                      padding: EdgeInsets.only(top: 30),
                      child: CustomCardTest001("0" + x.toString(), _soal[x], _jawab[x],
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
    for (var i = 1; i < 10; i++) {
      if( _jawab[i] == "X"){
        myDialog00().snackBar003(context, "Harap jawab semua pertanyaan");
        err = 1;
        i=10;
      }
      else if( _jawab[i] == "A"){ nilai += 0; }
      else if( _jawab[i] == "B"){ nilai += 1; }
      else if( _jawab[i] == "C"){ nilai += 2; }
      else if( _jawab[i] == "D"){ nilai += 3; }
    }

    if(err == 0){
      String _jawab0 = _jawab.join('|');

      setUserPrefs(nilai.toString(), _jawab0);
      //Navigator.pushReplacement(context, SlideRightRoute(page: TestMentalDepresiResult0()));

      Navigator.pushReplacement(context, SlideRightRoute(page: LoaderCalc0()));
    }
  }

  Future setUserPrefs(String nilai0, String _jawab0) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("sf_nilai_test_depresi", nilai0);
    prefs.setString("sf_loader_calc_to", "TestMentalDepresiResult0");
    prefs.setString("sf_jawab_test_depresi", _jawab0);
  }

}



class CustomPilih001 extends StatelessWidget{

  String text01;
  bool isOn;
  Function()? onTap0;

  CustomPilih001(this.text01, this.isOn, this.onTap0);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
        shape: RoundedRectangleBorder(  borderRadius: BorderRadius.circular(10),  ),
        color: isOn ? Colors.red : AppConfig().biru01 ,
        elevation: 2,
        child: InkWell(
          onTap: onTap0,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: MediaQuery.of(context).size.width - 10,
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Text(text01, style: TextStyle(color: Colors.white, fontSize: 12 )),
          ),
        )
    );
  }
}

class CustomCardTest001 extends StatelessWidget{

  String text01;
  String text02;
  String pilih;

  Function()? onTap1;
  Function()? onTap2;
  Function()? onTap3;
  Function()? onTap4;

  CustomCardTest001(this.text01, this.text02, this.pilih, this.onTap1, this.onTap2, this.onTap3, this.onTap4);

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
              Text("dari 09", style: TextStyle(color: Colors.grey, fontSize: 18,)),
            ],
          ),
          Text(text02,
              style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold)),
          SizedBox(height: 30,),

          CustomPilih001("Tidak pernah", pilih=="A" ? true : false, onTap1 ),
          CustomPilih001("Beberapa hari", pilih=="B" ? true : false, onTap2 ),
          CustomPilih001("Lebih dari separuh waktu yang dimaksud", pilih=="C" ? true : false, onTap3 ),
          CustomPilih001("Hampir setiap hari", pilih=="D" ? true : false, onTap4 ),
        ],
      ),
    );
  }
}
