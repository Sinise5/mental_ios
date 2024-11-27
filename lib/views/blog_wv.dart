import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
//import 'package:webview_flutter/platform_interface.dart';
// Import for Android features.
import 'package:webview_flutter_android/webview_flutter_android.dart';
// Import for iOS/macOS features.
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import '../konfig000.dart';
import '../myWidget.dart';

class Blog_WV0 extends StatefulWidget {
  @override
  _Blog_WV0State createState() => _Blog_WV0State();
}

class _Blog_WV0State extends State<Blog_WV0> {

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late GlobalKey<RefreshIndicatorState> refreshKey;
  String idf_user = "", sf_blog_url = "all";
  bool progBar = true;
  bool noInternetVis = false;


  late WebViewController _webViewController;
  final _keyWebview = GlobalKey();
  int ulang1 = 0 ; //biasanya yg pertama param ga kebawa
  //late final WebViewController;

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

    Widget webView2 = WebViewWidget(
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
              if (idf_user != "" && ulang1 == 0) {
                String url0 = 'https://rejiwa.id/blog';
                if (sf_blog_url != 'all' && sf_blog_url != '') {
                  url0 = sf_blog_url;
                }
                _webViewController.loadRequest(Uri.parse(url0));
                debugPrint("lagiiiii");
                ulang1 += 1;
              }
            },
            onWebResourceError: (WebResourceError error) {
              debugPrint('Page error loading: $error');
              noInternetVis = true;
            },
          ),
        )
        ..addJavaScriptChannel(
          'Toaster',
          onMessageReceived: (JavaScriptMessage message) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message.message)),
            );
          },
        )
        ..loadRequest(Uri.parse('about:blank')),
    );

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
            title: Text('Blog Rejiwa'),
            backgroundColor: Colors.teal,
            bottom: progBar == true
                ? MyLinearProgressIndicator( backgroundColor: Colors.green, )
                : null
        ),
        body: RefreshIndicator(
            key: refreshKey,
            onRefresh: () async {
              await refreshList0();
            },
            child: Stack(
              children: [

                noInternetVis == false
                    ? webView2 //w_webview0 //WebViewContainer(key: webViewKey)
                    : Padding(
                  padding: EdgeInsets.fromLTRB(30, 50, 30, 0),
                  child: CustomNoInternet00(noInternetVis, "Koneksi Internetmu terganggu, \n Pastikan internetmu lancar dengan cek data, Wifi, atau jaringan di tempatmu", Icons.signal_wifi_off),
                )

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
      //_webViewController.loadUrl(AppConfig().url_APIRoot+'mobile/mob_blog.php?idf_user='+idf_user);

      String url0 = 'https://rejiwa.id/blog';
      if(sf_blog_url != 'all' && sf_blog_url != '') { url0 = sf_blog_url; }
     // _webViewController.loadUrl(url0);
      _webViewController.loadRequest(Uri.parse(url0));

      debugPrint("lagiiiii");
      setState(() {
        ulang1 += 1;
      });
    }

  }


  getUserPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    var a = prefs.getString("idf_user") ?? "";
    var b = prefs.getString("sf_blog_url") ?? "all";

    getUserPrefs_1(a, b);
  }

  getUserPrefs_1(idf_user0, bb0) {
    setState(() {
      idf_user = idf_user0;
      sf_blog_url = bb0;

      if(idf_user != ""){
        //pop00Visible = true;
        //ambilDataUser(idf_user);
      }

    });
  }

}


class MyLinearProgressIndicator extends LinearProgressIndicator  implements PreferredSizeWidget {
  MyLinearProgressIndicator({
    Key? key,
    double? value,
    Color? backgroundColor,
    Animation<Color>? valueColor,
  }) : super(
    key: key,
    value: value,
    backgroundColor: backgroundColor,
    valueColor: valueColor,
  ) {
    preferredSize = Size(double.infinity, 3.0);
  }

  @override
  Size preferredSize = Size(double.infinity, 3.0);
}