import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../dialog00.dart';
import '../konfig000.dart';
import '../myFunc.dart';
import '../slide_anim.dart';
import 'profil_pass_edit.dart';
import 'quote_fav_multi_wv.dart';

class Profil0 extends StatefulWidget {
  @override
  _Profil0State createState() => _Profil0State();
}

class _Profil0State extends State<Profil0> {

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late GlobalKey<RefreshIndicatorState> refreshKey;
  String idf_user="";
  String s_nama="", s_telp="", s_email="", s_email_verify="0", s_telp_verify="0", s_tgl_lahir="", s_tgl_lahirFF="", s_jns_kelamin="", s_mob_img_profil="", s_mob_img_background="";
  String s_quote_fav = "Tidak peduli sesedikit apapun, kemajuan adalah kemajuan";
  String s_quote_fav_arr = "Tidak peduli sesedikit apapun, kemajuan adalah kemajuan";


  bool pop00Visible=false;
  final _keyForm = GlobalKey<FormState>();

  final TextEditingController _quot_controller = TextEditingController();
  final TextEditingController _lahir_controller = TextEditingController();


  final _picker = ImagePicker();
  late File _selectedFile;
  bool _inProcess = false;
  late File image;
  

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refreshKey = GlobalKey<RefreshIndicatorState>();

    _quot_controller.text = s_quote_fav;

    getUserPrefs();

  }

  @override
  Widget build(BuildContext context) {

    Widget w_Foto = Stack(
      alignment: Alignment.center,
      children: [
        Material(
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
        ),
        Positioned(
            top: 0, right: MediaQuery.of(context).size.width * 0.5 - 50,
            child: GestureDetector(
              onTap: (){ debugPrint("foto tapped"); pilihSumberImg('img-profil'); },
              child: Container(
                  height: 30,
                  width: 30,
                  padding: EdgeInsets.fromLTRB(1, 1, 1, 1),
                  decoration: new BoxDecoration(
                      color: Colors.teal,
                      borderRadius: new BorderRadius.circular(50),
                      border: Border.all(color: Colors.white)
                  ),
                  child: Center(
                    child: Icon(Icons.camera_alt_outlined, color: Colors.white, size: 16),
                  )
              ),
            )
        )
      ],
    );

    Widget w_Bekgron = Material(
      borderRadius: BorderRadius.all(Radius.circular(20)),
      elevation: 10,
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          child: s_mob_img_background==''
              ? Image.asset("assets/images/profil_bg.png", fit: BoxFit.cover, height: 200,)
              : Image.network(AppConfig().url_APIRoot +"data/img-profil-member/"+s_mob_img_background, fit: BoxFit.cover, height: 200,) ,
        ),
      ),
    );

    Widget w_Bekgron_btn = GestureDetector(
      onTap: () { debugPrint("Bekgron tapped!");  pilihSumberImg('img-bekgron'); },
      child: Text("Ganti Background", style: TextStyle(fontSize: 16, color: Colors.teal, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
    );

    Widget w_Quote_btn = GestureDetector(
      onTap: () { debugPrint("w_Quote_btn tapped!"); editQuote(); },
      child: Text("Ubah quote favorit", style: TextStyle(fontSize: 16, color: Colors.teal, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
    );

    Widget w_Pass_btn = GestureDetector(
      onTap: () {
        debugPrint("w_Pass_btn tapped!");
        Navigator.push(context, SlideRightRoute(page: RubahPass()));
      },
      child: Text("Ubah Password", style: TextStyle(fontSize: 16, color: Colors.teal, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
    );

    Widget w_Quote = Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: Colors.teal.shade100,
        elevation: 2,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(s_quote_fav , style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold), ),
            ),
            w_Quote_btn,
            SizedBox(height: 20),
          ],
        )
    );

    Widget w_QuoteMulti = Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: Colors.teal.shade100,
        elevation: 2,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(s_quote_fav_arr , style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold), ),
            ),
            GestureDetector(
              onTap: () {
                debugPrint("w_QuoteMulti_btn tapped!");
                Navigator.push(context, SlideRightRoute(page: QuoteFavoritM_WV0()));
              },
              child: Text("Lihat Quote Favorit", style: TextStyle(fontSize: 16, color: Colors.teal, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            ),
            SizedBox(height: 20),
          ],
        )
    );

    Widget w_EditProfil_btn = GestureDetector(
      onTap: () {
        debugPrint("w_EditProfil_btn tapped!");
        editTTL();
      },
      child: Text("edit", style: TextStyle(fontSize: 16, color: Colors.teal, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
    );

    Widget w_GenderPil = Row(
      children: [
        GestureDetector(
          onTap: (){ pilGender('L'); },
          child: Container(
              height: 40,
              width: 100,
              padding: EdgeInsets.fromLTRB(1, 1, 1, 1),
              decoration: new BoxDecoration(
                  color: (s_jns_kelamin == "L") ? Colors.teal : Colors.white ,
                  borderRadius: new BorderRadius.circular(10),
                  border: Border.all(color: Colors.teal)
              ),
              child: Center(
                child: Text("Pria" , style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: (s_jns_kelamin == "L") ? Colors.white : Colors.teal), ),
              )
          ),
        ),

        SizedBox(width: 16),

        GestureDetector(
          onTap: (){ pilGender('P'); },
          child: Container(
              height: 40,
              width: 100,
              padding: EdgeInsets.fromLTRB(1, 1, 1, 1),
              decoration: new BoxDecoration(
                  color: (s_jns_kelamin == "P") ? Colors.teal : Colors.white ,
                  borderRadius: new BorderRadius.circular(10),
                  border: Border.all(color: Colors.teal)
              ),
              child: Center(
                child: Text("Wanita" , style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: (s_jns_kelamin == "P") ? Colors.white : Colors.teal), ),
              )
          ),
        ),
      ],
    );

    return Scaffold(
        key: _scaffoldKey,
        /*appBar: AppBar(title: Text('Homeee 222')),*/
        body: RefreshIndicator(
            key: refreshKey,
            onRefresh: () async {
              await refreshList0();
            },
          child: Stack(
            children: [
              ListView(children: [

                Padding(padding: EdgeInsets.fromLTRB(16, 10, 16, 0),
                  child: Text("Profil", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), ),
                ),

                Padding(padding: EdgeInsets.fromLTRB(16, 20, 16, 0),
                  child: w_Foto,
                ),

                Padding(padding: EdgeInsets.fromLTRB(16, 30, 16, 0),
                  child: w_Bekgron,
                ),

                Padding(padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: w_Bekgron_btn,
                ),

                /*
                Padding(padding: EdgeInsets.fromLTRB(16, 30, 16, 0),
                  child: w_Quote,
                ), */

                Padding(padding: EdgeInsets.fromLTRB(16, 30, 16, 0),
                  child: w_QuoteMulti,
                ),

                Padding(padding: EdgeInsets.fromLTRB(16, 30, 16, 0),
                  child: Text("Nama Lengkap", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), ),
                ),

                Padding(
                  padding: EdgeInsets.fromLTRB(20, 10, 16, 10),
                  child: Text(s_nama, style: TextStyle(fontSize: 18), ),
                ),

                Padding(padding: EdgeInsets.fromLTRB(16, 30, 16, 0),
                  child: Text("Tanggal Lahir", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), ),
                ),

                Padding(
                  padding: EdgeInsets.fromLTRB(20, 10, 16, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text( s_tgl_lahirFF , style: TextStyle(fontSize: 18), ),
                      w_EditProfil_btn
                    ],
                  )
                ),

                Padding(padding: EdgeInsets.fromLTRB(16, 30, 16, 0),
                  child: Text("Gender", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), ),
                ),

                Padding(padding: EdgeInsets.fromLTRB(16, 10, 16, 0),
                  child: w_GenderPil,
                ),

                /*
                Padding(padding: EdgeInsets.fromLTRB(20, 10, 16, 10),
                  child: Text(s_jns_kelamin, style: TextStyle(fontSize: 18), ),
                ),
                */

                Padding(padding: EdgeInsets.fromLTRB(16, 30, 16, 0),
                  child: Text("Nomor Telepon", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), ),
                ),

                Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 16, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(s_telp, style: TextStyle(fontSize: 18), ),
                        s_telp_verify == "1" ? Icon(Icons.check_circle, color: Colors.teal, size: 24) : SizedBox(width: 1,),
                      ],
                    )
                ),

                Padding(padding: EdgeInsets.fromLTRB(16, 30, 16, 0),
                  child: Text("E-mail", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), ),
                ),

                Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 16, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(s_email, style: TextStyle(fontSize: 18), ),
                        s_email_verify == "1" ? Icon(Icons.check_circle, color: Colors.teal, size: 24) : SizedBox(width: 1,),
                      ],
                    )
                ),

                Padding(padding: EdgeInsets.fromLTRB(16, 30, 16, 0),
                  child: Text("Password", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), ),
                ),

                Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 16, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("***********", style: TextStyle(fontSize: 18), ),
                        w_Pass_btn,
                      ],
                    )
                ),




                SizedBox(height: 150),
              ]),
              popup00(pop00Visible),
              popup01_loader(pop00Visible, "processing data, please wait ...")
            ],
          )
        )

    );

  }


  Future<Null> refreshList0() async {
    await Future.delayed(Duration(seconds: 1));
    refreshUlang();
    return null;
  }

  refreshUlang() {
    if (mounted) {
      setState(() {

        getUserPrefs();

    });
    }
  }

  getUserPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    var a = prefs.getString("idf_user") ?? "";
    var b = prefs.getString("sf_editProfilFromHome") ?? "0";

    getUserPrefs_1(a, b);
  }

  getUserPrefs_1(idf_user0, sf_editProfilFromHome) {
    if (mounted) {
      setState(() {
        idf_user = idf_user0;

        if (idf_user != "") {
          pop00Visible = true;
          ambilDataUser(idf_user);

          if (sf_editProfilFromHome == "1") {
            setUserPrefs01("0");
            pilihSumberImg('img-profil');
          }
        }
      });
    }
  }

  Future setUserPrefs01(String sf_editProfilFromHome) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("sf_editProfilFromHome", sf_editProfilFromHome);
  }

  Future ambilDataUser(String idf_user) async{

    String sBar = "";
    final String url00 = AppConfig().url_API + "mob-data-user";
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
          if (mounted) {
          setState(() {

            //akunSaya_vis = true;
            pop00Visible = false;

            s_nama = jsonDecode(responseString)["data"][0]["nama"];
            s_telp = jsonDecode(responseString)["data"][0]["telepon"];
            s_email = jsonDecode(responseString)["data"][0]["email"];
            s_email_verify = jsonDecode(responseString)["data"][0]["verifikasi_email"];
            s_telp_verify = jsonDecode(responseString)["data"][0]["verifikasi_telp"];

            s_tgl_lahir = jsonDecode(responseString)["data"][0]["tgl_lahir"];
            s_mob_img_profil = jsonDecode(responseString)["data"][0]["mob_img_profil"];
            s_mob_img_background = jsonDecode(responseString)["data"][0]["mob_img_background"];

            var jk = jsonDecode(responseString)["data"][0]["jns_kelamin"];
            //if(jk == "L") { s_jns_kelamin = "Pria"; }
            //else if(jk == "P") { s_jns_kelamin = "Wanita"; }
            s_jns_kelamin = jk ;

            if(s_tgl_lahir != "0000-00-00"){
                _lahir_controller.text = s_tgl_lahir;
                s_tgl_lahirFF = MyFunct00().formatTgl(s_tgl_lahir) ;
            }

            String s_quot00 = jsonDecode(responseString)["data"][0]["quote_fav"];
            if(s_quot00 != ''){
              s_quote_fav = s_quot00;
              _quot_controller.text = s_quot00;

            }

            String s_quot00b = jsonDecode(responseString)["data"][0]["quote_fav_arr"];
            s_quote_fav_arr = s_quot00b;

          });}
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

  void pilihSumberImg(String untuk0) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 150,
          color: Colors.amber,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text( untuk0 == 'img-profil' ? 'Foto Profil' : 'Gambar Background', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: (){
                        debugPrint('Galeri pil');
                        getImage(untuk0, ImageSource.gallery);
                        },
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.teal,
                            child: Icon(Icons.image_outlined, color: Colors.white, size: 35.0,),
                          ),
                          Text('Galeri'),
                        ],
                      ),
                    ),

                    SizedBox(width: 20,),

                    GestureDetector(
                      onTap: (){
                        debugPrint('Kamera pil');
                        getImage(untuk0, ImageSource.camera);
                        },
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.teal,
                            child: Icon(Icons.camera_alt_outlined, color: Colors.white, size: 35.0,),
                          ),
                          Text('Kamera'),
                        ],
                      ),
                    ),

                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }


  getImage(String untuk00, ImageSource source) async {
    if (mounted) {
      this.setState(() {
        _inProcess = true;
      });
    }
    /*
    //File image = await _picker.getImage(source: source);
    final pickedFile = await _picker.getImage(source: source);
    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
    */

    try {
      final pickedFile = await _picker.pickImage(
        source: source,
        //maxWidth: maxWidth,
        //maxHeight: maxHeight,
        //imageQuality: quality,
      );
      if (mounted) {
        setState(() {
          if (pickedFile != null) {
            image = File(pickedFile.path);
          } else {
            print('No image selected.');
          }
        });
      }
    } catch (e) {
      setState(() {
        //_pickImageError = e;
      });
    }

    if(image != null){

      // File? cropped = await ImageCropper.cropImage(
     /* File? cropped = (await ImageCropper().cropImage(
          sourcePath: image.path,
          aspectRatio: CropAspectRatio(
              ratioX: 1, ratioY: 1),
          compressQuality: 100,
          maxWidth: 500,
          maxHeight: 500,
          compressFormat: ImageCompressFormat.png,
          androidUiSettings: AndroidUiSettings(
            toolbarColor: Colors.deepOrange,
            toolbarTitle: "Image Cropper",
            statusBarColor: Colors.deepOrange.shade900,
            backgroundColor: Colors.white,
          )
      )) as File?;*/


      Future<void> cropped() async {
        // Make sure to import the appropriate packages
        CroppedFile? cropped = await ImageCropper().cropImage(
          sourcePath: image.path, // The image path to be cropped
          compressQuality: 100, // Compress quality of the image (ignored on Web)
          maxWidth: 500, // Maximum width of the cropped image
          maxHeight: 500, // Maximum height of the cropped image
          compressFormat: ImageCompressFormat.png, // The image format (png or jpg)
          uiSettings: [
            // Platform-specific UI settings for Android
            AndroidUiSettings(
              toolbarTitle: 'Crop Image', // Toolbar title for Android
              toolbarColor: Colors.deepOrange, // Toolbar color
              toolbarWidgetColor: Colors.white, // Color of toolbar widgets like buttons
              backgroundColor: Colors.white, // Background color of the cropper
              statusBarColor: Colors.deepOrange.shade900, // Status bar color
              activeControlsWidgetColor: Colors.deepOrange, // Active control color
              initAspectRatio: CropAspectRatioPreset.square, // Initial aspect ratio
              lockAspectRatio: true, // Lock aspect ratio for cropping
            ),
            // Platform-specific UI settings for iOS
            IOSUiSettings(
              minimumAspectRatio: 1.0, // Minimum aspect ratio (iOS)
              resetButtonHidden: true, // Whether to hide the reset button
                showCancelConfirmationDialog: true, // Show cancel confirmation
            ),
            // Platform-specific UI settings for Web
            WebUiSettings(
              context: context, // Web UI settings for the context (if needed)
            ),
          ],
        );

        if (cropped != null) {
          // Handle the cropped image (cropped.path to get the file path)
          print('Cropped image path: ${cropped.path}');
        }
      }

      this.setState((){
        _selectedFile = cropped! as File;
        _inProcess = false;
        //ls01_file_img.add(_selectedFile);

        pop00Visible = true;
        Navigator.pop(context);
        saveProfil(untuk00);
      });
    } else {
      this.setState((){
        _inProcess = false;
      });
    }
  }


  void editQuote() {

    Widget ssss = Container(
      height: 250,
      color: Colors.amber,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text( 'Quote Favorit', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 20,),
            Padding(
                padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: TextFormField(
                  decoration: InputDecoration(
                    //icon: Icon(Icons.account_circle),
                      filled: true,
                      fillColor: Colors.white,
                      //prefixIcon: Icon(Icons.person),
                      labelText: 'Quote',
                      contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))
                  ),
                  keyboardType: TextInputType.multiline,
                  validator: (value){
                    if(value!.isEmpty){ return "Harap isi Quote"; }
                    else { return null; }
                  },
                  maxLength: 250,
                  minLines: 2,
                  maxLines: null,
                  controller: _quot_controller,
                )
            ) ,
            ElevatedButton(
              onPressed: (){

                if(_keyForm.currentState!.validate()){
                  setState(() {
                    s_quote_fav = _quot_controller.text.trim();
                    pop00Visible = true;
                  });
                  debugPrint("data submitted, "+s_quote_fav);
                  Navigator.pop(context);
                  saveProfil('quote');
                }

              },
              child: Text( 'Simpan', style: TextStyle(color: Colors.white, fontSize: 14)),
            ),
          ],
        ),
      ),
    );

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Form(
                  key: _keyForm,
                  child: ssss,
                )
              ));
        });

  }



  void editTTL() {

    Widget tgl_lahir = TextFormField(
          controller: _lahir_controller,
          decoration: InputDecoration(
            //icon: Icon(Icons.account_circle),
              filled: true,
              fillColor: Colors.white,
              //prefixIcon: Icon(Icons.person),
              labelText: 'Tanggal Lahir',
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))
          ),
          //keyboardType: TextInputType.multiline,
          validator: (value){
            if(value!.isEmpty){ return "Harap isi Tanggal Lahir"; }
            else { return null; }
          },
          onTap: () async{
            DateTime? date = DateTime(1900);
            FocusScope.of(context).requestFocus(FocusNode());

            date = ( await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate:DateTime(1900),
                lastDate: DateTime(2100)))!;
            var d = date.toIso8601String().substring(0, 10);
            _lahir_controller.text = d;
          },
    );

    Widget save_btn = ElevatedButton(
      onPressed: (){

        if(_keyForm.currentState!.validate()){
          setState(() {
            s_tgl_lahir = _lahir_controller.text.trim();
            pop00Visible = true;
          });
          debugPrint("data submitted, "+s_tgl_lahir);
          Navigator.pop(context);
          saveProfil('TTL');
        }

      },
      child: Text( 'Simpan', style: TextStyle(color: Colors.white, fontSize: 14)),
    );

    /*
    Widget gender0 = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Gender" , style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold), textAlign: TextAlign.start, ),
        Row(
          children: [
            GestureDetector(
              onTap: (){ pilGender('L'); },
              child: Container(
                  height: 40,
                  width: 100,
                  padding: EdgeInsets.fromLTRB(1, 1, 1, 1),
                  decoration: new BoxDecoration(
                      color: (s_jns_kelamin == "L") ? Colors.teal : Colors.white ,
                      borderRadius: new BorderRadius.circular(10),
                      border: Border.all(color: Colors.teal)
                  ),
                  child: Center(
                    child: Text("Pria" , style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: (s_jns_kelamin == "L") ? Colors.white : Colors.teal), ),
                  )
              ),
            ),

            SizedBox(width: 16),

            GestureDetector(
              onTap: (){ pilGender('P'); },
              child: Container(
                  height: 40,
                  width: 100,
                  padding: EdgeInsets.fromLTRB(1, 1, 1, 1),
                  decoration: new BoxDecoration(
                      color: (s_jns_kelamin == "P") ? Colors.teal : Colors.white ,
                      borderRadius: new BorderRadius.circular(10),
                      border: Border.all(color: Colors.teal)
                  ),
                  child: Center(
                    child: Text("Wanita" , style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: (s_jns_kelamin == "P") ? Colors.white : Colors.teal), ),
                  )
              ),
            ),

          ],
        )
      ],
    );
    */

    Widget ssss = Container(
      height: 250,
      color: Colors.amber,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text( 'Edit Profil', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 20,),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: tgl_lahir,
            ),
            /*
            Padding(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: gender0,
            ),
            */
            SizedBox(height: 16),
            save_btn
          ],
        ),
      ),
    );

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context,state){
            return SingleChildScrollView(
              child: Container(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Form(
                    key: _keyForm,
                    child: ssss,
                  )
              ));
          });
        });
  }

  void pilGender(String s) {
    debugPrint("s_jns_kelamin tapped " + s_jns_kelamin);
    setState(() {
      s_jns_kelamin = s ;
      pop00Visible = true ;
    });
    saveProfil('gender') ;
  }

  Future saveProfil(String jns) async{

    var ss_quote = '';
    var ss_img = '';
    var ss_gender = '';
    var ss_TTL = '';
    if(jns=='quote'){ ss_quote=s_quote_fav ; }
    else if(jns=='img-profil' || jns=='img-bekgron'){
      List<int> imageBytes = _selectedFile.readAsBytesSync();
      String base64Image = base64Encode(imageBytes);
      ss_img = base64Image;
    }
    else if(jns=='gender'){ ss_gender = s_jns_kelamin ; }
    else if(jns=='TTL'){ ss_TTL = s_tgl_lahir ; }


    final String url00 = AppConfig().url_API + "mob-save-profil";
    debugPrint(url00);
    try {
      final response = await http.post(Uri.parse(url00), body: {
        'idf_user' : idf_user,
        'jns_save' : jns ,
        'quote_fav' : ss_quote,
        'image' : ss_img,
        'gender' : ss_gender,
        'TTL' : ss_TTL,
      });

      if(response.statusCode == 200){
        final String responseString = response.body;
        var err_code0 = jsonDecode(responseString)["err_code"];
        debugPrint(responseString + " errcode : $err_code0");
        if(err_code0==1) {
          //_pass_controller.clear();

          myDialog00().alert0(context, "Alert", "Data Gagal Disimpan !");
        }
        else if(err_code0==0){
          debugPrint("masuuuk");

          if(jns=='img-profil' || jns=='img-bekgron'){
            refreshUlang();
          }

          //var idf_user0 = jsonDecode(responseString)["data"][0]["idf_member"];
          //setUserPrefs(idf_user0, nama_user0, deviceid_user0);

          //Navigator.pushReplacement(context, SlideRightRoute(page: HomePage0()));
        }

        //return responseString;
      }
      else {
        /*int a=response.statusCode; debugPrint("xxxx $a ");*/
        myDialog00().openDialog00(context, "No Connection !");
        //return null;
      }

    } catch (e) {
      String cek = "xxx.. $e"; // biar jadi string exceptionnya
      debugPrint(cek);

      if(cek.indexOf('unreachable') > -1){
        myDialog00().openDialog00(context, "No Internet Connection !");
      }else{
        myDialog00().openDialog00(context, "Cannot Connect to Server !");
      }
    }

    setState(() {
      pop00Visible = false;
    });

  }





}
