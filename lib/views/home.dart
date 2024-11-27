import 'dart:convert';
import 'dart:typed_data';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'home000.dart';
import 'kontak_bantuan_wv.dart';
import 'peta_dokter.dart';
import 'teknik_relaks.dart';
import 'jurnal_konsul.dart';
import 'jurnal_mental.dart';
import 'test_mental.dart';
import 'blog_wv.dart';
import '../slide_anim.dart';
import '../konfig000.dart';
import '../dialog00.dart';


class Home0 extends StatefulWidget {
  @override
  _Home0State createState() => _Home0State();
}

class _Home0State extends State<Home0> {

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late GlobalKey<RefreshIndicatorState> refreshKey;
  String idf_user="";
  bool pop00Visible=false;

  int _current = 0;
  List<String> ls03_img_slider = [];
  List<String> ls03_jns_slider = [];
  List<String> ls03_blog_judul = [];
  List<String> ls03_blog_tgl = [];
  List<String> ls03_blog_url = [];

  String s_nama="", s_mob_img_profil="", s_mob_img_background="profil_bg.png";
  String s_quote_fav = "Tidak peduli sesedikit apapun, kemajuan adalah kemajuan";

  String sf_img_background="", sf_img_background_filename="";
  late Uint8List sf_img_background_bytesImage;

  String sf_img_profil="", sf_img_profil_filename="";
  late Uint8List sf_img_profil_bytesImage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refreshKey = GlobalKey<RefreshIndicatorState>();

    getUserPrefs();
    ambilDataCarousel();
  }

  @override
  Widget build(BuildContext context) {

    Widget w_Foto2 = Material(
      borderRadius: BorderRadius.all(Radius.circular(50)),
      elevation: 10,
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(50)),
          child: s_mob_img_profil==''
              ? Image.asset("assets/images/onboard_01.png", fit: BoxFit.cover, width: 80, height: 80,)
              : Image.network(AppConfig().url_APIRoot +"data/img-profil-member/"+s_mob_img_profil, fit: BoxFit.cover, width: 80, height: 80,) ,
        ),
      ),
    );

    Widget w_Foto_edit = GestureDetector(
      onTap: (){ fotoProfilClick(); },
      child: Container(
          height: 30,
          width: 30,
          padding: EdgeInsets.fromLTRB(1, 1, 1, 1),
          decoration: new BoxDecoration(
              color: AppConfig().biru01,
              borderRadius: new BorderRadius.circular(50),
              border: Border.all(color: Colors.white)
          ),
          child: Center(
            child: Icon(Icons.edit, color: Colors.white, size: 16),
          )
      ),
    );

    Widget w_Foto = Stack(
      //alignment: Alignment.center,
      children: [
        Material(
          borderRadius: BorderRadius.all(Radius.circular(50)),
          //elevation: 10,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(50)),
              child: sf_img_profil_filename == ''
                  ? Image.asset("assets/images/onboard_01.png", fit: BoxFit.cover, width: 80, height: 80,)
                  : Image.memory(sf_img_profil_bytesImage, fit: BoxFit.cover, width: 80, height: 80,),
                    //Image.network(AppConfig().url_APIRoot +"data/img-profil-member/"+s_mob_img_profil, fit: BoxFit.cover, width: 80, height: 80,) ,
            ),
          ),
        ),
        Positioned(
            top: 0, right: 0 ,
            child: w_Foto_edit
        )
      ],
    );


    Widget w_Head00XX = Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/profil_bg.png"),
          fit: BoxFit.cover,
        ),
      ),
      //color: Colors.green,
      child: Column(
        children: [
          SizedBox(height: 50),
          w_Foto,
          SizedBox(height: 10),
          RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: "Halo, ",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                TextSpan(
                  text: s_nama ,
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold,),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Container(
              constraints: BoxConstraints(  //pake constraint biar ga overflow
                  minWidth: MediaQuery.of(context).size.width - 170 ,
                  maxWidth: MediaQuery.of(context).size.width - 170 ,
                  minHeight: 30, maxHeight: 400),
              child: Text(s_quote_fav , style: TextStyle(fontSize: 14, color: Colors.white), textAlign: TextAlign.center,),
          ),
          SizedBox(height: 30),
        ],
      ),
    );

    Widget w_Head00 = Container(
      decoration: sf_img_background_filename == ""
        ? BoxDecoration(
            color: Colors.white,
          )
        : BoxDecoration(
            image: DecorationImage(
              image: Image.memory(sf_img_background_bytesImage).image, //base64_toImage(sf_img_background),
                  //NetworkImage(AppConfig().url_APIRoot +"data/img-profil-member/"+s_mob_img_background),
              fit: BoxFit.cover,
            ),
          ),
      //color: Colors.green,
      child: Column(
        children: [
          SizedBox(height: 50),
          w_Foto,
          SizedBox(height: 10),
          RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: "Halo, ",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                TextSpan(
                  text: s_nama ,
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold,),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Container(
            constraints: BoxConstraints(  //pake constraint biar ga overflow
                minWidth: MediaQuery.of(context).size.width - 170 ,
                maxWidth: MediaQuery.of(context).size.width - 170 ,
                minHeight: 30, maxHeight: 400),
            child: Text(s_quote_fav , style: TextStyle(fontSize: 14, color: Colors.white, fontStyle: FontStyle.italic), textAlign: TextAlign.center,),
          ),
          SizedBox(height: 30),
        ],
      ),
    );

    Widget w_MoodToday0 = Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
        child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(35.0),
            ),
            color: Colors.teal.shade50,
            elevation: 2,
            child: InkWell(
              onTap: (){},
              borderRadius: BorderRadius.circular(35.0),
              child: Container(
                  width: MediaQuery.of(context).size.width*0.5 - 16 ,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        height: 80,
                        width: 100,
                        padding: EdgeInsets.only(left: 7),
                        decoration: BoxDecoration(
                          color: Colors.teal.shade200,
                          borderRadius:BorderRadius.only(
                              topLeft:  Radius.circular(35),
                              bottomLeft: Radius.circular(35), ),
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: 10,),
                            Text("Mood hari ini", style: TextStyle(color: Colors.black, fontSize: 12, ),),
                            SizedBox(height: 1,),
                            Icon(Icons.emoji_emotions_outlined, color: Colors.black, size: 45),
                          ],
                        ),
                      ),
                      Container(
                        //color: Colors.blueAccent,
                          constraints: BoxConstraints(  //pake constraint biar ga overflow
                              minWidth: MediaQuery.of(context).size.width - 170 ,
                              maxWidth: MediaQuery.of(context).size.width - 170 ,
                              minHeight: 30, maxHeight: 400),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Pertanyaan Mingguan", style: TextStyle(color: Colors.black, fontSize: 14 )),
                              SizedBox(height: 5,),
                              Text("Lorem ipsum ajhdksjd skjdks ksjdk ksjdksj kjsdk kjd ksjdksj ksjdksjd", style: TextStyle(color: Colors.black, fontSize: 11 ))
                            ],
                          )
                      ),
                      Icon(Icons.arrow_forward_ios, color: Colors.teal, size: 16),
                      SizedBox(width: 8),

                    ],
                  )
              ),
            )
        )
    ) ;


    Widget carouselSlider00 = Center(
      child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              stops: [0.1, 0.9],
              colors: [
                Colors.grey[800]!,
                Colors.grey[400]!,
              ],
            ),
          ),
          padding: EdgeInsets.only(top: 50.0, bottom: 50.0),
          width: double.infinity,
          child: new Padding(
              padding: const EdgeInsets.all(15.0),
              child: new Center(child: new CircularProgressIndicator()))
      ),
    );

    Widget carouselSlider01 = CarouselSlider(
      items: <Widget>[
        if(ls03_img_slider.length != 0)
          for (var i = 0; i < ls03_img_slider.length; i++)
            Container(
              height: 200,
              margin: EdgeInsets.all(5.0),
              child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  child: Stack(
                    children: <Widget>[
                      InkWell(
                        onTap: (){
                          /*clickSlider(ls03_jns_slider[i], ls03_idf_pasar[i], ls03_pageview_idf[i]); */
                          clickSlider(ls03_blog_url[i]);
                        },
                        child: Image.network(ls03_img_slider[i], fit: BoxFit.cover, width: 1000.0),
                      ),
                      Positioned(
                        bottom: 0.0,
                        left: 0.0,
                        right: 0.0,
                        child: InkWell(
                          onTap: (){
                            /*clickSlider(ls03_jns_slider[i], ls03_idf_pasar[i], ls03_pageview_idf[i]);*/
                            clickSlider(ls03_blog_url[i]);
                          },
                          child: Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color.fromARGB(200, 0, 0, 0),
                                    Color.fromARGB(0, 0, 0, 0)
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                              child: ls03_jns_slider[i] == "1"
                                  ? Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(ls03_blog_judul[i], style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold,  )),
                                      Text(ls03_blog_tgl[i] , style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold,  )),
                                    ],
                                  )
                                  : ( ls03_jns_slider[i] == "2" || ls03_jns_slider[i] == "0"
                                        ? Text(ls03_blog_judul[i] , style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold,  ))
                                        : const Text(".")
                                    )
                          ),
                        ),
                      ),
                    ],
                  )
              ),
            ),
      ],

      options: CarouselOptions(
          autoPlay: true,
          enlargeCenterPage: true,
          aspectRatio: 2.0,
          onPageChanged: (index, reason) {
            setState(() {
              _current = index;
            });
          }
      ),
    );

    Widget carousel = ls03_img_slider.isEmpty
        ? carouselSlider00
        : carouselSlider01;

    Widget carouselIndicator01 = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        if(ls03_img_slider.length != 0)
          for (var i = 0; i < ls03_img_slider.length; i++)
            Container(
              width: 8.0,
              height: 8.0,
              margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 2.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _current == i
                    ? Color.fromRGBO(0, 0, 0, 0.9)
                    : Color.fromRGBO(0, 0, 0, 0.4),
              ),
            )
      ],
    );

    Widget indicator = ls03_img_slider.length == 0
        ? const SizedBox(height: 10.0,)
        : carouselIndicator01;

    Widget blog_carousel = Padding(
      padding: EdgeInsets.all(0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.8),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(3, 0), // changes position of shadow
            ),
          ],
        ),
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Rejiwa Blog",
                    style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
                GestureDetector(
                  onTap: (){ clickSlider('all'); },
                  child: Text("Lihat semua",
                      style: TextStyle(color: Colors.teal, fontSize: 14,)),
                ),
              ],
            ),
            SizedBox(height: 20,),
            carousel,
            SizedBox(height: 16,),
            indicator,
            SizedBox(height: 90),
          ],
        ),
      ),
    ) ;

    return Scaffold(
        key: _scaffoldKey,
        /*appBar: AppBar(title: Text('Homeee 222')),*/
        body: RefreshIndicator(
            key: refreshKey,
            onRefresh: () async {     await refreshList0();    },
            child: ListView(
                  children: [
                    w_Head00,
                    SizedBox(height: 15),

                    Text("Selamat datang di Rejiwa !", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),

                    SizedBox(height: 10),
                    //w_MoodToday0,

                    SizedBox(height: 15),
                    CustomCard001("btn_01_tr.png", "Tes Kesehatan Mental", "Alat skrining untuk deteksi awal adanya depresi atau cemas",
                    (){ Navigator.push(context, SlideRightRoute(page: TestMental0())); }),

                    SizedBox(height: 15),
                    CustomCard001("btn_02_tr.png", "Jurnal Kesehatan Mental", "Jurnal untuk menemani perjalananmu dan membantumu lebih mengenali dirimu",
                    (){ Navigator.push(context, SlideRightRoute(page: JurnalMental0())); }),

                    SizedBox(height: 15),
                    CustomCard001("btn_03_tr.png", "Jurnal Konsultasi", "Jurnal untuk membantu proses konsultasi dengan terapismu",
                    (){ Navigator.push(context, SlideRightRoute(page: JurnalKonsul0())); }),

                    SizedBox(height: 15),
                    CustomCard001("btn_04_tr.png", "Teknik Relaksasi", "Teknik relaksasi, teknik pernapasan untuk ketenangan jiwa",
                    (){ Navigator.push(context, SlideRightRoute(page: TeknikRelaks0())); }),

                    SizedBox(height: 15),
                    CustomCard001("btn_05_tr.png", "Kontak Bantuan Terdekat", "Kontak Bantuan Terdekat yang bisa dihubungi",
                    (){ Navigator.push(context, SlideRightRoute(page: KontakBantuan_WV0())); }),

                    SizedBox(height: 15),
                    CustomCard001("ico_map02.png", "Direktori Dokter Praktek", "Daftar Dokter Praktek Terdekat yang bisa dihubungi",
                            (){ Navigator.push(context, SlideRightRoute(page: PetaDokter())); }),

                    SizedBox(height: 30),
                    blog_carousel,


                    ]
                  ),
        )

    );

  }

  getUserPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    var a = prefs.getString("idf_user") ?? "";
    var b = prefs.getString("sf_img_background") ?? "";
    var c = prefs.getString("sf_img_background_filename") ?? "";
    var d = prefs.getString("sf_img_profil") ?? "";
    var e = prefs.getString("sf_img_profil_filename") ?? "";

    getUserPrefs_1(a, b, c, d, e);
  }

  getUserPrefs_1(idf_user0, bb0, cc0, dd0, ee0) {
    setState(() {
      idf_user = idf_user0;

      sf_img_profil = dd0;
      sf_img_profil_filename = ee0;
      if(sf_img_profil_filename != ""){
          sf_img_profil_bytesImage = Base64Decoder().convert(sf_img_profil);  // keluarin simpan diluar biar tak flickerng/blinking
      }

      sf_img_background = bb0;
      sf_img_background_filename = cc0;
      if(sf_img_background_filename != ""){
        sf_img_background_bytesImage = Base64Decoder().convert(sf_img_background);  // keluarin simpan diluar biar tak flickerng/blinking
      }

      if(idf_user != ""){
        pop00Visible = true;
        ambilDataUser(idf_user);
      }

    });
  }

  Future ambilDataUser(String idf_user) async{

    String sBar = "";
    final String url00 = AppConfig().url_API + "mob-data-user";
    debugPrint(url00 + " --> " + idf_user );
    try {
      final response = await http.post(Uri.parse(url00), body: {
        'idf_user' : idf_user ,
        'minta_dari' : 'home' ,
      });

      if(response.statusCode == 200){
        final String responseString = response.body;
        var err_code0 = jsonDecode(responseString)["err_code"];
        debugPrint(responseString + " errcode : $err_code0");

        if(err_code0==0){
          //debugPrint("masuuuk");
          setState(() {

            //akunSaya_vis = true;
            pop00Visible = false;

            s_nama = jsonDecode(responseString)["data"][0]["nama"];

            s_mob_img_profil = jsonDecode(responseString)["data"][0]["mob_img_profil"];
            s_mob_img_background = jsonDecode(responseString)["data"][0]["mob_img_background"];

            /* String s_quot00 = jsonDecode(responseString)["data"][0]["quote_fav"];
            if(s_quot00 != ''){
              s_quote_fav = s_quot00;
            } */

            String s_quot00b = jsonDecode(responseString)["data"][0]["quote_fav_arr"];
            if(s_quot00b != ''){
              s_quote_fav = s_quot00b;
            }

          });

          if(s_mob_img_background != sf_img_background_filename){
            var url0  = AppConfig().url_APIRoot +"data/img-profil-member/"+s_mob_img_background;
            networkImageToBase64(url0, 'backgroun');
          }

          if(s_mob_img_profil != sf_img_profil_filename){
            var url0  = AppConfig().url_APIRoot +"data/img-profil-member/"+s_mob_img_profil;
            networkImageToBase64(url0, 'profil');
          }

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

    if(sBar != ""){ myDialog00().snackBar003(context, sBar); }

  }

  Future ambilDataCarousel() async{

    String sBar = "";
    final String url00 = AppConfig().url_API + "mob-img-slider";
    debugPrint(url00 + " --> " );
    try {
      final response = await http.post(Uri.parse(url00), body: {
        'xxx' : "xxx" ,
      });

      if(response.statusCode == 200){
        String imgURL0 = AppConfig().url_APIRoot + "data/img-mob-slider/";
        final String responseString = response.body;
        var errCode0 = jsonDecode(responseString)["err_code"];
        debugPrint(responseString + " errcode : $errCode0");

        if(errCode0==0){
          var jumDat = jsonDecode(responseString)["jum_dat"];
          for (int ix=0; ix<jumDat; ix++){
            var aa = imgURL0 + jsonDecode(responseString)["data"][ix]["image"];
            debugPrint(aa);
            setState(() {
              ls03_img_slider.add(imgURL0 + jsonDecode(responseString)["data"][ix]["image"]);
              ls03_jns_slider.add(jsonDecode(responseString)["data"][ix]["jenis_sider"]);

              ls03_blog_judul.add(jsonDecode(responseString)["data"][ix]["pageview_judul"]);
              ls03_blog_tgl.add("10 juni 2010");

              ls03_blog_url.add(jsonDecode(responseString)["data"][ix]["blog_url"]);
            });
          }
          //setState(() { isiJSON = ls03_img_slider; });
        }
        else if(errCode0==1) { sBar = "Data Not found!"; }
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

    if(sBar != ""){
      //myDialog00().snackBar002(_scaffoldKey, sBar);
      debugPrint(sBar);
    }
  }

  Future setUserPrefs01(String sf_editProfilFromHome) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("sf_editProfilFromHome", sf_editProfilFromHome);
  }

  void fotoProfilClick() {
    debugPrint("profil tapped");
    setUserPrefs01("1");
    //Navigator.push(context, SlideRightRoute(page: Profil0()));
    Navigator.pushReplacement(context, SlideRightRoute(page: HomePage0()));
    //setState(() {}); // refresh

  }



  base64_toImage(String _imgString){
    Uint8List _bytesImage;
    //String _imgString = 'iVBORw0KGgoAAAANSUhEUg.....';
    _bytesImage = Base64Decoder().convert(_imgString);  // keluarin simpan diluar biar tak flickerng/blinking
    return Image.memory(_bytesImage).image;
  }

  Future networkImageToBase64(String imageUrl, String untuk0) async {
    http.Response response = await http.get(Uri.parse(imageUrl));
    final bytes = response.bodyBytes;
    //return base64Encode(bytes);
    String base64string = base64Encode(bytes);

    if( untuk0 == 'backgroun'){
      setState(() {
        sf_img_background = base64string;
        sf_img_background_filename = s_mob_img_background;
        sf_img_background_bytesImage = Base64Decoder().convert(sf_img_background);  // keluarin simpan diluar biar tak flickerng/blinking
      });
      setUserPrefs02(base64string);
    }
    else if( untuk0 == 'profil'){
      setState(() {
        sf_img_profil = base64string;
        sf_img_profil_filename = s_mob_img_profil;
        sf_img_profil_bytesImage = Base64Decoder().convert(sf_img_profil);  // keluarin simpan diluar biar tak flickerng/blinking
      });
      setUserPrefs03(base64string);
    }

  }

  Future setUserPrefs02(String img0) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("sf_img_background_filename", s_mob_img_background);
    prefs.setString("sf_img_background", img0);
  }

  Future setUserPrefs03(String img0) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("sf_img_profil_filename", s_mob_img_profil);
    prefs.setString("sf_img_profil", img0);
  }



  Future<Null> refreshList0() async {
    await Future.delayed(Duration(seconds: 1));
    refreshUlang();
    return null;
  }

  refreshUlang() {
    setState(() {
      getUserPrefs();
    });
  }

  void clickSlider(String blog_url0) {
    setUserPrefs04(blog_url0);
    Navigator.push(context, SlideRightRoute(page: Blog_WV0()));
  }

  Future setUserPrefs04(String blog_url0) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("sf_blog_url", blog_url0);
  }


}

class CustomCard001 extends StatelessWidget{
  String imgText0;
  String text01;
  String text02;
  Function()? onTap0;

  CustomCard001(this.imgText0, this.text01, this.text02, this.onTap0);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
      child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          color: AppConfig().biru01,
          elevation: 2,
          child: InkWell(
            onTap: onTap0,
            borderRadius: BorderRadius.circular(15.0),
            child: Container(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                width: MediaQuery.of(context).size.width*0.5 - 16 ,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(width: 16),
                    Image.asset("assets/images/$imgText0", width: 45),
                    SizedBox(width: 15),
                    Container(
                      //color: Colors.blueAccent,
                        constraints: BoxConstraints(  //pake constraint biar ga overflow
                            minWidth: MediaQuery.of(context).size.width - 142 ,
                            maxWidth: MediaQuery.of(context).size.width - 142 ,
                            minHeight: 70, maxHeight: 400),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center ,
                          children: [
                            Text(text01, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold )),
                            SizedBox(height: 5),
                            Text(text02, style: TextStyle(color: Colors.white, fontSize: 11 ))
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
