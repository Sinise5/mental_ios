import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'myFunc.dart';

class CustomNoInternet00 extends StatelessWidget{

  bool visible0;
  String text0;
  IconData icon0;

  CustomNoInternet00(this.visible0, this.text0, this.icon0);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Visibility(
        visible: visible0,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Container(
            child: Center(
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 75.0,),
                    Icon(icon0, size: 122.0, color: Colors.grey),
                    SizedBox(height: 10.0,),
                    Text(text0, textAlign: TextAlign.center, style: TextStyle(color: Colors.grey),)
                  ],
                )
            ),
            //height: MediaQuery.of(context).size.height - AppBar().preferredSize.height - 100,
          ),)
    );
  }

}

class CustomLoader00 extends StatelessWidget{

  bool visible0;

  CustomLoader00(this.visible0);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Visibility(
      visible: visible0,
      child: Center(
          child: Container(
            padding: EdgeInsets.only(top: 16.0, bottom: 150.0),
            child: CircularProgressIndicator(),
          )
      ),
    );
  }

}

class CustomText0 extends StatelessWidget{

  String text01;
  String text02;

  CustomText0(this.text01, this.text02);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(text01),
        Text(text02),
      ],
    );

  }

}

class CustomText02 extends StatelessWidget{

  String text01;
  String text02;
  double wid;

  CustomText02(this.text01, this.wid, this.text02);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: wid,
          child: Text(text01, style: TextStyle(color: Colors.grey, )),
        ),
        Text(" : ", style: TextStyle(color: Colors.grey, )),
        Expanded(child: Text(text02, style: TextStyle(color: Colors.black, )))
      ],
    );

  }

}


class CustomBuyBawah0 extends StatelessWidget{

  String text01;
  bool goProsesBtn;
  Function onTap0;

  CustomBuyBawah0(this.text01, this.goProsesBtn, this.onTap0);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
            width: MediaQuery.of(context).size.width,
            height: 75,
            padding: EdgeInsets.all(16),
            color: Colors.grey[100],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Total Harga"),
                    Text("Rp " + MyFunct00().formatRibu(text01), style: TextStyle(color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold),),
                  ],
                ),

                ElevatedButton(
                  child: Text('PROSES', style: TextStyle(color: Colors.white)),
                  onPressed: () => onTap0,
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(const EdgeInsets.all(10)),
                    fixedSize: MaterialStateProperty.all(const Size(300, 40)),
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    backgroundColor: MaterialStateProperty.all<Color>(goProsesBtn ? Colors.red : Colors.grey),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: goProsesBtn ? Colors.red : Colors.grey)
                        )
                    ),

                  ),
                ),
                /*
                FlatButton(
                  color: goProsesBtn ? Colors.red : Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text('PROSES', style: TextStyle(color: Colors.white)),
                  onPressed: () => onTap0,
                ), */

              ],
            )
        )
    );

  }

}

class CustomNoData01 extends StatelessWidget{

  bool visible0;
  String text0;
  String imgTxt;

  CustomNoData01(this.visible0, this.text0, this.imgTxt);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Visibility(
        visible: visible0,
        child: Padding(
            padding: EdgeInsets.all(20),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(imgTxt, width: 250.0, height: 250.0 ),
                  Text(text0, style: TextStyle(color: Colors.green), textAlign: TextAlign.center),
                  //Text("Kota Cilegon", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 26)),
                  SizedBox(height: 10),
                ],
              ),
            )
        )
    );

  }

}

class UnorderedList extends StatelessWidget {
  UnorderedList(this.texts);
  final List<String> texts;

  @override
  Widget build(BuildContext context) {
    var widgetList = <Widget>[];
    for (var text in texts) {
      // Add list item
      widgetList.add(UnorderedListItem(text));
      // Add space between items
      widgetList.add(SizedBox(height: 5.0));
    }

    return Column(children: widgetList);
  }
}

class UnorderedListItem extends StatelessWidget {
  UnorderedListItem(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        //Text("•   "),
        Icon(Icons.check_circle_outline, size: 15),
        SizedBox(width: 15),
        Expanded(
          child: Text(text),
        ),
      ],
    );
  }
}

class OrderedList extends StatelessWidget {
  OrderedList(this.texts);
  final List<String> texts;

  @override
  Widget build(BuildContext context) {
    var widgetList = <Widget>[];
    int i=0;
    for (var text in texts) { i++;
      // Add list item
      widgetList.add(OrderedListItem(i.toString(), text));
      // Add space between items
      widgetList.add(SizedBox(height: 5.0));
    }

    return Column(children: widgetList);
  }
}

class OrderedListItem extends StatelessWidget {

  final String num;
  final String text;

  OrderedListItem(this.num, this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(num),
        SizedBox(width: 15),
        Expanded(
          child: Text(text),
        ),
      ],
    );
  }
}