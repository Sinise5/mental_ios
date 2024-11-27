import 'package:flutter/material.dart';

import '../slide_anim.dart';
import 'jurnal_konsul_1.dart';
import 'test_mental.dart';

class JurnalKonsul0 extends StatefulWidget {
  @override
  _JurnalKonsul0State createState() => _JurnalKonsul0State();
}

class _JurnalKonsul0State extends State<JurnalKonsul0> {
  @override
  Widget build(BuildContext context) {

    Widget w_JurnalKonsulButton = CustomButtonDark001("Mulai Jurnal Konsultasi", () {
      Navigator.push(context, SlideRightRoute(page: JurnalKonsul_1()));
    });

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(title: Text('Jurnal Konsultasi'), backgroundColor: Colors.teal,),
        body: ListView(
          children: [
            Padding(
                padding: EdgeInsets.fromLTRB(30, 10, 30,10),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 50),
                      child: Image.asset(
                        "assets/images/onboard_02.png",
                        fit: BoxFit.fitWidth,
                        //width: MediaQuery.of(context).size.width - 80 ,
                        alignment: Alignment.topCenter,
                      ),
                    ),

                    Text("Jurnal Konsultasi adalah jurnal untuk membantu proses konsultasimu dengan terapis.",
                        style: TextStyle(color: Colors.black, fontSize: 14, ),
                        textAlign: TextAlign.center),
                    Text("Dapat diisi sendiri dengan bimbingan terapismu.",
                        style: TextStyle(color: Colors.teal, fontSize: 14, fontWeight: FontWeight.bold ),
                        textAlign: TextAlign.center),

                    SizedBox(height: 50,),
                    w_JurnalKonsulButton,

                  ],
                )
            ),

          ],
        )
    );

  }
}
