import 'package:flutter/material.dart';

import 'teknik_relaks_1.dart';
import '../slide_anim.dart';
import 'teknik_relaks_wv.dart';
import 'test_mental.dart';

class TeknikRelaks0 extends StatefulWidget {
  @override
  _TeknikRelaks0State createState() => _TeknikRelaks0State();
}

class _TeknikRelaks0State extends State<TeknikRelaks0> {
  @override
  Widget build(BuildContext context) {

    Widget w_MulaiButton = CustomButtonDark001("Mulai Teknik Relaksasi", () {
      Navigator.push(context, SlideRightRoute(page: TeknikRelaks01()));
    });

    Widget w_videoButton = CustomButtonDark001("Video Teknik Relaksasi", () {
      Navigator.push(context, SlideRightRoute(page: TeknikRelaksasi_WV0()));
    });


    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(title: Text('Teknik Relaksasi'), backgroundColor: Colors.teal,),
        body: ListView(
          children: [
            Padding(
                padding: EdgeInsets.fromLTRB(30, 10, 30,10),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 30),
                      child: Image.asset(
                        "assets/images/onboard_03.png",
                        fit: BoxFit.fitWidth,
                        //width: MediaQuery.of(context).size.width - 80 ,
                        alignment: Alignment.topCenter,
                      ),
                    ),

                    Text("Box Breathing",
                        style: TextStyle(color: Colors.teal, fontSize: 36, fontWeight: FontWeight.bold ),
                        textAlign: TextAlign.center),
                    SizedBox(height: 20,),
                    Text("Teknik relaksasi ini dapat dilakukan dimana saja dengan mengatur pernapasan.",
                        style: TextStyle(color: Colors.black, fontSize: 12, ),
                        textAlign: TextAlign.center),

                    SizedBox(height: 50,),
                    w_MulaiButton,
                    SizedBox(height: 16),
                    w_videoButton
                  ],
                )
            ),

          ],
        )
    );

  }
}
