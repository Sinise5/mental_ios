import 'package:flutter/material.dart';

import 'test_mental.dart';
import 'jurnal_mental_rasa.dart';
import 'jurnal_mental_sayang.dart';
import '../slide_anim.dart';
import 'safety_plan.dart';

class JurnalMental0 extends StatefulWidget {
  @override
  _JurnalMental0State createState() => _JurnalMental0State();
}

class _JurnalMental0State extends State<JurnalMental0> {
  @override
  Widget build(BuildContext context) {


    Widget w_JurnalRasaButton = CustomButtonDark001("Jurnal Perasaan", () {
      Navigator.push(context, SlideRightRoute(page: JurnalMentalRasa0()));
    });

    Widget w_JurnalSayangButton = CustomButtonDark001("Jurnal Menyayangi Diri", () {
      Navigator.push(context, SlideRightRoute(page: JurnalMentalSayang0()));
    });

    Widget w_RencanaKeamananButton = CustomButtonDark001("Rencana Keamanan / Safety Plan", () {
      Navigator.push(context, SlideRightRoute(page: SafetyPlan0()));
    });

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(title: Text('Jurnal Kesehatan Mental'), backgroundColor: Colors.teal,),
        body: ListView(
          children: [
            Padding(
                padding: EdgeInsets.fromLTRB(30, 10, 30,10),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 50),
                      child: Image.asset(
                        "assets/images/jurnal_mental.png",
                        fit: BoxFit.fitWidth,
                        //width: MediaQuery.of(context).size.width - 80 ,
                        alignment: Alignment.topCenter,
                      ),
                    ),

                    Text("Jurnal Kesehatan Mental dapat diisi secara berkala, baik saat senang maupun sedih, dan dapat dibaca kembali.",
                        style: TextStyle(color: Colors.black, fontSize: 14, ),
                        textAlign: TextAlign.center),
                    Text("Dibuat berdasarkan metode terapi kognitif-perilaku berbasis bukti.",
                        style: TextStyle(color: Colors.teal, fontSize: 14, fontWeight: FontWeight.bold ),
                        textAlign: TextAlign.center),

                    SizedBox(height: 50,),
                    w_JurnalRasaButton,
                    SizedBox(height: 18),
                    w_JurnalSayangButton,
                    SizedBox(height: 18),
                    w_RencanaKeamananButton,
                    SizedBox(height: 20),
                  ],
                )
            ),

          ],
        )
    );

  }
}
