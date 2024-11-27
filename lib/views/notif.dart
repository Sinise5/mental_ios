import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

import '../dialog00.dart';
import '../konfig000.dart';
import '../myWidget.dart';

class Notif0 extends StatefulWidget {
  @override
  _Notif0State createState() => _Notif0State();
}

class _Notif0State extends State<Notif0> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late GlobalKey<RefreshIndicatorState> refreshKey;
  String idf_user = "";
  bool progBar = true;
  bool noInternetVis = false;
  String newUrl = '';
  String lastLoadedUrl = ''; // Variabel untuk melacak URL terakhir yang dimuat

  late WebViewController _webViewController;
  final _keyWebview = GlobalKey();
  int ulang1 = 0; // Biasanya parameter pertama tidak terbawa

  late final Future<WebViewController> _initWebViewFuture;
  late final NavigationDelegate _navigationDelegate;




  @override
  void initState() {
    super.initState();
    //getUserPrefs();
    _initialize();
    refreshKey = GlobalKey<RefreshIndicatorState>();
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

    if (_webViewController.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (_webViewController.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }
   // _initWebViewFuture = _initWebView();

    debugPrint('${idf_user} xxx');
  }

  Future<void> _initialize() async {
    await getUserPrefs();
    setState(() {
      _initWebViewFuture = _initWebView();
    });
  }

  Future<WebViewController> _initWebView() async {
    if (idf_user.isEmpty) {
      throw Exception("idf_user belum diinisialisasi");
    }
    String link = '${AppConfig().url_APIRoot}mobile/mob_notifikasi.php?idf_user=$idf_user}';

     final _uri = Uri.parse(link.trim());
    print('WebView: _initWebView started.');

    _navigationDelegate = NavigationDelegate(
      onProgress: _onProgress,
      onPageStarted: _onPageStarted,
      onPageFinished: _onPageFinished,
      onWebResourceError: _onWebResourceError,
    );

    _webViewController = WebViewController();

    await _webViewController.setJavaScriptMode(JavaScriptMode.unrestricted);
    await _webViewController.addJavaScriptChannel('MyJavaScripChannel',
        onMessageReceived: _onMessageReceived);
    await _webViewController.setNavigationDelegate(_navigationDelegate);
    await WebViewCookieManager().setCookie(
        const WebViewCookie(name: 'cookie', value: 'value', domain: 'domain.com'));
    await _webViewController.loadRequest(_uri);

    print('WebView: _initWebView finished.${_uri}');
     setState(() {
       progBar = false;
     });

    return Future.value(_webViewController);
  }

  void _onPageStarted(String url) => print('WebView: onPageStarted');

  void _onProgress(int percent) =>  print('WebView: onProgress: $percent');

  void _onPageFinished(String url) => print('WebView: onPageFinished');

  void _onWebResourceError(WebResourceError error) => print(
      'WebView: onWebResourceError: ${error.description} (${error.errorCode}) - ${error.errorType}');

  void _onMessageReceived(JavaScriptMessage message) {}

  @override
  Widget build(BuildContext context) {
    // WebView widget


    debugPrint('Last Loaded URL: $lastLoadedUrl');

/*

    Widget w_webview0 = WebViewWidget(
      controller: _webViewController = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
              debugPrint('WebView is loading (progress: $progress%)');
            },
            onPageStarted: (String url) {
              debugPrint('Page started loading: $url');
              setState(() {
                progBar = true; // Tampilkan indikator loading
              });
            },
            onPageFinished: (String url) async {
              debugPrint('Page finished loading: $url');
              debugPrint('Current URL: $url');
              // Cegah loop dengan memeriksa URL terakhir
              if (idf_user.isNotEmpty && ulang1 == 0 && url != lastLoadedUrl) {
                setState(() {
                  ulang1++;
                  progBar = true; // Tampilkan indikator untuk reload
                });

                // Set URL baru dan muat jika berbeda dari URL terakhir
                String reloadUrl = '${AppConfig().url_APIRoot}mobile/mob_notifikasi.php?idf_user=$idf_user';
                if ((url != reloadUrl) && (ulang1 == 0) ) {
                  debugPrint('Reloading WebView with URL: $reloadUrl');
                  debugPrint('Reload URL: $reloadUrl');
                  lastLoadedUrl = reloadUrl; // Update URL terakhir
                  await _webViewController.loadRequest(Uri.parse(reloadUrl));
                } else {
                  setState(() {
                    progBar = false; // Sembunyikan indikator setelah selesai
                  });
                }
              } else {
                setState(() {
                  progBar = false; // Sembunyikan indikator setelah selesai
                });
              }
            },
            onWebResourceError: (WebResourceError error) {
              debugPrint('Page error loading: $error');
              setState(() {
                noInternetVis = true; // Tampilkan error jika koneksi gagal
              });
            },
          ),
        )
        ..loadRequest(Uri.parse(
            newUrl.isNotEmpty ? newUrl : 'https://example.com')), // URL awal
    );

*/

    /*
    Widget webview01 = FutureBuilder<WebViewController>(
      future: _initWebViewFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return WebViewWidget(controller: _webViewController);
        } else if (snapshot.hasError) {
          return const Center(child: Text('WebView initalization error.'));
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );


    Widget w_webview0 = WebView(
      key: _keyWebview,
      //initialUrl: AppConfig().url_APIRoot+'/mobile/mob_blog.php?idf_user='+idf_user,
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
          //_webViewController.loadUrl(AppConfig().url_APIRoot+'mobile/mob_blog.php?idf_user='+idf_user);

          String url0 = 'https://rejiwa.id/blog';
          if(sf_blog_url != 'all' && sf_blog_url != '') { url0 = sf_blog_url; }
          _webViewController.loadUrl(url0);

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
    if (idf_user.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      key: _scaffoldKey,
      body: FutureBuilder<WebViewController>(
        future: _initWebViewFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return WebViewWidget(controller: _webViewController);
          }
        },
      ),
    );
    /*
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
                ? webview01 //w_webview0 // WebViewContainer(key: webViewKey)
                : Padding(
              padding: EdgeInsets.fromLTRB(30, 50, 30, 0),
              child: CustomNoInternet00(
                noInternetVis,
                "Koneksi Internetmu terganggu, \n Pastikan internetmu lancar dengan cek data, Wifi, atau jaringan di tempatmu",
                Icons.signal_wifi_off,
              ),
            ),
            popup00(progBar),
            popup01_loader(progBar, "Loading Data ...")
          ],
        ),
      ),
    );*/
  }

  // Method to refresh the page
  Future<void> refreshList0() async {
    await Future.delayed(Duration(seconds: 1));
    refreshUlang();
    return null;
  }

  refreshUlang() {
    setState(() {
      ulang1 = 0;
    });
    if (idf_user != "" && ulang1 == 0) {
      _webViewController.loadRequest(Uri.parse(
          AppConfig().url_APIRoot + 'mobile/mob_notifikasi.php?idf_user=' + idf_user));
      debugPrint("Reloading page with new URL");
      setState(() {
        ulang1 += 1;
      });
    }
  }

  // Method to get user preferences
  getUserPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    var a = prefs.getString("idf_user") ?? "";
    await getUserPrefs_1(a);
  }

  // Method to update user ID
  getUserPrefs_1(idf_user0) {
    setState(() {
      idf_user = idf_user0;
      if (idf_user != "") {
        debugPrint('${idf_user} ooooo');
        //pop00Visible = true;
        //ambilDataUser(idf_user);
      }
    });
  }
}
