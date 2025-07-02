import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter/services.dart';

import '../../values/values.dart';

Future<void> launchWebUri({
  required BuildContext context,
  required String url,
  String title = 'Web Page',
}) async {
  final WebUri webUri = WebUri(url);

  // Set status bar color to match scaffold before pushing
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: AppColor.pageColor,
      statusBarIconBrightness:
          Brightness.dark, // or Brightness.light based on background
    ),
  );

  await Navigator.push(
    context,
    MaterialPageRoute(
      builder:
          (_) => Scaffold(
            backgroundColor: AppColor.pageColor,
            appBar: AppBar(
              backgroundColor: AppColor.pageColor,
              elevation: 0,
              title: Text(title),
            ),
            body: InAppWebView(
              initialUrlRequest: URLRequest(url: webUri),
              initialSettings: InAppWebViewSettings(javaScriptEnabled: true),
              onLoadStart: (controller, url) {
                print("Loading started: $url");
              },
              onLoadStop: (controller, url) {
                print("Finished loading: $url");
              },
              onLoadError: (controller, url, code, message) {
                print("Load error [$code]: $message");
              },
            ),
          ),
    ),
  );

  // Optionally reset status bar when returning back
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // or your original app bar color
      statusBarIconBrightness: Brightness.dark,
    ),
  );
}
