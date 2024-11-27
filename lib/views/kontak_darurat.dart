import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../dialog00.dart';
import '../konfig000.dart';
import '../slide_anim.dart';
import 'home000.dart';
import 'kontak_darurat_det.dart';
import 'kontak_darurat_f.dart';
import 'test_mental.dart';


class KontakDarurat0 extends StatefulWidget {
  const KontakDarurat0({Key? key}) : super(key: key);

  @override
  State<KontakDarurat0> createState() => _KontakDarurat0State();
}

class _KontakDarurat0State extends State<KontakDarurat0> {

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String idf_user="";

  // cara baca data localnya
  // 1. baca dulu di shared sf_kontak_darurat_idf ,
  //      jika = idf_user berarti sudah sync
  //      jika belum ada ato != maka baca keserver trus simpan di sharedPref ,
  // 2. jika ada add/edit/del langsung kirim semua keserver ,
  //      yg di server hapus ganti dg data baru ini

  String sf_kontak_darurat_idf = "x"; // 'x' -> loading;  'A202...'-> ini ada
  String sf_kontak_darurat_data = "";

  bool pop00Visible=false;
  bool pop00_dialogAddBaru = false;
  bool pop00_hapusRK = false;

  // --- tuk isi json , pisah dulu ah -- yg kontak
  List<String> ls02_k_nama = [];
  List<String> ls02_k_nohp = [];
  List<String> ls02_k_nowa = [];
  List<String> ls02_k_pesan = [];

  int max_kontak = 5;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserPrefs();
  }

  @override
  Widget build(BuildContext context) {

    Widget w_judul = Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              child: Icon( Icons.arrow_back_ios, color: Colors.black, size: 20, ),
              onTap: (){
                  //Navigator.of(context).pop();

                  //Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                    //HomePage0()), (Route<dynamic> route) => false);

                  Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
            SizedBox(height: 20,),
            Text('Kontak Darurat', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold ),),
          ],
        )
    );

    Widget w_TambahKontak = CustomButtonDark001("Tambah Kontak", () {
      Navigator.push(context, SlideRightRoute(page: KontakDaruratForm0()));
    });

    Widget w_gambar = Image.asset("assets/images/no_contact.png",
      fit: BoxFit.fitWidth,
      width: MediaQuery.of(context).size.width - 220 ,
      alignment: Alignment.topCenter,
    );

    Widget w_belumAda = Visibility(
      visible: (ls02_k_nama.length == 0) ? true : false,
      child: Column(
        children: [
          SizedBox(height: 50,),
          w_gambar,
          SizedBox(height: 20,),
          Text('Belum ada kontak darurat', style: TextStyle(color: Colors.black, fontSize: 16 ),),
          SizedBox(height: 250,),
          w_TambahKontak,
          SizedBox(height: 20),
        ],
      ),
    );

    Widget listKomoditi() {
      return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: ls02_k_nama.length,
          itemBuilder: (BuildContext context, int index){
            return Container(
                padding: EdgeInsets.only(left: 1, right: 1, bottom: 16),
                //width: 200,
                child: CustomCard04b(index, ls02_k_nama[index], ls02_k_nohp[index], ls02_k_nowa[index], ls02_k_pesan[index], (){ detailKontak(index);} )
            );
          }
      );
    }

    Widget listKomoditi_00() {
        return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: (max_kontak - ls02_k_nama.length),
            itemBuilder: (BuildContext context, int index){
              return Container(
                  padding: EdgeInsets.only(left: 1, right: 1, bottom: 16),
                  //width: 200,
                  child: CustomCard04b_00()
              );
            }
        );
    }


    return Scaffold(
        backgroundColor: Colors.white,
        //appBar: AppBar(title: Text('Tes Kesehatan Mental'), backgroundColor: Colors.teal,),
        body: Stack(
          children: [
            ListView(
              children: [
                w_judul,
                SizedBox(height: 20,),
                Padding(
                    padding: EdgeInsets.fromLTRB(30, 10, 30,10),
                    child: Column(
                      children: [
                        popup01_loader( (sf_kontak_darurat_idf == 'x') ? true : false, "Loading Data ..."),
                        Visibility(
                          visible: (sf_kontak_darurat_idf != 'x') ? true : false,
                          child: Column(
                            children: [
                              w_belumAda,
                              listKomoditi(),
                              Visibility(
                                  visible: (ls02_k_nama.length > 0) ? true : false,
                                  child: Column(
                                    children: [
                                      listKomoditi_00()
                                    ],
                                  )
                              )

                            ],
                          )
                        )

                      ],
                    )
                ),
                SizedBox(height: 100,),
              ],
            ),

            popup00(pop00_hapusRK),
            popup01_loader(pop00_hapusRK, "Processing Data ...")
          ],
        )
    );

  }


  getUserPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    var a = prefs.getString("idf_user") ?? "";
    var b = prefs.getString("sf_kontak_darurat_idf") ?? "x";
    var c = prefs.getString("sf_kontak_darurat_data") ?? "";
    var d = prefs.getString("sf_kontak_darurat_kirimserver") ?? "";

    getUserPrefs_1(a, b, c, d);
  }

  getUserPrefs_1(idf_user0, sf_kontak_darurat_idf0, sf_kontak_darurat_data0, sf_kontak_darurat_kirimserver0) {
    setState(() {
      idf_user = idf_user0;
      sf_kontak_darurat_data = sf_kontak_darurat_data0;
      sf_kontak_darurat_idf = sf_kontak_darurat_idf0;

      debugPrint("idf_user : " + idf_user + " | sf_kontak_darurat_idf : " + sf_kontak_darurat_idf + " | sf_kontak_darurat_data : " + sf_kontak_darurat_data );

      if(idf_user != ""){
        pop00Visible = true;
        if(sf_kontak_darurat_idf=="x" || sf_kontak_darurat_idf != idf_user) {
          ambilDataUser(idf_user);
          //sf_kontak_darurat_data = "";
        }
      }

      showListKontak0();

      if(sf_kontak_darurat_kirimserver0 == "1"){
        setUserPrefs_kirimKeServer000();
        kirimKeServer();
      }

    });
  }

  Future ambilDataUser(String idf_user) async{

    String sBar = "";
    final String url00 = AppConfig().url_API + "mob-data-kontak_darurat";
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
            pop00Visible = false;
            sf_kontak_darurat_data = jsonDecode(responseString)["data"][0]["kontak_json"];
            setUserPrefs_datakontak();
            showListKontak0();
          });
        }
        else if(err_code0==1) {
          //sBar = "Data Not found!";
          /*
          setState(() {
            pop00Visible = false;
            sf_kontak_darurat_idf = "x";
          });
          */
        }
      }
      else {
        int a=response.statusCode; debugPrint("xxxx $a ");
        sBar = "No Connection!";
      }

    } catch (e) {
      String cek = "xxx.. $e"; // biar jadi string exceptionnya
      debugPrint(cek);

      if(cek.contains('unreachable')){ sBar = "No Internet Connection!"; }
      else { sBar = "Cannot Connect to Server!";   }
    }

    if(sBar != ""){ myDialog00().snackBar003(context, sBar); }

    setState(() {
      pop00Visible = false;
      sf_kontak_darurat_idf = idf_user;
    });

    debugPrint("sf_kontak_darurat_idf serv : " + sf_kontak_darurat_idf);

    debugPrint("sf_kontak_darurat_data serv : " + sf_kontak_darurat_data);


  }

  Future kirimKeServer() async{ // senyap ja jgn ada notif

    String sBar = "";
    final String url00 = AppConfig().url_API + "mob-data-kontak_darurat-replace";
    debugPrint(url00 + " --> " + idf_user );
    try {
      final response = await http.post(Uri.parse(url00), body: {
        'idf_user' : idf_user ,
        'kontak_json' : sf_kontak_darurat_data ,
      });

      if(response.statusCode == 200){
        final String responseString = response.body;
        var err_code0 = jsonDecode(responseString)["err_code"];
        debugPrint(responseString + " errcode : $err_code0");

        if(err_code0==0){
          //debugPrint("masuuuk");
          setState(() {
            //pop00Visible = false;
          });
        }
        else if(err_code0==1) {
          //sBar = "Data Not found!";
          /*
          setState(() {
            pop00Visible = false;
            sf_kontak_darurat_idf = "x";
          });
          */
        }
      }
      else {
        //int a=response.statusCode; debugPrint("xxxx $a ");
        //sBar = "No Connection!";
      }

    } catch (e) {
      String cek = "xxx.. $e"; // biar jadi string exceptionnya
      debugPrint(cek);

      //if(cek.indexOf('unreachable') > -1){ sBar = "No Internet Connection!"; }
      //else { sBar = "Cannot Connect to Server!";   }
    }

    //if(sBar != ""){ myDialog00().snackBar003(context, sBar); }
  }

  showListKontak0() {
    if(sf_kontak_darurat_data != ""){
      var datakontak = json.decode(sf_kontak_darurat_data);

      debugPrint(' datakontak.length : '+datakontak.length.toString() + ' -- '+sf_kontak_darurat_data);
      setState(() {
        for (var i = 0; i < datakontak.length; i++){
          ls02_k_nama.add(datakontak[i]['nama']);
          ls02_k_nohp.add(datakontak[i]['nohp']);
          ls02_k_nowa.add(datakontak[i]['nowa']);
          ls02_k_pesan.add(datakontak[i]['pesan']);
        }

      });
    }
  }


  detailKontak(int idx0) {
    debugPrint('detail kontak index : $idx0' );
    setUserPrefs_kontak_detail(idx0.toString());
    Navigator.push(context, SlideRightRoute(page: KontakDaruratDet0()));
  }

  Future setUserPrefs_kontak_detail(idx0) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("sf_kontak_darurat_detail_idx", idx0);
  }


  Future setUserPrefs_datakontak() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("sf_kontak_darurat_idf", idf_user);
    prefs.setString("sf_kontak_darurat_data", sf_kontak_darurat_data);
  }

  Future setUserPrefs_kirimKeServer000() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //prefs.setString("sf_kontak_darurat_kirimserver", "");
    prefs.remove('sf_kontak_darurat_kirimserver');
  }

}



class CustomCard04b extends StatelessWidget{

  int idx0;
  String nama0;
  String nohp0;
  String nowa0;
  String pesan0;
  Function()? onTap0;

  CustomCard04b(this.idx0, this.nama0, this.nohp0, this.nowa0, this.pesan0, this.onTap0 );

  @override
  Widget build(BuildContext context) {

    Widget w_btn_tlp = Container(
      width: 50,
      child: RawMaterialButton(
        onPressed: onTap0, //() {},
        elevation: 2.0,
        fillColor: Colors.white,
        child: Icon(
          Icons.phone,
          size: 25.0,
          color: Colors.teal,
        ),
        padding: EdgeInsets.all(7.0),
        shape: CircleBorder(),
      )
    );

    Widget w_btn_wa = Container(
      width: 50,
      child: RawMaterialButton(
        onPressed: onTap0, //() {},
        elevation: 2.0,
        fillColor: Colors.white,
        child: Icon(
          Icons.chat_rounded,
          size: 25.0,
          color: Colors.teal,
        ),
        padding: EdgeInsets.all(7.0),
        shape: CircleBorder(),
      ),
    );

    // TODO: implement build
    return InkWell(
      onTap: onTap0 ,
      child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          color: Colors.teal.shade300,
          elevation: 3,
          child: Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(nama0, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    w_btn_tlp,
                    w_btn_wa
                  ],
                ),


              ],
            )
          )


      ),
    );
  }

}


class CustomCard04b_00 extends StatelessWidget{

  CustomCard04b_00();

  @override
  Widget build(BuildContext context) {

    Widget w_btn_add = Container(
        width: 50,
        child: RawMaterialButton(
          onPressed: () { Navigator.push(context, SlideRightRoute(page: KontakDaruratForm0())); },
          elevation: 2.0,
          fillColor: Colors.grey.shade400,
          child: Icon(
            Icons.add,
            size: 25.0,
            color: Colors.white,
          ),
          padding: EdgeInsets.all(7.0),
          shape: CircleBorder(),
        )
    );

    // TODO: implement build
    return InkWell(
      onTap: (){ /*produkDetailGo2(ls02_k_idf_komoditi[index]);*/ },
      child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          color: Colors.grey.shade100,
          elevation: 3,
          child: Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: w_btn_add
              )
          )
    );
  }

}

