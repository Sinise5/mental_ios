import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
//import 'package:webview_flutter/platform_interface.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import '../dialog00.dart';
import '../konfig000.dart';
import '../myWidget.dart';

class SafetyPlan_WV0 extends StatefulWidget {
  @override
  _SafetyPlan_WV0State createState() => _SafetyPlan_WV0State();
}

class _SafetyPlan_WV0State extends State<SafetyPlan_WV0> {

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late GlobalKey<RefreshIndicatorState> refreshKey;
  String idf_user = "";
  bool progBar = true;
  bool noInternetVis = false;

  String sf_SafetyPlan_lihataja = "";


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
    //WebView.platform = SurfaceAndroidWebView(); //enabling hybrid composition. // coba atasi soft keyboard ga muncul
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
          _webViewController.loadUrl(AppConfig().url_APIRoot+'mobile/mob_safety_plan.php?idf_user='+idf_user+'&lihataja='+sf_SafetyPlan_lihataja);
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

    Future<void> _launchInBrowser(Uri url) async {
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        throw 'Could not launch $url';
      }
    }


    Widget w_webview0 = WebViewWidget(
      controller: _webViewController = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..addJavaScriptChannel(
            'messageHandler',
            onMessageReceived: (JavaScriptMessage message) {
              debugPrint(message.message);
              if (message.message == "clickBackFromJS") {
                Navigator.pop(context); // Pop the navigator when message is received
              } else {
                var ms = message.message;
                var ms2 = ms.split('|');
                if (ms2[0] == 'clicFromJS_lihatDiYoutube') {
                  // Handle the YouTube URL
                  var url = "https://www.youtube.com/watch?v=" + ms2[1];
                  _launchInBrowser(Uri.parse(url)); // Open in browser
                }
              }
            }
        )
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
              debugPrint('WebView is loading (progress: $progress%)');
            },
            onPageStarted: (String url) {
              print('Page started loading : $url');
            },
            onPageFinished: (String url) {
              setState(() {
                progBar = false;
              });
              print('Page finished loading : $url $idf_user $ulang1');
              if (idf_user != "" && ulang1 == 0) {
                setState(() {
                  progBar = true;
                });
                debugPrint("lagiiiii");
                setState(() {
                  ulang1 += 1;
                });
                // Load URL after checking conditions
                String newUrl = AppConfig().url_APIRoot + 'mobile/mob_safety_plan.php?idf_user=' + idf_user + '&lihataja=' + sf_SafetyPlan_lihataja;
                _webViewController.loadRequest(Uri.parse(newUrl));
              }
            },
            onWebResourceError: (WebResourceError error) {
              print('Page error loading: $error');
              setState(() {
                noInternetVis = true;
              });
            },
          ),
        )
        ..loadRequest(Uri.parse('about:blank')), // Initial URL set to 'about:blank'
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
    var b = prefs.getString("sf_SafetyPlan_lihataja") ?? "";

    getUserPrefs_1(a, b);
  }

  getUserPrefs_1(idf_user0, sf_SafetyPlan_lihataja0) {
    setState(() {
      idf_user = idf_user0;
      sf_SafetyPlan_lihataja = sf_SafetyPlan_lihataja0;

      if(idf_user != ""){
        //pop00Visible = true;
        //ambilDataUser(idf_user);
      }

    });

    setUserPrefs01();

  }


  Future setUserPrefs01() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //prefs.setString("sf_SafetyPlan_lihataja", '');
    prefs.remove("sf_SafetyPlan_lihataja");
  }

}
