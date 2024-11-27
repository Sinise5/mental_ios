import 'package:flutter/material.dart';

import '../konfig000.dart';
import 'faq_wv.dart';
import 'privacy_policy.dart';
import '../dialog00.dart';
import '../slide_anim.dart';

class Seting0 extends StatefulWidget {
  @override
  _Seting0State createState() => _Seting0State();
}

class _Seting0State extends State<Seting0> {

  bool _valNotif00 = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [

          Padding(padding: EdgeInsets.fromLTRB(16, 10, 16, 0),
            child: Text("Pengaturan", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), ),
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(20, 16, 20, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Notifikasi "),
                Switch.adaptive(
                  value: _valNotif00,
                  onChanged: (newValue) => setState(() => _valNotif00 = newValue),
                )
              ],
            ),
          ),

          SizedBox(height: 30),
          CustomListTile0(Icons.help_outline, "Pusat bantuan", () {
            Navigator.push(context, SlideRightRoute(page: FAQ_WV0()));
          } ),
          CustomListTile0(Icons.article_outlined, "Syarat Penggunaan & Kebijakan Privacy", () {
            Navigator.push(context, SlideRightRoute(page: PrivacyPolicy_WV0()));
          } ),
          CustomListTile0(Icons.logout, "Keluar", () {
            myDialog00().confirm0(context, "Konfirmasi", "Apakah Anda Akan Logout?", "logot");
          } ),

          SizedBox(height: 30),
          Icon(Icons.check_circle, size: 70,),
          SizedBox(height: 30),
          Text("Rejiwa v" + AppConfig().mob_Version, style: TextStyle(fontSize: 10, color: Colors.grey,), textAlign: TextAlign.center, ),

          SizedBox(height: 150),
        ],
      ),
    );
  }
}


class CustomListTile0 extends StatelessWidget{

  IconData icon0;
  String text0;
  Function()? onTap0;

  CustomListTile0(this.icon0, this.text0, this.onTap0);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16.0, 0),
      child: Container(
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    color: Colors.grey.shade300
                )
            )
        ),
        child: InkWell(
          splashColor: Colors.orangeAccent,
          onTap: onTap0,
          child: Container(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(icon0),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        text0,
                        style: TextStyle(fontSize: 12.0),
                      ),
                    )
                  ],
                ),
                Icon(Icons.arrow_right)
              ],
            ),
          ),
        ),
      ),
    );

  }

}
