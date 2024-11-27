import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../_kosongan.dart';
import '../konfig000.dart';
import '../slide_anim.dart';
import 'home.dart';
import 'kontak_darurat.dart';
import 'notif.dart';
import 'profil.dart';
import 'seting.dart';

class HomePage0 extends StatefulWidget {
  @override
  _HomePage0State createState() => _HomePage0State();
}

class _HomePage0State extends State<HomePage0> {

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final PageController _pageController = PageController();
  //List<Widget> _screen = [ Home0(), Profil0(), Tanya0(), Notif0(), Seting0() ];
  String idf_user="";
  final List<Widget> _screen = [
    Home0(),
    Profil0(),
    Notif0(),
    Seting0(),
    View00000()
  ]; //KontakBantuan_WV0()
  int _selectedIndex = 0;

  String s_jum_chatNoRead = "0";


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getUserPrefs();
  }

  @override
  Widget build(BuildContext context) {

    Widget icon_Badge01 = Stack(
      children: <Widget>[
        const Icon(Icons.notifications, size: 35),
        Positioned(
          right: 0,
          child: Container(
            padding: EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(width: 1, color: Colors.white)
            ),
            constraints: const BoxConstraints(
              minWidth: 18,
              minHeight: 18,
            ),
            child: Text(
              s_jum_chatNoRead,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12, //8,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        )
      ],
    );

    Widget nav_Bawah = Align(
        alignment: Alignment.bottomCenter,
        child: Theme(
            data: Theme.of(context)
                .copyWith(canvasColor: Colors.transparent),
            child: Container(
                color: Colors.white,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    BottomNavigationBar(
                        currentIndex: _selectedIndex,
                        selectedFontSize: 11,
                        unselectedFontSize: 10,
                        type: BottomNavigationBarType.fixed,
                        backgroundColor: Colors.white,
                        selectedItemColor: Colors.teal,
                        unselectedItemColor: Colors.grey,
                        onTap: (index){
                          debugPrint("index : $index");

                          //if(index==20) {  /*Navigator.push(context, SlideRightRoute(page: Chat0())); */ }
                          if(index==4) { Navigator.push(context, SlideRightRoute(page: const KontakDarurat0())); }
                          else {
                            //if(idf_user!=""){ ambilDataJumUnreadChat(); }
                            _pageController.animateToPage(index, duration: const Duration(milliseconds: 250), curve: Curves.easeOut); // pake ni keyboard muncul trus ??
                            //_pageController.jumpToPage(index);
                          }

                        },
                        items: [
                          const BottomNavigationBarItem(
                              icon: Icon(Icons.home, size: 35),
                              label: "home"
                          ),
                          const BottomNavigationBarItem(
                              icon: Icon(Icons.person, size: 35),
                              label: "profil"
                          ),
                          /*
                          BottomNavigationBarItem(
                              icon: Icon(Icons.help_outline, size: 35),
                              label: "pertanyaan"
                          ),
                          */
                          BottomNavigationBarItem(
                              icon: s_jum_chatNoRead == "0"
                                  ? const Icon(Icons.notifications, size: 35)
                                  : icon_Badge01,
                              label: "notifikasi"
                          ),
                          const BottomNavigationBarItem(
                              icon: Icon(Icons.settings, size: 35),
                              label: "seting"
                          ),
                          const BottomNavigationBarItem(
                              icon: Icon(Icons.perm_phone_msg, size: 35, color: Colors.red,),
                              label: "Kontak"
                          ),
                        ]
                    ),
                    /*
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Text("copyrights Balai Besar Serayu Opak 2021", style: TextStyle(color: Colors.grey, fontSize: 14, fontStyle: FontStyle.italic  )),
                    ),
                     */
                  ],
                )
            )

        )
    );

    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: <Widget>[
          PageView(
            controller: _pageController,
            children: _screen,
            onPageChanged: _onPageChanged,
            physics: const NeverScrollableScrollPhysics(),
          ),
          nav_Bawah,

          /*
          popup00(pop00CekPinVisible),
          w_cekpin,

          popup00(pop00CekPinLoaderVisible),
          popup01_loader(pop00CekPinLoaderVisible, "Saving PIN, please wait ..."),

          popup00(pop00MobPopupNotifVis),
          w_mobPopNotif,

          popup00(pop00CekMobUpdVisible),
          w_mobUpd2
          */
        ],
      ),

    );

  }

  void _onPageChanged(int index){
    setState(() {
      _selectedIndex = index;
    });
    debugPrint("_selectedIndex : $_selectedIndex" );

    if( idf_user != '' && (_selectedIndex==1 || _selectedIndex==2)){
      ambilDataUser0();
    }
  }

  getUserPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    var a = prefs.getString("idf_user") ?? "";
    var b = prefs.getString("sf_editProfilFromHome") ?? "0";

    getUserPrefs_1(a, b);
  }

  getUserPrefs_1(idf_user0, sf_editProfilFromHome) {
      setState(() {
        idf_user = idf_user0;
      });
      if(sf_editProfilFromHome == "1"){
        _pageController.animateToPage(1, duration: Duration(milliseconds: 250), curve: Curves.easeOut);
      }
      ambilDataUser0();
  }


  Future ambilDataUser0() async{

    String sBar = "";
    final String url00 = AppConfig().url_API + "mob-data-user-home0";
    debugPrint(url00 + " --> " + idf_user );
    try {
      final response = await http.post(Uri.parse(url00), body: {
        'idf_user' : idf_user ,
      });

      if(response.statusCode == 200){
        final String responseString = response.body;
        var err_code0 = jsonDecode(responseString)["err_code"];
        debugPrint(responseString + " errcode : $err_code0");

        if(err_code0==0){
          //debugPrint("masuuuk");
          setState(() {

            //akunSaya_vis = true;
            s_jum_chatNoRead = jsonDecode(responseString)["data"][0]["jum_notif"];

          });
        }
        else if(err_code0==1) { sBar = "Data Not found!"; }
      }
      else {
        int a=response.statusCode; debugPrint("xxxx $a ");
        sBar = "No Connection!";
      }

    } catch (e) {
      String cek = "xxx.. $e"; // biar jadi string exceptionnya
      debugPrint(cek);

      if(cek.indexOf('unreachable') > -1){ sBar = "No Internet Connection!"; }
      else { sBar = "Cannot Connect to Server!";   }
    }

    //if(sBar != ""){ myDialog00().snackBar002(_scaffoldKey, sBar); }

  }


}


