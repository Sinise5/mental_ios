import 'package:flutter/material.dart';

class TeknikRelaks01 extends StatefulWidget {
  @override
  _TeknikRelaks01State createState() => _TeknikRelaks01State();
}

class _TeknikRelaks01State extends State<TeknikRelaks01> {

  List<String> _langkah = [];
  int _langkahke = 0;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _langkah.add("Tarik napas \nmelalui hidung \ndalam 4 hitungan");
      _langkah.add("Tahan napas \ndalam 4 hitungan");
      _langkah.add("Buang napas \ndalam 4 hitungan");
      _langkah.add("Tahan napas \ndalam 4 hitungan");
    });
  }

  @override
  Widget build(BuildContext context) {

    Widget w_UlangiButton = ElevatedButton(
      onPressed: () {
        setState(() {
          _langkahke = 0;
        });
      },
      child: Text("Ulangi",  style: TextStyle(fontSize: 16)),
      style: ButtonStyle(
        padding: MaterialStateProperty.all(const EdgeInsets.all(10)),
        fixedSize: MaterialStateProperty.all(const Size(300, 40)),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        backgroundColor: MaterialStateProperty.all<Color>(Colors.teal),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
              side: BorderSide(color: Colors.white)
            )
        ),

      ),
    );

    Widget w_NextButton = CircleAvatar(
      radius: 20,
      backgroundColor: Colors.white,
      child: IconButton(
        icon: Icon(
          Icons.arrow_forward_ios,
          color: Colors.teal,
        ),
        onPressed: () {
          setState(() {
            _langkahke++;
          });
        },
      ),
    );

    Widget w_bawah2 = Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
            padding: EdgeInsets.only(bottom: 100),
            child: (_langkahke == 3) ? w_UlangiButton : w_NextButton
        )
    );

    return Scaffold(
      backgroundColor: Colors.teal.shade300,
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.only(left: 55, right: 55),
              child: Text(_langkah[_langkahke],
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold ),
                  textAlign: TextAlign.center),
            )
          ),
          w_bawah2

        ],
      ),
    );
  }
}
