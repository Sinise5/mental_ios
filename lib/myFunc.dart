import 'dart:io';

//import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;


class MyFunct00 {

  formatRibu(String val) {
    String nilai = "";
    int jum = val.length ;
    while(jum > 3) { //alert (jum+' '+val);
      nilai = "." + val.substring(val.length-3) + nilai;
      int sisa = val.length - 3;
      val = val.substring(0, sisa);
      jum = val.length ;
    }

    nilai = val + nilai  ;
    //nilai = nilai.replace(/-./i,"- ");
    return nilai;
  }

  cekNoTelp(String text) {
    String errhp = "";
    if(errhp == ""){
      int j = text.length;
      if(j < 10){ errhp="Harap Isi Dengan Nomor Yang Valid"; }
    }
    if(errhp == "") {
      String cek1 = text.substring(0, 1);
      if(cek1!="0" && cek1!="8"){ errhp="Harap Isi Dengan Nomor Yang Valid"; }
      else{
        if(cek1=="0"){
          String cek1 = text.substring(0, 2);
          if(cek1!="08"){ errhp="Harap Isi Dengan Nomor Yang Valid"; }
        }
      }
    }
    return errhp;
  }

  rupiahTextField(String text, TextEditingController controller0){
    if(text.isNotEmpty){
      String text01 = text.replaceAll(RegExp(r"[^0-9]"), "");
      int text02 = int.parse(text01);
      text02 = text02*1;

      String res01 = text02.toString();
      String res02 = MyFunct00().formatRibu(res01);

      if(text != res02){
        controller0.text = res02 ;
        controller0.selection = TextSelection.fromPosition(TextPosition(offset: controller0.text.length));
      }
    }
  }

  ambilTlpAja(String text){
    int n = text.indexOf(':');
    String aa2 = text.substring(n+1);
    n = aa2.indexOf('(');
    String aa3 = aa2.substring(0, n);
    String aa4 = aa3.trim().replaceFirst("+62", "0");
    String aa5 = aa4.replaceAll(new RegExp('[- ]'), "");

    return aa5;
  }

  Future<File> urlToFile(String imageUrl, String nameImg) async {

    http.Response response = await http.get(Uri.parse(imageUrl));

    //Directory tempDir = await getTemporaryDirectory();
    final tempDir = await getApplicationDocumentsDirectory();

    File file = new File(tempDir.path + nameImg);

    await file.writeAsBytes(response.bodyBytes);

    return file;
  }

  /*
  Future<void> shareText(String title, String isi) async {
    try {
      Share.text(title, isi, 'text/plain');
    } catch (e) {
      print('error: $e');
    }
  }
   */

  capitalizeFirstofEach(String text) {
    if(text != "") {
      text = text.toLowerCase();
      var arr = text.split(" ");
      for (var i = 0; i < arr.length; i++) {
        arr[i] = arr[i].substring(0, 1).toUpperCase() + arr[i].substring(1);
      }
      text = arr.join(" ");
    }
    return text;
  }

  waktuSekarang(){
    DateTime date = DateTime.now();
    //String time = "${date.hour}:${date.minute}:${date.second}";
    String yy_0 = "${date.year}";
    String bb_0 = "${date.month}"; bb_0 = bb_0.padLeft(2, '0');
    String tt_0 = "${date.day}"; tt_0 = tt_0.padLeft(2, '0');
    String hh_0 = "${date.hour}"; hh_0 = hh_0.padLeft(2, '0');
    String mm_0 = "${date.minute}"; mm_0 = mm_0.padLeft(2, '0');
    String ss_0 = "${date.second}"; ss_0 = ss_0.padLeft(2, '0');

    String nowX = yy_0+"-"+bb_0+"-"+tt_0+" "+hh_0+":"+mm_0+":"+ss_0;

    return nowX;
  }

  waktuSekarang00(){
    //0123-56-89 12:45:78
    String t = MyFunct00().waktuSekarang();
    String t2 = t.substring(0,4) + t.substring(5,7) + t.substring(8,10) + t.substring(11,13) + t.substring(14,16) + t.substring(17,19) + "";
    return t2;
  }

  tambahResponseString(String responseString){
    // ---- jaga2 kerena suka ada yg kepotong resp nya, biasanya jika pake wifi
    // ---- tambah   }]}
    var respString2 = responseString ;
    var cekString = respString2.substring(respString2.length - 3);
    if(cekString != '}]}'){
      var lastString = cekString.substring(cekString.length - 1);
      var tambal = '}]}' ;
      if(lastString == '}') {
        tambal = ']}' ;
      }
      else if(lastString == ']') {
        tambal = '}' ;
      }

      respString2 += tambal ;
    }
    return respString2;
    //-----
  }

  formatTgl(String val){
    String th = val.substring(0, 4);
    String bl = val.substring(5, 7);
    String hr = val.substring(8, 10);
    return hr + '-' + bl + '-' + th ;
  }
}
