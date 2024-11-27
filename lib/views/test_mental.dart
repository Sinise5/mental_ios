import 'package:flutter/material.dart';

import '../slide_anim.dart';
import 'test_mental_depresi.dart';
import 'test_mental_cemas.dart';
import 'test_mental_riskbundiri.dart';

class TestMental0 extends StatefulWidget {
  @override
  _TestMental0State createState() => _TestMental0State();
}

class _TestMental0State extends State<TestMental0> {
  @override
  Widget build(BuildContext context) {


    Widget w_TesDepresiButton = CustomButtonDark001("Mulai Tes Depresi", () {
      Navigator.push(context, SlideRightRoute(page: TestMentalDepresi0()));
    });

    Widget w_TesCemasButton = CustomButtonDark001("Mulai Tes Kecemasan", () {
      Navigator.push(context, SlideRightRoute(page: TestMentalCemas0()));
    });

    Widget w_TesRiskBunuhDiri = CustomButtonDark001("Mulai Penilaian Risiko Bunuh Diri", () {
      Navigator.push(context, SlideRightRoute(page: TestMentalRBunDiri0()));
    });


    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(title: Text('Tes Kesehatan Mental'), backgroundColor: Colors.teal,),
        body: ListView(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(30, 10, 30,10),
              child: Column(
                children: [
                  SizedBox(height: 10,),
                  Image.asset(
                    "assets/images/onboard_01.png",
                    fit: BoxFit.fitWidth,
                    //width: MediaQuery.of(context).size.width - 80 ,
                    alignment: Alignment.topCenter,
                  ),
                  Text("Peringatan Sebelum Menggunakan",
                      style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold ),
                      textAlign: TextAlign.center),
                  Text("Tes Kesehatan Mental",
                      style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold ),
                      textAlign: TextAlign.center),
                  SizedBox(height: 50,),
                  Text("Tes Kesehatan Mental berupa Tes Depresi",
                      style: TextStyle(color: Colors.black, fontSize: 14, ),
                      textAlign: TextAlign.center),
                  Text("dan Tes Kecemasan. Kedua tes skrining ini",
                      style: TextStyle(color: Colors.black, fontSize: 14, ),
                      textAlign: TextAlign.center),
                  Text("tidak diperuntukan untuk diagnosis.",
                      style: TextStyle(color: Colors.teal, fontSize: 14, fontWeight: FontWeight.bold ),
                      textAlign: TextAlign.center),
                  SizedBox(height: 50,),
                  w_TesDepresiButton,
                  SizedBox(height: 18,),
                  w_TesCemasButton,
                  SizedBox(height: 18,),
                  w_TesRiskBunuhDiri,
                  SizedBox(height: 20),
                ],
              )
              ),

          ],
        )
    );
  }
}

class CustomButtonDark001 extends StatelessWidget{
  String text01;
  Function()? onTap0;

  CustomButtonDark001(this.text01, this.onTap0);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ElevatedButton(
      onPressed: onTap0,
      child: Text(text01,  style: TextStyle(fontSize: 14)),
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
  }

}

class CustomButtonDark002 extends StatelessWidget{
  String text01;
  Function()? onTap0;

  CustomButtonDark002(this.text01, this.onTap0);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ElevatedButton(
      onPressed: onTap0,
      child: Text(text01,  style: TextStyle(fontSize: 14)),
      style: ButtonStyle(
        padding: MaterialStateProperty.all(const EdgeInsets.all(16)),
        fixedSize: MaterialStateProperty.all(const Size(300, 50)),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
                side: BorderSide(color: Colors.black)
            )
        ),
      ),
    );
  }

}

class CustomButtonDark00000 extends StatelessWidget{
  String text01;
  Function()? onTap0;
  Color colorBack;
  Color colorTxt;

  CustomButtonDark00000(this.text01, this.onTap0, this.colorBack, this.colorTxt);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ElevatedButton(
      onPressed: onTap0,
      child: Text(text01,  style: TextStyle(fontSize: 14)),
      style: ButtonStyle(
        padding: MaterialStateProperty.all(const EdgeInsets.all(16)),
        fixedSize: MaterialStateProperty.all(const Size(300, 50)),
        foregroundColor: MaterialStateProperty.all<Color>(colorTxt),
        backgroundColor: MaterialStateProperty.all<Color>(colorBack),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
                side: BorderSide(color: colorBack)
            )
        ),
      ),
    );
  }

}