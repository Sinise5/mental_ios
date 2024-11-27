import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:webview_flutter/platform_interface.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import '../dialog00.dart';
import '../konfig000.dart';
import '../myWidget.dart';

class KontakBantuan_WV0 extends StatefulWidget {
  @override
  _KontakBantuan_WV0State createState() => _KontakBantuan_WV0State();
}

class _KontakBantuan_WV0State extends State<KontakBantuan_WV0> {

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late GlobalKey<RefreshIndicatorState> refreshKey;
  String idf_user = "";
  bool progBar = true;
  bool noInternetVis = false;


  late WebViewController _webViewController;
  final _keyWebview = GlobalKey();
  int ulang1 = 0 ; //biasanya yg pertama param ga kebawa


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getUserPrefs();

    refreshKey = GlobalKey<RefreshIndicatorState>();
    //fetchfiVe();

    //if (Platform.isAndroid) {
   // WebView.platform = SurfaceAndroidWebView(); //enabling hybrid composition. // coba atasi soft keyboard ga muncul
    //}

    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    _webViewController = WebViewController.fromPlatformCreationParams(params);
  }

  @override
  Widget build(BuildContext context) {

    /*
    Widget w_webview0 = WebView(
      key: _keyWebview,
      //initialUrl: AppConfig().url_APIRoot+'/mobile/mob_pengaduan_list.php?idf_user='+idf_user,
      initialUrl: 'about:blank',
      javascriptMode: JavascriptMode.unrestricted,
      javascriptChannels: Set.from([
        JavascriptChannel(
            name: 'messageHandler',
            onMessageReceived: (JavascriptMessage message) {
              debugPrint(message.message);
              if(message.message == "clickBackFromJS"){
                Navigator.pop(context);
              }
            })
      ]),
      onWebViewCreated: (WebViewController webViewController) {
        _webViewController = webViewController;
      },
      onPageStarted: (String url) {
        print('Page started loading : $url');
      },
      onPageFinished: (String url) {
        setState(() {  progBar = false;    });
        print('Page finished loading : $url $idf_user $ulang1');
        if(idf_user!="" && ulang1==0){
          setState(() {  progBar = true;    });
          _webViewController.loadUrl(AppConfig().url_APIRoot+'mobile/mob_kontak_bantuan.php?idf_user='+idf_user);
          debugPrint("lagiiiii");
          setState(() {
            ulang1 += 1;
          });
        }
      },
      onWebResourceError: (WebResourceError error){
        print('Page error loading: $error');
        setState(() {
          noInternetVis = true;
        });

      },
    );*/

    Widget w_webview0 = WebViewWidget(
      controller: _webViewController = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..addJavaScriptChannel(
            'messageHandler',
            onMessageReceived: (JavaScriptMessage message) {
              debugPrint(message.message);
              if (message.message == "clickBackFromJS") {
                Navigator.pop(context); // Pop the navigator when message is received
              }
            }
        )
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
              debugPrint('WebView is loading (progress: $progress%)');
            },
            onPageStarted: (String url) {
              print('Page started loading: $url');
            },
            onPageFinished: (String url) {
              setState(() {
                progBar = false; // Hide the progress bar after page load
              });
              print('Page finished loading: $url $idf_user $ulang1');
              if (idf_user != "" && ulang1 == 0) {
                debugPrint("lagiiiii");
                setState(() {
                  progBar = true; // Show the progress bar before loading new URL
                  ulang1 += 1;
                });
                String newUrl = AppConfig().url_APIRoot + 'mobile/mob_kontak_bantuan.php?idf_user=' + idf_user;
                _webViewController.loadRequest(Uri.parse(newUrl)); // Load new URL
              }
            },
            onWebResourceError: (WebResourceError error) {
              print('Page error loading: $error');
              setState(() {
                noInternetVis = true; // Handle the error (e.g., show no internet)
              });
            },
          ),
        )
        ..loadRequest(Uri.parse('about:blank')), // Initial URL
    );


    return Scaffold(
        key: _scaffoldKey,
        body: RefreshIndicator(
            key: refreshKey,
            onRefresh: () async {
              await refreshList0();
            },
            child: Stack(
              children: [

                noInternetVis == false
                    ? w_webview0 //WebViewContainer(key: webViewKey)
                    : Padding(
                  padding: EdgeInsets.fromLTRB(30, 50, 30, 0),
                  child: CustomNoInternet00(noInternetVis, "Koneksi Internetmu terganggu, \n Pastikan internetmu lancar dengan cek data, Wifi, atau jaringan di tempatmu", Icons.signal_wifi_off),
                ),
                popup00(progBar),
                popup01_loader(progBar, "Loading Data ...")
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
    setState(() {
      //fetchfiVe();
      ulang1=0;
    });
    if(idf_user!="" && ulang1==0){
      //_webViewController.loadUrl(AppConfig().url_APIRoot+'mobile/mob_jurnal_perasaan.php?idf_user='+idf_user);
      _webViewController.loadRequest(Uri.parse(AppConfig().url_APIRoot+'mobile/mob_jurnal_perasaan.php?idf_user='+idf_user));
      debugPrint("lagiiiii");
      setState(() {
        ulang1 += 1;
      });
    }

  }


  getUserPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    var a = prefs.getString("idf_user") ?? "";
    getUserPrefs_1(a);
  }

  getUserPrefs_1(idf_user0) {
    setState(() {
      idf_user = idf_user0;

      if(idf_user != ""){
        //pop00Visible = true;
        //ambilDataUser(idf_user);
      }

    });
  }

}
