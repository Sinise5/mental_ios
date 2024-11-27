import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:webview_flutter/platform_interface.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../dialog00.dart';
import '../konfig000.dart';
import '../myWidget.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
// Import for iOS/macOS features.
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class JurnalKonsul_WV0 extends StatefulWidget {
  @override
  _JurnalKonsul_WV0State createState() => _JurnalKonsul_WV0State();
}

class _JurnalKonsul_WV0State extends State<JurnalKonsul_WV0> {

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
      onWebViewCreated: (WebViewController webViewController) {
        _webViewController = webViewController;
      },
      onPageStarted: (String url) {
        print('Page started loading : $url');
      },
      onPageFinished: (String url) {
        setState(() {
          progBar = false;
        });
        print('Page finished loading : $url $idf_user $ulang1');
        if(idf_user!="" && ulang1==0){
          debugPrint("lagiiiii");
          setState(() {
            progBar = true;
            ulang1 += 1;
          });
          _webViewController.loadUrl(AppConfig().url_APIRoot+'mobile/mob_jurnal_konsultasi.php?idf_user='+idf_user);
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
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
              debugPrint('WebView is loading (progress : $progress%)');
            },
            onPageStarted: (String url) {
              debugPrint('Page started loading: $url');
            },
            onPageFinished: (String url) {
              debugPrint('Page finished loading: $url');
              progBar = false; // Update UI state here, use setState if necessary.
              if (idf_user != "" && ulang1 == 0) {
                debugPrint("lagiiiii");
                progBar = true; // Update UI state if needed
                ulang1 += 1;
                String newUrl = AppConfig().url_APIRoot + 'mobile/mob_jurnal_konsultasi.php?idf_user=' + idf_user;
                _webViewController.loadRequest(Uri.parse(newUrl));
              }
            },
            onWebResourceError: (WebResourceError error) {
              debugPrint('Page error loading: $error');
              noInternetVis = true; // Update UI state here, use setState if necessary.
            },
          ),
        )
        ..loadRequest(Uri.parse('about:blank')),
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
      //_webViewController.loadUrl(AppConfig().url_APIRoot+'mobile/mob_jurnal_konsultasi.php?idf_user='+idf_user);
      _webViewController.loadRequest(Uri.parse(AppConfig().url_APIRoot+'mobile/mob_jurnal_konsultasi.php?idf_user='+idf_user));
      debugPrint("lagiiiii");
      setState(() {
        ulang1 += 1;
      });
    }

  }

  getUserPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance()
        .then((SharedPreferences prefs0) => getUserPrefs_1(
      prefs0.getString("idf_user") ?? "",
    ) );
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
