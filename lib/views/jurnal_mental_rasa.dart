import 'package:flutter/material.dart';

import '../konfig000.dart';
import '../slide_anim.dart';
import 'jurnal_mental_rasa_wv.dart';

class JurnalMentalRasa0 extends StatefulWidget {
  @override
  _JurnalMentalRasa0State createState() => _JurnalMentalRasa0State();
}

class _JurnalMentalRasa0State extends State<JurnalMentalRasa0> {


  List<String> _langkah = [];
  int _langkahke = 0;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _langkah.add("Selamat datang di Jurnal Perasaan. Tuangkan apa yang sedang kamu pikir dan rasa. ");
      _langkah.add("Jurnal ini dapat membantumu memantau perasaan hingga merasa lebih nyaman");
      _langkah.add("Disini adalah tempat amanmu. Tidak ada jawaban yang salah, dan jawabanmu tidak harus Lengkap atau sempurna.");
    });
  }

  @override
  Widget build(BuildContext context) {

    Widget w_judul = Padding(
        padding: EdgeInsets.fromLTRB(20, 50, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              child: Icon( Icons.arrow_back_ios, color: Colors.white, size: 20, ),
              onTap: (){ Navigator.of(context).pop(); },
            ),
            SizedBox(height: 20,),
            Text('Jurnal Perasaan', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold ),),
          ],
        )
    );

    Widget w_atas = Align(
        alignment: Alignment.topCenter,
        child: Padding(
            padding: EdgeInsets.only(top: 150),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container( width: 80, height: 5, color: Colors.white,),
                SizedBox(width:20),
                Container( width: 80, height: 5, color: _langkahke == 0 ? Colors.grey[500] : Colors.white,),
                SizedBox(width:20),
                Container( width: 80, height: 5, color: _langkahke == 2 ? Colors.white : Colors.grey[500],),
              ],
            )
        )
    );

    Widget w_PrevButton = GestureDetector(
      child: CircleAvatar(
        radius: 20,
        backgroundColor: _langkahke == 0 ? Colors.grey.shade600 : Colors.white,
        child: Padding(
          padding: EdgeInsets.fromLTRB(5,0,0,0),
          child: Icon( Icons.arrow_back_ios, color: Colors.teal.shade300, size: 22, ),
        )
      ),
      onTap: (){
        _langkahke == 0 ? null :  setState(() {  _langkahke--; });
      }
    );

    Widget w_NextButton = GestureDetector(
        child: CircleAvatar(
            radius: 20,
            backgroundColor: Colors.white,
            child: Padding(
              padding: EdgeInsets.fromLTRB(5,0,0,0),
              child: Icon( Icons.arrow_forward_ios, color: Colors.teal.shade300, size: 22, ),
            )
        ),
        onTap: (){
          _langkahke < 2
              ? setState(() {  _langkahke++; })
              : Navigator.push(context, SlideRightRoute(page: JurnalMentalRasa_WV0()));
        }
    );

    Widget w_bawah2 = Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
            padding: EdgeInsets.only(bottom: 100),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                w_PrevButton,
                SizedBox(width:50),
                w_NextButton
              ],
            )
        )
    );


    return Scaffold(
      backgroundColor: Colors.teal.shade300,
      body: Stack(
        children: [
          w_judul,
          w_atas,
          Center(
              child: Padding(
                padding: EdgeInsets.only(left: 55, right: 55),
                child: Text(_langkah[_langkahke],
                    style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic ),
                    textAlign: TextAlign.center),
              )
          ),
          w_bawah2

        ],
      ),
    );
  }
}
