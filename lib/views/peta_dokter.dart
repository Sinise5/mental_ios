import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../dialog00.dart';
import '../konfig000.dart';

class PetaDokter extends StatefulWidget {
  const PetaDokter({Key? key}) : super(key: key);

  @override
  State<PetaDokter> createState() => _PetaDokterState();
}

class _PetaDokterState extends State<PetaDokter> {

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final PanelController _panelController = new PanelController();
  late double _panelHeightOpen;
  final double _panelHeightClosed = 150.0;

  bool pop00Visible=true;

  final CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng( -7.353573, 108.228711 ),
    zoom: 14.4746,
  );
  late GoogleMapController _GMapController;
  final List<Marker> markers = [];
  final List<String> markers_id = []; // buat cek udah ada ga

  List<Map<String, dynamic>> myListRS = [];

  String myPosLat='', myPosLon='';

  late BitmapDescriptor pinLocationIcon ,
      pinLocationIconTruk ;

  StreamSubscription<Position>? positionStream;

  late Timer _timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setCustomMapPin();
    ambilDataDokter();
  }

  @override
  Widget build(BuildContext context) {

    _panelHeightOpen = MediaQuery.of(context).size.height * .85;

    Widget listPraktek() {
      return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: myListRS.length,
          itemBuilder: (BuildContext context, int index){
            return Container(
                padding: EdgeInsets.only(left: 1, right: 1, bottom: 16),
                width: MediaQuery.of(context).size.width - 50,
                child:
                //Text(ls03_nama[index])
                CustomCard04b(index, myListRS[index]['idf'], myListRS[index]['nama'], myListRS [index]['alamat'], myListRS[index]['telp'], myListRS[index]['dokter'],
                    (){ klikMarker(myListRS[index]['idf']); _panelController.close();  },
                    myListRS[index]['jarak'].toString(),
                    (){ ruteMapkeRS(index); }
                )
            );
          }
      );
    }

    Widget w_GoogleMap0 = GoogleMap(
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      initialCameraPosition: _kGooglePlex,
      mapType: MapType.normal,
      onMapCreated: (controller) {
        setState(() {
          _GMapController = controller;
        });
        //addMarker(_kGooglePlex);
        //addMarker(LatLng(-6.016323823125272, 106.0541051862305));
        //addMarker3(LatLng(-6.016323823125272, 106.0541051862305), "CP100");

        playWalktrough();

        /*
        Future.delayed(const Duration(milliseconds: 1234), () {
          if(selc_stp_lat != ''){
            addMarker(LatLng(double.parse(selc_stp_lat), double.parse(selc_stp_lon)), selc_stp_nama, 'rumah');
            _goToTheLake(selc_stp_lat, selc_stp_lon);
            playWalktrough();
          }
        });

        Future.delayed(const Duration(milliseconds: 2000), () {
          lihatAllMarker();
        });
        */

      },
      markers: markers.toSet(),
      /*
      polylines: _polyline,
      gestureRecognizers: < Factory < OneSequenceGestureRecognizer >> [
        new Factory < OneSequenceGestureRecognizer > (
              () => new EagerGestureRecognizer(),
        ),
      ].toSet(),
      */
      onTap: (coor){
        //addMarker(coor);
      },
    );

    Widget peta00 = Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height - 227,
                    child: w_GoogleMap0
                ),
                SizedBox(height: 200,)
              ],
            ),
            /*
            Positioned(
                top: 60,//MediaQuery.of(context).size.height - 350,
                right: 5, //left: 0,
                child: Column(
                  children: [
                    //w_LihatAllMarker,
                    //w_STPButtonTEST
                  ],
                )
            )
            */
          ],
        )
    );

    Widget panelGaris = Center(
      child: SizedBox(
        width: 50,
        child: Column(
          children: const <Widget>[
            SizedBox(height: 7),
            Divider(height: 1, thickness: 1, color: Colors.black38),
            SizedBox(height: 3),
            Divider(height: 1, thickness: 1, color: Colors.black38),
            SizedBox(height: 10),
          ],
        ),
      ),
    );

    Widget panel0 = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        panelGaris,
        Container(
            padding: const EdgeInsets.fromLTRB(15, 1, 0, 3),
            width: MediaQuery.of(context).size.width - 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const <Widget>[
                    Text("DIREKTORI DOKTER PRAKTEK", textAlign: TextAlign.left, style: TextStyle(color: Colors.green),),
                    SizedBox(height: 10,),
                  ],
                ),
              ],
            )
        ),
        const Divider(height: 7, thickness: 7,),
        const SizedBox(height: 10),

        myListRS.isNotEmpty
            ? Container(
                  height: _panelHeightOpen - 75,
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 5),
                  child: ListView(
                    children: [
                      listPraktek()
                    ],
                  )
              )
            : const SizedBox(height:0),

        //Image.asset("assets/images/simonso1.png", width: 160, height: 45 ),

      ],
    );

    Widget SlidingUpPanel0 = SlidingUpPanel(
        controller: _panelController,
        maxHeight: _panelHeightOpen,
        minHeight: _panelHeightClosed,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(18.0), topRight: Radius.circular(18.0)),
        panel: panel0,
        body: peta00
    );

    // SHA-1 debug: AB:7A:2A:56:81:B1:15:92:F8:36:48:B8:75:94:ED:FB:C7:A1:80:BB
    // SHA-1 release: 34:01:34:F4:CE:11:E6:3F:D9:A4:82:04:28:34:70:A5:E7:62:5B:55
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(title: const Text('Direktori Dokter'), backgroundColor: Colors.teal,),
        body: Stack(
          children: [
            SlidingUpPanel0,
            popup00(pop00Visible),
            popup01_loader(pop00Visible, "Loading Data , Please wait ..."),
          ],
        )
    );

  }


  Future ambilDataDokter() async{

    String sBar = "";
    final String url00 = AppConfig().url_API + "mob-praktek-dokter";
    debugPrint("$url00 --> " );
    try {
      final response = await http.post(Uri.parse(url00), body: {
        'xxx' : "xxx" ,
      });

      if(response.statusCode == 200){
        //String imgURL0 = AppConfig().url_APIRoot + "data/img-mob-slider/";
        final String responseString = response.body;
        var errCode0 = jsonDecode(responseString)["err_code"];
        debugPrint("$responseString errcode : $errCode0");

        if(errCode0==0){
          var jumDat = jsonDecode(responseString)["jum_dat"];
          debugPrint(" jumDat : $jumDat");
          for (int ix=0; ix<jumDat; ix++){


            var idf0 = '';
            var nama0 = '';
            var lat0 = '';
            var lon0 = '';
            setState(() {

              idf0 = jsonDecode(responseString)["data"][ix]["idf"];
              nama0 = jsonDecode(responseString)["data"][ix]["nama"];
              lat0 = jsonDecode(responseString)["data"][ix]["lat"];
              lon0 = jsonDecode(responseString)["data"][ix]["lon"];

              myListRS.add({
                'idf': idf0 ,
                'nama': nama0,
                'alamat': jsonDecode(responseString)["data"][ix]["alamat"],
                'telp': jsonDecode(responseString)["data"][ix]["telp"],
                'lat': lat0,
                'lon': lon0,
                'dokter': jsonDecode(responseString)["data"][ix]["dokter"],
                'jarak': 0
              });


            });


            //Future.delayed(const Duration(milliseconds: 1234), () {
              if(lat0 != ''){
                addMarker(LatLng(double.parse(lat0), double.parse(lon0)), nama0 , idf0);
                //_goToTheLake(selc_stp_lat, selc_stp_lon);
                //playWalktrough();
                //debugPrint( " markerrrrr --> " + idf0 );
              }
            //});



          }
          //setState(() { isiJSON = ls03_img_slider; });
          ukurJarak0();
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

      if(cek.contains('unreachable')){ sBar = "No Internet Connection!"; }
      else { sBar = "Cannot Connect to Server!";   }
    }

    setState(() {
      pop00Visible = false;
    });

    if(sBar != ""){
      //myDialog00().snackBar002(_scaffoldKey, sBar);
      debugPrint(sBar);
    }
  }


  Future<void> _goToTheLake(String lat, String lon) async {

    var lat0 = double.parse(lat);
    var lon0 = double.parse(lon);

    final CameraPosition _kLake = CameraPosition(
      target: LatLng(lat0, lon0),
      zoom: 14.4746,
    );
    _GMapController.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }

  addMarker(coordinat, title0, id0){
    //addMarker(LatLng(-6.016323823125272, 106.0541051862305));
    //int id = Random().nextInt(100);
    String id=id0;

    setState(() {
      markers.add(
          Marker(
            markerId: MarkerId(id.toString()),
            position: coordinat,
            infoWindow: InfoWindow(
              title: title0, //"bingo! This works",
            ),
            //icon: (id0 == 'rumah') ? pinLocationIcon : pinLocationIconTruk,
            icon: pinLocationIcon ,
          ));
      markers_id.add(id0);
    });
  }

  void klikMarker(String markerId) {
    // cari marker dengan id tertentu
    Marker marker = markers.firstWhere((marker) => marker.markerId.value == markerId);

    _GMapController.animateCamera(CameraUpdate.newLatLng(marker.position));

    _GMapController.showMarkerInfoWindow(marker.markerId);
  }

  void setCustomMapPin() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/images/marker01.png');

    pinLocationIconTruk = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/images/marker_truk.png');
  }


  void playWalktrough() {
    setState(() {
      debugPrint(".......... tap playWalktrough");
      //walktrough_stat = "play_CP";
      getCurrentLocation();
      //_positionStreamSubscription!.resume();

      positionStream!.resume();

      startTimerBacaLatLon();
    });
  }

  getCurrentLocation() async {

    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      debugPrint('..Location services are disabled.');
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    String lat0 = position.latitude.toString();
    String lon0 = position.longitude.toString();
    debugPrint("pos_skr : "+ lat0 + ', ' + lon0 );

    myPos(lat0, lon0);

    //isikanTrukLatLon(lat0, lon0);

    _goToTheLake(lat0, lon0);  // ke pos sekarang

    ukurJarak0();
    /* --- ini gaya dulu v.7.0.0 ----
    await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        forceAndroidLocationManager: true,
        timeLimit: const Duration(seconds: 5)
      )
        .then((Position position) {
            String lat0 = position.latitude.toString();
            String lon0 = position.longitude.toString();
            debugPrint("pos_skr : "+ lat0 + ', ' + lon0 );
            //saveWalktrhough2DB(lat0, lon0 );
            //setDataPrefs_latlon(lat0, lon0);
          })
        .catchError((e) {
            //print(e);
            debugPrint('pos_err : ' + e.message);
          });
     */

  }


  startTimerBacaLatLon() async { // pake strean ga jalan mulu, jadi ja manual

    _timer = Timer.periodic(const Duration(seconds: 10), (Timer timer) {

      testIsiLatLon0();

      String tick0 = timer.tick.toString();
      debugPrint('pos_tick : ' + tick0);
      if (tick0 == '150000') {
        debugPrint('Cancel timer');
        timer.cancel();
      }
    });

  }

  /*
  isikanTrukLatLon(String lat0, String lon0) {
    // --- cek dulu ah jika beda > 1meter dari prev baru simpan
    double bedaJarak = 0.0;
    double bedaJarak_min = 3;
    if(s_truk_lat != '') {
      bedaJarak = Geolocator.distanceBetween(
          double.parse(s_truk_lat), double.parse(s_truk_lon),
          double.parse(lat0), double.parse(lon0));
      debugPrint('pos_distanceInMeters_truk_withprev : $bedaJarak');
      if (bedaJarak > bedaJarak_min) {
        setState(() {
          s_truk_lat_prev = s_truk_lat;
          s_truk_lon_prev = s_truk_lon;

          s_truk_lat = lat0;
          s_truk_lon = lon0;
        });
      }
    }
    else {
      setState(() {
        s_truk_lat = lat0;
        s_truk_lon = lon0;
      });
    }

    int ada = 0;
    if(markers.length > 0 ) {
      for (var i = 0, l = markers.length; i < l; i++) {
        if (markers_id[i] == 'truk') {
          ada = 1;
        }
      }
    }

    if(ada == 0) {
      s_truk_nopol = nama_user;
      addMarker(LatLng(double.parse(lat0), double.parse(lon0)), s_truk_nopol, 'truk');
    }
    else {
      if (bedaJarak > bedaJarak_min) { rubahPosTrukLatLon(); }
    }

    jarakTrukDanPelanggan();

  }
  */

  isikanTrukLatLon(String lat0, String lon0){}


  Future<void> testIsiLatLon0() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    String lat0 = position.latitude.toString();
    String lon0 = position.longitude.toString();
    debugPrint("pos_skr : "+ lat0 + ', ' + lon0 );

    isikanTrukLatLon(lat0, lon0);

    ukurJarak0();
  }

  void ukurJarak0() {

    if(myListRS.isNotEmpty ) {
      for (var i = 0, l = myListRS.length; i < l; i++) {

        double distanceInMeters = Geolocator.distanceBetween(
            double.parse(myListRS[i]['lat']), double.parse(myListRS[i]['lon']),
            double.parse(myPosLat), double.parse(myPosLon));

        setState(() {
          myListRS[i]['jarak'] = distanceInMeters;
        });
      }

      myListRS.sort((a, b) => a['jarak'].compareTo(b['jarak']));
    }

  }

  void myPos(String lat0, String lon0) {
    setState(() {
      myPosLat = lat0;
      myPosLon = lon0 ;
    });
  }


  Future<void> ruteMapkeRS(int idx0) async {

    var startLatitude = myPosLat ;
    var startLongitude = myPosLon  ;
    var endLatitude = myListRS[idx0]['lat']  ;
    var endLongitude = myListRS[idx0]['lon'] ;

    String url00 = 'https://www.google.com/maps/dir/?api=1&origin=$startLatitude,$startLongitude&destination=$endLatitude,$endLongitude';

    debugPrint(url00);

    if (!await launchUrl(
      Uri.parse(url00),
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url00';
    }
  }

  /*
  Future<double> hitungJarakRute(double startLatitude, double startLongitude, double endLatitude, double endLongitude) async {
    String apiKey = 'YOUR_GOOGLE_MAPS_API_KEY';
    String url = 'https://maps.googleapis.com/maps/api/directions/json?origin=$startLatitude,$startLongitude&destination=$endLatitude,$endLongitude&key=$apiKey';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      String distanceText = data['routes'][0]['legs'][0]['distance']['text'];
      double distanceValue = data['routes'][0]['legs'][0]['distance']['value'];
      return distanceValue / 1000; // Mengkonversi jarak dari meter ke kilometer
    } else {
      throw 'Gagal memperoleh rute.';
    }
  }
  */

}

class CustomCard04b extends StatelessWidget {
  int idx0;
  String kode0;
  String nama0;
  String alm0;
  String tlp0;
  String dokter0;
  Function()? onTap0;
  String jarak0;
  Function()? onTapRute;

  CustomCard04b(this.idx0, this.kode0, this.nama0, this.alm0, this.tlp0, this.dokter0, this.onTap0, this.jarak0, this.onTapRute);

  @override
  Widget build(BuildContext context) {
    List<String> hasilPemecahan0 = dokter0.split("||").toList();

    double jar = double.parse(jarak0);
    String sat = ' m';
    if(jar > 1000) {
      jar = jar/1000;
      sat = ' km';
    }
    jarak0 = jar.toStringAsFixed(2) + sat;

    Widget listDokter() {
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: hasilPemecahan0.length,
        itemBuilder: (BuildContext context, int index2) {
          List<String> dokterData = hasilPemecahan0[index2].split("|").toList();
          List<Widget> widgetList = [];

          if (dokterData.length > 3) {
            widgetList.add(
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("- " + dokterData[1], style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),),
                  Text(dokterData[3], style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),),
                ],
              )
            );
          }

          return Column(
            children: widgetList,
          );
        },
      );
    }

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: Colors.teal.shade300,
      elevation: 3,
      child: InkWell(
        borderRadius: BorderRadius.circular(15.0),
        onTap: onTap0,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              SizedBox(
                width: MediaQuery.of(context).size.width - 80,
                child: Text(
                  nama0,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),

              const SizedBox(height: 7),

              SizedBox(
                width: MediaQuery.of(context).size.width - 80,
                child: Text(
                  alm0,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'telp : $tlp0',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        'jarak : $jarak0',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),

                    ],
                  ),
                  Container(
                      width: 60,
                      child: RawMaterialButton(
                        onPressed: () { _makePhoneCall(tlp0) ;  },
                        elevation: 2.0,
                        fillColor: Colors.white ,
                        padding: const EdgeInsets.all(10.0),
                        shape: CircleBorder(),
                        child: const Icon(
                          Icons.phone,
                          size: 30.0,
                          color: Colors.teal,
                        ),
                      )
                  ),
                  Container(
                      width: 60,
                      child: RawMaterialButton(
                        onPressed: onTapRute,
                        elevation: 2.0,
                        fillColor: Colors.white ,
                        padding: const EdgeInsets.all(10.0),
                        shape: CircleBorder(),
                        child: const Icon(
                          Icons.turn_sharp_right,
                          size: 30.0,
                          color: Colors.teal,
                        ),
                      )
                  )
                ],
              ),

              SizedBox(height: dokter0 != '' ? 15 : 1),

              dokter0 != ''
                  ? const Text("DOKTER PRAKTEK : " , style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),)
                  : SizedBox(height: 1,),

              listDokter(),
            ],
          ),
        ),
      ),
    );
  }


  Future<void> _makePhoneCall(String phoneNumber) async {

    String newTel = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
    if (newTel.startsWith('0')) {
      newTel = newTel.substring(1);
    }

    final Uri launchUri = Uri(
      scheme: 'tel',
      path: '+62$newTel',
    );
    await launchUrl(launchUri);
  }

}
