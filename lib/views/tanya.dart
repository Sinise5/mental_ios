import 'package:flutter/material.dart';

class Tanya0 extends StatefulWidget {
  @override
  _Tanya0State createState() => _Tanya0State();
}

class _Tanya0State extends State<Tanya0> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          SizedBox(height: 10),
          Text("Pertanyaan Mingguan", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), ),

          SizedBox(height: 30),
          CustomCardTanya001("1", "Lorem ipsum dolor jshduh shjhf jdhfjdhfj jdhfjdhfj jhsfjhj jhjdhjf jhfjhgfj ?", (){}),

          SizedBox(height: 20),
          CustomCardTanya002("2", (){}),

          SizedBox(height: 20),
          CustomCardTanya002("3", (){}),

          SizedBox(height: 20),
          CustomCardTanya002("4", (){}),

          SizedBox(height: 150),
        ],
      ),
    );
  }
}

class CustomCardTanya001 extends StatelessWidget{
  String text01;
  String text02;
  Function()? onTap0;

  CustomCardTanya001(this.text01, this.text02, this.onTap0);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
      child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          color: Colors.teal,
          elevation: 2,
          child: InkWell(
            onTap: onTap0,
            borderRadius: BorderRadius.circular(15.0),
            child: Container(
                padding: EdgeInsets.only(top: 20, bottom: 20),
                width: MediaQuery.of(context).size.width*0.5 - 16 ,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(width: 16),
                    Container(
                      width: 55,
                      height: 55,
                      padding: EdgeInsets.all(7),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(35.0),
                          border: Border.all(color: Colors.white, width: 3)
                      ),
                      child: Column(
                        children: [
                          Text("Minggu", style: TextStyle(color: Colors.white, fontSize: 9 )),
                          Text(text01, style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold )),
                        ],
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      //color: Colors.blueAccent,
                        constraints: BoxConstraints(  //pake constraint biar ga overflow
                            minWidth: MediaQuery.of(context).size.width - 142 ,
                            maxWidth: MediaQuery.of(context).size.width - 142 ,
                            minHeight: 30, maxHeight: 400),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(text02, style: TextStyle(color: Colors.white, fontSize: 14 ))
                          ],
                        )
                    ),
                    Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
                    SizedBox(width: 8),

                  ],
                )
            ),
          )
      ),
    );

  }

}

class CustomCardTanya002 extends StatelessWidget{
  String text01;
  Function()? onTap0;

  CustomCardTanya002(this.text01, this.onTap0);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
      child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          color: Colors.teal.shade100,
          elevation: 1,
          child: InkWell(
            onTap: onTap0,
            borderRadius: BorderRadius.circular(15.0),
            child: Container(
                padding: EdgeInsets.only(top: 20, bottom: 20),
                width: MediaQuery.of(context).size.width*0.5 - 16 ,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(width: 16),
                    Container(
                      width: 55,
                      height: 55,
                      padding: EdgeInsets.all(7),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(35.0),
                          border: Border.all(color: Colors.teal.shade200, width: 3)
                      ),
                      child: Column(
                        children: [
                          Text("Minggu", style: TextStyle(color: Colors.teal.shade200, fontSize: 9 )),
                          Text(text01, style: TextStyle(color: Colors.teal.shade200, fontSize: 20, fontWeight: FontWeight.bold )),
                        ],
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      //color: Colors.blueAccent,
                        constraints: BoxConstraints(  //pake constraint biar ga overflow
                            minWidth: MediaQuery.of(context).size.width - 142 ,
                            maxWidth: MediaQuery.of(context).size.width - 142 ,
                            minHeight: 30, maxHeight: 400),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.lock, color: Colors.teal, size: 35),
                          ],
                        )
                    ),
                    Icon(Icons.arrow_forward_ios, color: Colors.teal.shade200, size: 16),
                    SizedBox(width: 8),
                  ],
                )
            ),
          )
      ),
    );

  }

}
