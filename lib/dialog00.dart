import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'views/login.dart';

class myDialog00 {

  void openDialog00(BuildContext context, String txt) {

    Widget w_Button = ElevatedButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: const Text(" OK ",  style: TextStyle(fontSize: 18)),
      style: ButtonStyle(
        padding: MaterialStateProperty.all(const EdgeInsets.all(10)),
        fixedSize: MaterialStateProperty.all(const Size(100, 40)),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
                side: BorderSide(color: Colors.blue)
            )
        ),
      ),
    );

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(Icons.cancel, color: Colors.redAccent, size: 64.00,),
              SizedBox(height: 16.0),
              Text(txt),
              SizedBox(height: 16.0),
              w_Button
              /*
              FlatButton(
                color: Colors.blue,
                textColor: Colors.white,
                padding: EdgeInsets.all(3.0),
                splashColor: Colors.blueAccent,
                child: Text("OK"),
                onPressed: () { Navigator.pop(context); },
              ) */
            ],
          ),
        );
      },
    );
  }


  _confirmResult0(BuildContext context, bool isYes, String untuk){
    if(!isYes){ Navigator.of(context).pop(); }
    else {
      if(untuk == "logot") {
        setUserPrefs000();
        //Navigator.of(context).pushReplacement(MaterialPageRoute( builder: (context) => LoginPage() ));
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
            Login0()), (Route<dynamic> route) => false);
      }
    }
  }

  confirm0(BuildContext context, String judul, String isi, String untuk) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(judul),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(isi)
                ],
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  _confirmResult0(context, false , untuk);
                },
                child: const Text(" Cancel ",  style: TextStyle(fontSize: 18)),
              ),
              ElevatedButton(
                onPressed: () {
                  _confirmResult0(context, true , untuk);
                },
                child: const Text(" OK ",  style: TextStyle(fontSize: 18)),
              ),

              /*
              FlatButton(
                child: Text('Cancel'),
                onPressed: () => _confirmResult0(context, false , untuk),
              ),
              FlatButton(
                child: Text('OK'),
                onPressed: () => _confirmResult0(context, true , untuk),
              ), */

            ],
          );
        }
    );
  }

  Future setUserPrefs000() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();

    /*
    final DbHelper _helper = new DbHelper();
    _helper.deleteDataAll(User_Login_Query.TABLE_NAME).then((value) {
      if (value > 0) {
        print("isi tab dihapus ");
      }
    });
     */
    //prefs.setString("pass_x", "");
  }

  alert0(BuildContext context, String judul, String isi) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(judul),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(isi)
                ],
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(" OK ",  style: TextStyle(fontSize: 18)),
              ),
              /*
              FlatButton(
                child: Text('OK'),
                onPressed: () => Navigator.of(context).pop(),
              ), */
            ],
          );
        }
    );
  }

  alert01(BuildContext context, String judul, String isi, Function onTap) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(judul),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(isi)
                ],
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () => onTap,
                child: const Text(" OK ",  style: TextStyle(fontSize: 18)),
              ),
              /*
              FlatButton(
                child: Text('OK'),
                onPressed: () => onTap,
              ), */
            ],
          );
        }
    );
  }

  alert02(BuildContext context, String judul, String isi, String BtnCancel, String Btn01, Function onTap) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(judul),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(isi)
                ],
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                child: Text(BtnCancel),
                onPressed: () => Navigator.of(context).pop(),
              ),
              ElevatedButton(
                child: Text(Btn01),
                onPressed: () => onTap,
              ),
              /*
              FlatButton(
                child: Text(BtnCancel),
                onPressed: () => Navigator.of(context).pop(),
              ),
              FlatButton(
                child: Text(Btn01),
                onPressed: () => onTap,
              ), */
            ],
          );
        }
    );
  }

  /*
  snackBar0(BuildContext context, String txt) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(txt),
        backgroundColor: Colors.redAccent,
        //action: SnackBarAction( label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  snackBar002(GlobalKey<ScaffoldState> scaffoldKey, String txt) {
    final snackBar = SnackBar(
        content: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(16),
                color: Colors.red,
                child: Text(txt),
              ),
              SizedBox(height: 50,)
            ],
          ) ,
        ),
        backgroundColor: Colors.white.withOpacity(0).withAlpha(0));
    scaffoldKey.currentState!.showSnackBar(snackBar);
  }
   */

  snackBar003(BuildContext context, String txt) {
    final snackBar2 = SnackBar(
      content: Text(txt),
    );

    final snackBar = SnackBar(
        content: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(16),
                color: Colors.red,
                child: Text(txt),
              ),
              SizedBox(height: 20,)
            ],
          ) ,
        ),
        backgroundColor: Colors.white.withOpacity(0).withAlpha(0));

    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  dialogDaerah0(BuildContext context, String judul, Widget list000, int jumlist, String selc_idf_induk, String err_induk) {
    debugPrint("$judul ... $selc_idf_induk ... $jumlist");
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.blue[100],
            contentPadding: EdgeInsets.all(0),
            titlePadding: EdgeInsets.all(16.0),
            title: Text(judul),
            content: SingleChildScrollView(
              child: Container(
                color: Colors.white,
                child: ListBody(
                  children: <Widget>[
                    list000,
                    Visibility(
                        visible: selc_idf_induk=="" ? true : false,
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(err_induk, style: TextStyle(color: Colors.red),),
                        )
                    ),
                    Visibility(
                        visible: selc_idf_induk=="" || (selc_idf_induk!="" && jumlist > 0) ? false : true,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: const <Widget>[
                            SizedBox(height: 5,),
                            SizedBox(
                              width: 50,
                              height: 50,
                              child: CircularProgressIndicator(),
                            ),
                            SizedBox(height: 5,)
                          ],
                        )
                    )
                  ],
                ),
              ),
            ),
          );
        }
    );
  }


}


class popup00 extends StatelessWidget{

  bool visible;

  popup00(this.visible);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Visibility(
      visible: visible,
      child: Opacity(
        opacity: 0.50,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black,
        ),
      ),
    );
  }

}

class popup01_loader extends StatelessWidget{

  bool visible;
  String text0;

  popup01_loader(this.visible, this.text0);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Visibility(
      visible: visible,
      child: Center(
        child: Container(
            decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: new BorderRadius.circular(15.0)
            ),
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    width: 50.0,
                    height: 50.0,
                    child: CircularProgressIndicator(),
                  ),
                  SizedBox(height: 30.0),
                  Text(text0)
                ],
              ),
            )
        ),
      ),
    );
  }

}